from typing import Dict, NoReturn, OrderedDict

from django.db.models import QuerySet
from django.db.models.expressions import Value
from django.db.models.functions import Concat
from rest_framework.exceptions import ValidationError

from main.apps.rosters.choices import RosterType, ActionStatusType
from main.apps.rosters.functions.calendars import CalendarResponse
from main.apps.rosters.functions.day_offs import DayOffResponse
from main.apps.rosters.functions.shifts import ShiftResponse
from main.apps.rosters.models import Roster
from main.apps.rosters.serializers.rosters import RosterRetrieveSerializer, PreviewRosterTypeDayOffSerializer, \
    PreviewRosterTypeShiftSerializer, RosterWriteSerializer
from main.apps.users.models import EmployeeProject, User


def filter_employee_name_by_user(queryset: QuerySet, name, value) -> QuerySet:
    if value:
        queryset = queryset.annotate(
            full_name=Concat(
                'employee_projects__employee__user__first_name',
                Value(' '),
                'employee_projects__employee__user__last_name'
            )
        ).filter(full_name__icontains=value)
    return queryset


class RosterResponse:
    PREVIEW_SERIALIZER = {
        RosterType.SHIFT.value: PreviewRosterTypeShiftSerializer,
        RosterType.DAY_OFF.value: PreviewRosterTypeDayOffSerializer
    }
    _roster_dict: Dict or OrderedDict
    _roster_type: RosterType.choices

    def __init__(self, roster: Roster = None, queryset: QuerySet[Roster] = None, many=False, roster_dict=None,
                 preview=False):
        self._roster = roster
        self._queryset = queryset
        self._many = many
        self._roster_dict = roster_dict
        self._preview = preview
        self._set_roster_type()

    def get_detail_for_mobile(self) -> Dict:
        self._convert_roster_to_dict()
        self._set_shifts_to_roster_dict()
        return self._roster_dict

    def get_preview_for_mobile(self) -> Dict:
        self._prepare_preview_roster_dict()
        self._set_preview_calendar()
        self._set_shifts_to_roster_dict()
        return self._roster_dict

    def _convert_roster_to_dict(self) -> NoReturn:
        self._roster_dict = RosterRetrieveSerializer(self._roster).data

    def _set_shifts_to_roster_dict(self):
        if self._roster_type == RosterType.SHIFT:
            self._roster_dict['shifts'] = [
                ShiftResponse(
                    shift_dict=shift
                ).get_detail_for_mobile()
                for shift in self._roster_dict.get('shifts') if shift.get('status') != ActionStatusType.DELETE
            ]
        elif self._roster_type == RosterType.DAY_OFF and not self._preview:
            self._roster_dict['shifts'] = [
                DayOffResponse(
                    day_off_dict=day_off,
                    day_off=self._roster.day_off
                ).get_detail_for_mobile()
                for day_off in self._roster_dict.get('shifts')
            ]
        elif self._roster_type == RosterType.DAY_OFF and self._preview:
            self._roster_dict['shifts'] = [
                DayOffResponse(
                    day_off_dict=self._roster_dict.pop('day_off'),
                    roster_dict=self._roster_dict,
                    preview=True
                ).get_preview_for_mobile()
            ]

    def _set_roster_type(self):
        if self._roster:
            self._roster_type = self._roster.type
        else:
            self._roster_type = RosterType.SHIFT if 'shifts' in self._roster_dict else RosterType.DAY_OFF

    def _prepare_preview_roster_dict(self):
        serializer_class = self.PREVIEW_SERIALIZER.get(self._roster_type)
        serializer = serializer_class(data=self._roster_dict)
        serializer.is_valid(raise_exception=True)
        self._roster_dict = serializer.data

    def _set_preview_calendar(self):
        self._roster_dict['calendar'] = CalendarResponse(
            roster_dict=[self._roster_dict],
            preview=True
        ).get_preview_calendar_for_mobile()


class RosterDuplicate:
    _roster_dict: dict

    def __init__(self, roster: Roster, request_data: dict, request):
        self._roster = roster
        self._request_data = request_data
        self._to_employee_project_id = request_data.get('employee_project')
        self._context = {'request': request}

    def duplicate_roster(self):
        self._validate_employee_project_roster()
        self._set_roster_to_dict()
        self._remove_employee_project_from_roster_setting()
        return self._create_new_roster_request()

    def _validate_employee_project_roster(self) -> NoReturn:
        if not EmployeeProject.objects.filter(id=self._to_employee_project_id, rosters=self._roster).exists():
            raise ValidationError(
                {
                    'detail': f'Not found employee project {self._to_employee_project_id} in roster {self._roster}'
                }
            )
        if not self._roster.roster_setting:
            raise ValidationError(
                {
                    'detail': 'Only roster setting can duplicate'
                }
            )
        if self._roster.type == RosterType.DAY_OFF:
            raise ValidationError(
                {
                    'detail': 'Roster day-off not allow to duplicate'
                }
            )

    def _set_roster_to_dict(self):
        self._roster_dict = RosterWriteSerializer(self._roster).data
        self._clean_roster_dict()
        self._set_employee_project_and_roster_request()

    def _clean_roster_dict(self):
        self._user = User.objects.get(employee__employee_projects=self._to_employee_project_id)
        self._roster_dict.pop('id', None)
        self._roster_dict.update({
            'name': f'{self._roster_dict.get("name")} ({self._user.full_name})'
        })
        for shift in self._roster_dict.get('shifts'):
            shift.pop('id', None)
            shift.pop('roster', None)
            for schedule in shift.get('schedules'):
                schedule.pop('id', None)
                schedule.pop('shift', None)

    def _set_employee_project_and_roster_request(self):
        self._roster_dict.update(
            {
                'employee_projects': [self._to_employee_project_id],
                'roster_setting': False
            }
        )

    def _remove_employee_project_from_roster_setting(self):
        self._roster.employee_projects.remove(self._to_employee_project_id)

    def _create_new_roster_request(self):
        serializer = RosterWriteSerializer(data=self._roster_dict, context=self._context)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return serializer.data
