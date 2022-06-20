from typing import NoReturn, List

from django.db.models import Q
from rest_framework.exceptions import ValidationError
from rest_framework.request import Request

from main.apps.common.functions import user_in_admin_or_manager_roles
from main.apps.rosters.choices import RosterStatusType, RosterType, ActionStatusType
from main.apps.rosters.models import Roster
from main.apps.users.models import EmployeeProject


def validate_employee_project_and_date_range_must_unique(validated_data: dict, instance: Roster = None) -> NoReturn:
    employee_projects = validated_data.get('employee_projects')  # type: List[EmployeeProject]
    start_date = validated_data.get('start_date')
    end_date = validated_data.get('end_date')

    error_messages = []
    for employee_project in employee_projects:
        queryset = Roster.objects.filter(
            Q(employee_projects__in=[employee_project]) &
            (
                    Q(end_date__range=(start_date, end_date)) |
                    Q(start_date__range=(start_date, end_date)) |
                    Q(start_date__lt=start_date, end_date__gt=end_date)
            )
        )
        if instance:
            queryset = queryset.exclude(id=instance.id)
        if queryset.exists():
            error_messages.append(
                {
                    'associate': f'associate {employee_project.employee.user.full_name} '
                                 f'start_date, end_date ({start_date} to {end_date}) '
                                 f'of project {employee_project.project.name} must unique.'
                }
            )

    if error_messages:
        raise ValidationError(error_messages, code='unique')


def validate_roster_setting(request: Request, validated_data):
    if user_in_admin_or_manager_roles(request.user):
        validated_data['roster_setting'] = True
        validated_data['status'] = RosterStatusType.APPROVE
    else:
        if len(validated_data['employee_projects']) != 1:
            raise ValidationError(
                {
                    'detail': 'Associate can request only one employee project'
                }
            )
    return validated_data


def edit_roster_change_status_to_pending(roster: Roster) -> Roster:
    if roster.type == RosterType.SHIFT:
        roster.shifts \
            .exclude(status__in=[ActionStatusType.EDIT_PENDING, ActionStatusType.DELETE]) \
            .update(status=ActionStatusType.PENDING)
    if roster.type == RosterType.DAY_OFF:
        roster.day_off.status = ActionStatusType.PENDING
        roster.day_off.save(update_fields=['status'])
    roster.status = RosterStatusType.PENDING
    roster.save(update_fields=['status'])
    return roster


def associate_edit_roster_change_status_to_pending(roster: Roster, user):
    return roster \
        if user_in_admin_or_manager_roles(user) \
        else edit_roster_change_status_to_pending(roster)
