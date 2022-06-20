import copy
import datetime
from typing import List, Dict

from main.apps.common.utils import get_list_of_date_by_start_date_and_total_days, get_total_days, convert_string_to_date


class RosterAutoShift:
    _shift_template: dict
    _start_date: datetime.date
    _end_date: datetime.date
    _total_day: int
    _date_list: List[datetime.date]
    _date_by_months: Dict[str, datetime.date]
    _shifts_results: List[dict]

    def __init__(self, validated_data):
        self._validated_data = validated_data
        self._shifts_date_range = []
        self._shifts_results = []
        self._prepare_data()

    def get_shifts(self):
        self._map_months_dict_to_shift_date_range()
        for date_data in self._shifts_date_range:
            shift = copy.deepcopy(self._shift_template)
            shift.update(date_data)
            self._shifts_results.append(shift)
        return self._shifts_results

    def _map_months_dict_to_shift_date_range(self):
        self._convert_date_list_to_months()
        for index, date in enumerate(self._date_by_months.values(), start=1):
            date_range = {
                'from_date': date.replace(day=self._start_date.day) if index == 1 else date.replace(day=1),
                'to_date': date
            }
            self._shifts_date_range.append(date_range)

    def _convert_date_list_to_months(self):
        self._date_by_months = {
            date.strftime('%Y-%m'): date for date in self._date_list
        }

    def _prepare_data(self):
        shifts = self._validated_data.get('shifts')
        self._shift_template = shifts.pop()
        self._start_date = convert_string_to_date(self._validated_data.get('start_date'))
        self._end_date = convert_string_to_date(self._validated_data.get('end_date'))
        self._total_day = get_total_days(self._start_date, self._end_date)
        self._date_list = get_list_of_date_by_start_date_and_total_days(self._start_date, self._total_day)
