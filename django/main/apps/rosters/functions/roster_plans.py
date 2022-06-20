import copy
import datetime
from typing import Tuple

from django.db.models import QuerySet, Q

from main.apps.rosters.choices import RosterPlanType, ActionStatusType
from main.apps.rosters.models import Roster, Shift


def get_range_date_of_week(date: datetime.date) -> Tuple[datetime.date, datetime.date]:
    week_number = date.isocalendar().week
    plus_week_day = 1 if date.weekday() == 6 else 0
    start_date = datetime.datetime.strptime(
        f'{date.year}-W{int(week_number - 1 + plus_week_day)}-0', '%Y-W%W-%w'
    ).date()
    end_date = start_date + datetime.timedelta(days=6)
    return start_date, end_date


def filter_shifts_from_range_date(queryset: QuerySet[Shift],
                                  from_date: datetime.date,
                                  to_date: datetime.date) -> QuerySet[Shift]:
    return queryset.filter(
        Q(from_date__range=(from_date, to_date)) |
        Q(to_date__range=(from_date, to_date)) |
        Q(from_date__lte=from_date, to_date__gte=to_date)
    )


def filter_shifts_from_month(queryset: QuerySet[Shift],
                             roster_plan_date: datetime.date) -> QuerySet[Shift]:
    return queryset.filter(
        Q(
            from_date__month=roster_plan_date.month,
            from_date__year=roster_plan_date.year,
        ) |
        Q(
            to_date__month=roster_plan_date.month,
            to_date__year=roster_plan_date.year,
        )
    )


def get_shifts_queryset(roster: Roster,
                        roster_plan_date: datetime.date,
                        roster_plan_type: RosterPlanType.choices):
    shifts_queryset = roster.shifts.select_related('working_hour').exclude(
        status__in=[ActionStatusType.EDIT_PENDING, ActionStatusType.EDIT_REJECT, ActionStatusType.DELETE]
    ).all().order_by('from_date')
    if roster_plan_type == RosterPlanType.WEEK:
        start_date, end_date = get_range_date_of_week(roster_plan_date)
        return filter_shifts_from_range_date(shifts_queryset, start_date, end_date)
    if roster_plan_type == RosterPlanType.MONTH:
        return filter_shifts_from_month(shifts_queryset, roster_plan_date)


def convert_employee_project_to_objects(roster_plan_list):
    results = []
    for roster_plan in roster_plan_list:
        employee_projects = roster_plan.pop('employee_projects')
        results += [
            {
                'id': employee_project['id'],
                'title': employee_project['employee_name'],
                'start': shift.get('start'),
                'end': shift.get('end'),
                'meta': copy.deepcopy(shift)
            }
            for employee_project in employee_projects
            for shift in roster_plan.get('shifts')
        ]
    return results


def filter_shifts_from_roster_plan_type(queryset, roster_plan_date, roster_plan_type):
    if roster_plan_type == RosterPlanType.WEEK:
        start_date, end_date = get_range_date_of_week(roster_plan_date)
        return queryset.filter(
            Q(to_date__range=(start_date, end_date)) |
            Q(from_date__range=(start_date, end_date)) |
            Q(from_date__lt=start_date, to_date__gt=end_date)
        )
    if roster_plan_type == RosterPlanType.MONTH:
        return queryset.filter(
            Q(
                from_date__month=roster_plan_date.month,
                from_date__year=roster_plan_date.year,
            ) |
            Q(
                to_date__month=roster_plan_date.month,
                to_date__year=roster_plan_date.year,
            )
        )
    return queryset
