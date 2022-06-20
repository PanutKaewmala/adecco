from typing import Dict, NoReturn

from django.db.models import QuerySet, Value
from django.db.models.functions import Concat
from rest_framework.exceptions import ValidationError
from rest_framework.request import Request

from main.apps.common.functions import user_in_admin_or_manager_roles
from main.apps.rosters.choices import ActionStatusType, EditActionStatusType
from main.apps.rosters.models import Roster, Shift, EditShift
from main.apps.rosters.serializers.shifts import ShiftSerializer


def edit_shift_filter_employee_name_by_user(queryset: QuerySet, name, value) -> QuerySet:
    if value:
        queryset = queryset.annotate(
            full_name=Concat(
                'from_shift__roster__employee_projects__employee__user__first_name',
                Value(' '),
                'from_shift__roster__employee_projects__employee__user__last_name'
            )
        ).filter(full_name__icontains=value)
    return queryset


class EditShiftAction:
    _to_shift: Shift
    _serializer_data: Dict

    def __init__(self,
                 roster: Roster = None,
                 from_shift: Shift = None,
                 request_data: dict = None,
                 edit_shift: EditShift = None,
                 request: Request = None):
        self._roster = roster
        self._from_shift = from_shift
        self._request_data = request_data
        self._edit_shift = edit_shift
        self._request = request
        self._from_shift_to_status = ActionStatusType.WAITING_FOR_DELETE
        self._to_shift_to_status = ActionStatusType.EDIT_PENDING
        self._edit_shift_status = EditActionStatusType.PENDING

    def create_edit_shift(self):
        self._validate_duplicate_edit_from_shift()
        self._check_role_request_user()
        self._set_status_of_from_shift_to_wait_for_delete()
        self._prepare_new_shift_data()
        self._save_new_shift()
        self._get_sequence_from_shift()
        self._save_edit_shift_record()
        return self._serializer_data

    def _validate_duplicate_edit_from_shift(self):
        if EditShift.objects.filter(from_shift=self._from_shift, status=EditActionStatusType.PENDING).exists():
            raise ValidationError(
                {
                    'detail': f'Shift {self._from_shift} still in pending'
                }
            )
        if self._from_shift.status == ActionStatusType.DELETE:
            raise ValidationError(
                {
                    'detail': f'From shift {self._from_shift} have deleted'
                }
            )

    def _check_role_request_user(self):
        if user_in_admin_or_manager_roles(self._request.user):
            self._from_shift_to_status = ActionStatusType.DELETE
            self._to_shift_to_status = ActionStatusType.APPROVE
            self._edit_shift_status = EditActionStatusType.APPROVE

    def _prepare_new_shift_data(self):
        self._request_data['roster'] = self._roster.id
        self._request_data['from_date'] = self._from_shift.from_date.strftime('%Y-%m-%d')
        self._request_data['to_date'] = self._from_shift.to_date.strftime('%Y-%m-%d')
        self._request_data['status'] = self._to_shift_to_status

    def _save_new_shift(self):
        serializer = ShiftSerializer(data=self._request_data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        self._to_shift = serializer.instance
        self._serializer_data = serializer.data

    def _set_status_of_from_shift_to_wait_for_delete(self) -> NoReturn:
        self._from_shift.status = self._from_shift_to_status
        self._from_shift.save(update_fields=['status'])

    def _get_sequence_from_shift(self):
        sequence_from_date = list(
            self._roster.shifts.filter(
                status__in=[ActionStatusType.APPROVE, ActionStatusType.WAITING_FOR_DELETE]
            ).order_by('from_date').values_list('from_date', flat=True)
        )
        try:
            self._sequence = sequence_from_date.index(self._to_shift.from_date) + 1
        except ValueError:
            self._sequence = 0

    def _save_edit_shift_record(self) -> NoReturn:
        EditShift.objects.create(
            from_shift=self._from_shift,
            to_shift=self._to_shift,
            status=self._edit_shift_status,
            sequence=self._sequence
        )

    def actions(self):
        status = self._request_data.get('status')
        if status == EditActionStatusType.APPROVE:
            self._approve()
        if status == EditActionStatusType.REJECT:
            self._reject()

        self._edit_shift.from_shift.save(update_fields=['status'])
        self._edit_shift.to_shift.save(update_fields=['status'])
        self._edit_shift.save(update_fields=['status'])

    def _approve(self):
        self._edit_shift.from_shift.status = ActionStatusType.DELETE
        self._edit_shift.to_shift.status = ActionStatusType.APPROVE
        self._edit_shift.status = EditActionStatusType.APPROVE

    def _reject(self):
        self._edit_shift.from_shift.status = ActionStatusType.APPROVE
        self._edit_shift.to_shift.status = ActionStatusType.EDIT_REJECT
        self._edit_shift.status = EditActionStatusType.REJECT
