import django_filters
from django.db.models import QuerySet, Q

from main.apps.common.utils import convert_string_to_date
from main.apps.rosters.choices import RosterStatusType, RosterPlanType
from main.apps.rosters.functions.adjust_requests import adjust_request_filter_employee_name_by_user
from main.apps.rosters.functions.edit_shift import edit_shift_filter_employee_name_by_user
from main.apps.rosters.functions.roster_plans import get_range_date_of_week
from main.apps.rosters.functions.rosters import filter_employee_name_by_user
from main.apps.rosters.models import Roster, EditShift, AdjustRequest


class RosterFilter(django_filters.FilterSet):
    date = django_filters.DateFilter(label='date', method='filter_roster_by_date')
    status = django_filters.ChoiceFilter(label='status', choices=RosterStatusType.choices)
    id = django_filters.NumberFilter(label='id', field_name='id')
    name = django_filters.CharFilter(label='roster name', lookup_expr='icontains')
    employee_name = django_filters.CharFilter(label='employee name', method=filter_employee_name_by_user)
    roster_plan_type = django_filters.ChoiceFilter(label='roster plan type', choices=RosterPlanType.choices,
                                                   method='filter_roster_plan_by_date_and_type')
    project = django_filters.NumberFilter(label='project', field_name='employee_projects__project')

    class Meta:
        model = Roster
        fields = '__all__'

    @staticmethod
    def filter_roster_by_date(queryset: QuerySet[Roster], name, value) -> QuerySet[Roster]:
        if value:
            return queryset.filter(
                Q(
                    start_date__month=value.month,
                    start_date__year=value.year,
                ) |
                Q(
                    end_date__month=value.month,
                    end_date__year=value.year,
                )
            )
        return queryset

    def filter_roster_plan_by_date_and_type(self, queryset: QuerySet[Roster], name, value) -> QuerySet[Roster]:
        roster_plan_date = convert_string_to_date(self.data.get('roster_plan_date'))
        if value == RosterPlanType.WEEK:
            start_date, end_date = get_range_date_of_week(roster_plan_date)
            return queryset.filter(
                Q(end_date__range=(start_date, end_date)) |
                Q(start_date__range=(start_date, end_date)) |
                Q(start_date__lt=start_date, end_date__gt=end_date)
            ).distinct()
        if value == RosterPlanType.MONTH:
            return queryset.filter(
                Q(
                    start_date__month=roster_plan_date.month,
                    start_date__year=roster_plan_date.year,
                ) |
                Q(
                    end_date__month=roster_plan_date.month,
                    end_date__year=roster_plan_date.year,
                )
            ).distinct()
        return queryset


class EditShiftFilter(django_filters.FilterSet):
    status = django_filters.ChoiceFilter(label='status', choices=RosterStatusType.choices)
    name = django_filters.CharFilter(label='roster name', lookup_expr='icontains',
                                     field_name='from_shift__roster__name')
    employee_name = django_filters.CharFilter(label='employee name', method=edit_shift_filter_employee_name_by_user)

    class Meta:
        model = EditShift
        fields = '__all__'


class AdjustRequestFilter(django_filters.FilterSet):
    employee_name = django_filters.CharFilter(label='employee name', method=adjust_request_filter_employee_name_by_user)
    month = django_filters.DateFilter(label='filter by month', method='filter_by_month')
    project = django_filters.NumberFilter(label='project', field_name='employee_project__project')

    class Meta:
        model = AdjustRequest
        fields = '__all__'

    @staticmethod
    def filter_by_month(queryset: QuerySet, name, value) -> QuerySet:
        return queryset.filter(date__month=value.month, date__year=value.year)
