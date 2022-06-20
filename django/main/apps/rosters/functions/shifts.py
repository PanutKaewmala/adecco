import copy
from typing import Dict, List, NoReturn

from main.apps.common.constants import DAY_OF_WEEK_DICT, DAY_OF_WEEK_LIST
from main.apps.rosters.choices import DayStatusType
from main.apps.rosters.models import Shift, Roster
from main.apps.rosters.utils import replace_empty_list_to_none


class ShiftResponse:
    _day_of_week_dict: Dict
    _schedules_list: List[Dict]
    _schedule_target: Dict
    _workplaces_list_target: List[str]

    def __init__(self, shift_dict: Dict):
        self._shift_dict: Dict = shift_dict

    def get_detail_for_mobile(self):
        self._day_of_week_dict: Dict = copy.deepcopy(DAY_OF_WEEK_DICT)
        self._set_work_places_to_day_of_week_dict()
        return {
            **self._prepare_shift_from_dict(),
            **self._get_day_of_week_for_mobile()
        }

    def _prepare_shift_from_dict(self) -> Dict:
        return {
            'id': self._shift_dict.get('id'),
            'from_date': self._shift_dict.get('from_date'),
            'to_date': self._shift_dict.get('to_date'),
            'working_hour': self._shift_dict.get('working_hour'),
            'status': self._shift_dict.get('status'),
        }

    def _get_day_of_week_for_mobile(self) -> Dict:
        return replace_empty_list_to_none(self._day_of_week_dict)

    def _set_work_places_to_day_of_week_dict(self) -> NoReturn:
        self._set_schedules_list_from_shifts_dict()
        for schedule in self._schedules_list:
            self._schedule_target = schedule
            self._set_workplaces_to_day_when_work_day()

    def _set_schedules_list_from_shifts_dict(self):
        self._schedules_list: List[Dict] = self._shift_dict.get('schedules', [])

    def _set_workplaces_to_day_when_work_day(self) -> NoReturn:
        self._get_workplaces_from_schedule()
        for day in DAY_OF_WEEK_LIST:
            if self._schedule_target[day] == DayStatusType.WORK_DAY:
                self._day_of_week_dict[day] += self._workplaces_list_target

    def _get_workplaces_from_schedule(self) -> NoReturn:
        self._workplaces_list_target = list(workplace['name'] for workplace in self._schedule_target.get('workplaces'))


def delete_shift_not_found_in_payload(instance: Roster, request_data):
    shifts_id = list(shift.get('id') for shift in request_data.get('shifts') if bool(shift.get('id')))
    Shift.objects.filter(roster=instance).exclude(id__in=shifts_id).delete()
