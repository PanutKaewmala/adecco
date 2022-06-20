import copy
import datetime
from typing import Dict, List, Any, NoReturn

from rest_framework.exceptions import ValidationError
from rest_framework.request import Request

from main.apps.common.constants import DAY_OF_WEEK_LIST
from main.apps.common.functions import user_in_admin_or_manager_roles
from main.apps.common.utils import convert_string_to_date
from main.apps.managements.models import WorkingHour
from main.apps.rosters.choices import RosterStatusType, ActionStatusType
from main.apps.rosters.models import DayOff, Roster
from main.apps.rosters.serializers.rosters import RosterDayOffWriteSerializer
from main.apps.users.models import EmployeeProject


def prepare_day_off_create_data(data: dict) -> Dict:
    day_off = data['day_off']
    day_off['details'] = [
        {
            'date': date
        }
        for date in day_off.pop('detail_list', [])
    ]
    return data


def validate_admin_role_change_status_to_approve(user, validated_data):
    if user_in_admin_or_manager_roles(user):
        validated_data['status'] = RosterStatusType.APPROVE
        day_off = validated_data['day_off']
        day_off['status'] = ActionStatusType.APPROVE
    return validated_data


def update_or_create_roster_day_off(request: Request):
    context = {'request': request}
    if request.method == 'POST':
        day_off_create_data = prepare_day_off_create_data(request.data)
        validate_admin_role_change_status_to_approve(request.user, day_off_create_data)
        serializer = RosterDayOffWriteSerializer(data=day_off_create_data, context=context)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return serializer.data
    elif request.method == 'PATCH':
        roster_id = request.data.get('id')
        try:
            instance = Roster.objects.get(id=roster_id)
        except Roster.DoesNotExist:
            raise ValidationError(
                {
                    'detail': 'Not found roster'
                }
            )
        day_off_patch_data = prepare_day_off_create_data(request.data)
        validate_admin_role_change_status_to_approve(request.user, day_off_patch_data)
        serializer = RosterDayOffWriteSerializer(instance=instance, data=day_off_patch_data, context=context)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return serializer.data
    return None


class DayOffResponse:
    _workplaces_list: List[str]
    _holiday_list: List[str]
    _total_days: int
    _day_of_week_list: List[str]
    _day_of_week_without_holiday: List[str]
    _start_date: datetime.date

    def __init__(self, day_off_dict: Dict, day_off: DayOff = None, roster_dict: Dict = None, preview=False):
        self._day_off_dict = day_off_dict
        self._day_off = day_off
        self._roster_dict = roster_dict
        self._preview = preview

    def get_detail_for_mobile(self):
        self._set_workplaces_from_day_off_dict()
        self._set_holiday_list()
        self._set_total_days()
        self._start_date = self._day_off.roster.start_date
        self._set_day_of_week_from_total_day()
        self._set_day_of_week_without_holiday()
        return {
            **self._prepare_shift_from_dict(),
            **self._get_day_of_week_for_mobile()
        }

    def _prepare_shift_from_dict(self) -> Dict:
        return {
            'id': self._day_off_dict.get('id'),
            'from_date': self._day_off_dict.get('from_date'),
            'to_date': self._day_off_dict.get('to_date'),
            'working_hour': self._day_off_dict.get('working_hour'),
            'status': self._day_off_dict.get('status'),
        }

    def _get_day_of_week_for_mobile(self) -> Dict[str, List[str]]:
        return dict.fromkeys(self._day_of_week_without_holiday, self._workplaces_list)

    def _set_workplaces_from_day_off_dict(self) -> NoReturn:
        self._workplaces_list = self._day_off_dict.get('workplaces')

    def _set_holiday_list(self):
        self._holiday_list = self._day_off.get_holiday_days_list

    def _set_total_days(self):
        self._total_days = self._day_off.roster.get_total_days

    def _set_day_of_week_from_total_day(self):
        if self._total_days < 7:
            self._day_of_week_list = list(
                (self._start_date + datetime.timedelta(days=day)).strftime('%A').lower()
                for day in range(0, self._total_days + 1)
            )
        else:
            self._day_of_week_list = copy.deepcopy(DAY_OF_WEEK_LIST)

    def _set_day_of_week_without_holiday(self):
        self._day_of_week_without_holiday = list(day for day in self._day_of_week_list if day not in self._holiday_list)

    # Method for preview
    def get_preview_for_mobile(self) -> Dict[str, Any]:
        self._set_preview_workplaces()
        self._set_preview_holiday_list()
        self._set_preview_total_days()
        self._set_day_of_week_from_total_day()
        self._set_day_of_week_without_holiday()
        return {
            **self._prepare_preview_from_roster_dict(),
            **self._get_day_of_week_for_mobile()
        }

    def _prepare_preview_from_roster_dict(self):
        return {
            'from_date': self._roster_dict.get('start_date'),
            'to_date': self._roster_dict.get('end_date'),
            'working_hour': self._day_off_dict.get('working_hour'),
        }

    def _set_preview_workplaces(self):
        employee_projects = EmployeeProject.objects.filter(id__in=self._roster_dict.get('employee_projects')).first()
        self._workplaces_list = list(employee_projects.workplaces.all().values_list('name', flat=True))

    def _set_preview_holiday_list(self):
        working_hour = WorkingHour.objects.get(id=self._day_off_dict.get('working_hour_id'))
        self._holiday_list = list(day for day in DAY_OF_WEEK_LIST if not getattr(working_hour, day))

    def _set_preview_total_days(self):
        start_date = convert_string_to_date(self._roster_dict.get('start_date'))
        end_date = convert_string_to_date(self._roster_dict.get('end_date'))
        self._start_date = start_date
        self._total_days = (end_date - start_date).days
