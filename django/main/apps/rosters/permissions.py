import datetime

from rest_framework.exceptions import ValidationError
from rest_framework.permissions import BasePermission
from rest_framework.request import Request

from main.apps.common.functions import user_in_associate_role
from main.apps.rosters.choices import RosterType, RosterStatusType
from main.apps.rosters.models import Roster, Shift


class CanEditShift(BasePermission):
    message = 'edit shift not allow'

    def has_permission(self, request, view):
        roster = view.get_object()  # type: Roster
        from_shift = request.data.get('from_shift', None)
        try:
            shift = Shift.objects.get(id=from_shift, roster=roster)  # type: Shift
        except Shift.DoesNotExist:
            raise ValidationError(
                {
                    'detail': f'not found shift {from_shift}'
                }
            )

        shift_not_start = datetime.date.today() < shift.from_date
        shift_status_approve = roster.status == RosterStatusType.APPROVE

        if not shift_not_start:
            self.message = 'shift already started'
        if not shift_status_approve:
            self.message = 'roster must approve before edit shift'

        return roster.type == RosterType.SHIFT and shift_not_start and shift_status_approve


class RosterPlanParamsRequired(BasePermission):
    message = 'roster plans need params (date, roster_plan_type)'

    def has_permission(self, request, view):
        return 'roster_plan_type' in request.query_params and 'roster_plan_date' in request.query_params


class CanEditRoster(BasePermission):
    message = 'edit roster not allow'

    def has_permission(self, request: Request, view):
        if view.action in ['update', 'partial_update']:
            roster = view.get_object()  # type: Roster
            if roster.status == RosterStatusType.APPROVE and user_in_associate_role(request.user):
                return False
        return True
