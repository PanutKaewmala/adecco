import calendar
import datetime
from typing import List, Dict, NoReturn

from django.db.models import QuerySet
from rest_framework import serializers
from rest_framework.request import Request

from main.apps.activities.models import LeaveRequestPartialApprove, OTRequest
from main.apps.common.constants import DAY_OF_WEEK_FROM_CALENDAR, DAY_OF_WEEK_LIST
from main.apps.common.utils import get_list_of_date_by_start_date_and_total_days, convert_string_to_date, \
    get_total_days, get_day_name_by_date_week_day
from main.apps.managements.models import WorkingHour
from main.apps.rosters.choices import RosterType, ActionStatusType, DayStatusType
from main.apps.rosters.models import Roster, AdjustRequest
from main.apps.rosters.serializers.rosters import RosterRetrieveSerializer


def calendar_params_required(request: Request) -> NoReturn:
    roster_id = request.GET.get('id')
    status = request.GET.get('status')
    date = request.GET.get('date')
    if not date and not status and not roster_id:
        raise serializers.ValidationError(
            {
                'detail': 'Calendar params required (id, date, status)'
            }
        )


class CalendarResponse:
    _day_of_week_for_shift: Dict
    _roster_first_month_date: datetime.date or None
    _roster_last_month_date: datetime.date or None

    def __init__(self, queryset: QuerySet[Roster] = None, roster_dict: List[Dict] = None,
                 roster_type: RosterType.choices = None, preview=False):
        self._queryset = queryset
        self._roster_list_dict = roster_dict
        self._roster_type = roster_type
        self._calendar_list = []
        self._month_name = ''
        self._preview = preview
        self._roster_first_month_date = None
        self._roster_last_month_date = None

    def get_calendar_for_mobile(self):
        self._set_roster_dict_from_queryset()
        return self._get_calendar_response()

    def get_preview_calendar_for_mobile(self):
        return self._get_calendar_response()

    def _get_calendar_response(self):
        self._map_roster_list_dict_to_calendar()
        self._set_month_date()
        return {
            'month_name': self._month_name,
            'calendars': self._calendar_list
        }

    def _set_roster_dict_from_queryset(self):
        serializer = RosterRetrieveSerializer(self._queryset, many=True)
        self._roster_list_dict = serializer.data

    def _set_month_name(self):
        if self._roster_first_month_date or self._roster_last_month_date:
            self._month_name = self._format_month_name(self._roster_first_month_date, self._roster_last_month_date)

    def _set_month_date(self):
        if self._queryset:
            self._roster_first_month_date = self._queryset.first().start_date
            self._roster_last_month_date = self._queryset.last().end_date
        elif self._roster_list_dict:
            self._roster_first_month_date = convert_string_to_date(self._roster_list_dict[0].get('start_date'))
            self._roster_last_month_date = convert_string_to_date(self._roster_list_dict[-1].get('end_date'))
        self._set_month_name()

    @staticmethod
    def _format_month_name(start_month: datetime.date, end_month: datetime.date) -> str:
        start_month_name = calendar.month_name[start_month.month]
        end_month_name = calendar.month_name[end_month.month]
        return f'{start_month_name} - {end_month_name}' if start_month_name != end_month_name else start_month_name

    def _map_roster_list_dict_to_calendar(self):
        if self._roster_list_dict:
            for roster in self._roster_list_dict:
                if roster.get('type') == RosterType.SHIFT:
                    self._map_shifts_dict_to_calendar(roster.get('shifts'))
                elif roster.get('type') == RosterType.DAY_OFF:
                    self._map_day_off_to_calendar(roster)
        else:
            self._add_date_range_with_type_to_calendar(
                date_range_list=[],
                date_status=None,
                roster_type=None
            )

    def _map_shifts_dict_to_calendar(self, shifts: List[Dict]) -> NoReturn:
        shifts_filter = self._exclude_shifts_status_not_display(shifts)
        for shift in shifts_filter:
            day_of_week_list_of_dict = self._get_day_of_week_from_schedules(shift)
            self._day_of_week_for_shift = self._combine_day_of_week_list(day_of_week_list_of_dict)
            start_date = convert_string_to_date(shift.get('from_date'))
            end_date = convert_string_to_date(shift.get('to_date'))
            date_list = get_list_of_date_by_start_date_and_total_days(
                start_date=start_date,
                total_days=shift.get('total_days', get_total_days(start_date, end_date))
            )
            self._add_date_range_with_type_to_calendar(
                date_range_list=date_list,
                date_status=shift.get('status'),
                roster_type=RosterType.SHIFT
            )

    @staticmethod
    def _exclude_shifts_status_not_display(shifts: List[Dict]) -> list[dict]:
        return list(
            shift for shift in shifts
            if shift.get('status') not in [ActionStatusType.EDIT_PENDING, ActionStatusType.EDIT_REJECT,
                                           ActionStatusType.DELETE]
        )

    @staticmethod
    def _get_day_of_week_from_schedules(shift) -> List[Dict]:
        return list(schedule for schedule in shift.get('schedules'))

    def _combine_day_of_week_list(self, day_of_week_list: List[Dict]) -> Dict:
        day_of_week_result = dict.fromkeys(DAY_OF_WEEK_FROM_CALENDAR, None)
        for day_of_week in day_of_week_list:
            for day_name, value in day_of_week.items():
                self._replace_value_if_not_work_day(day_of_week_result, day_name, value)
        return day_of_week_result

    @staticmethod
    def _replace_value_if_not_work_day(day_of_week_result, day_name, value):
        if day_name in DAY_OF_WEEK_FROM_CALENDAR and day_of_week_result[day_name] != 'work_day':
            day_of_week_result[day_name] = value

    def _map_day_off_to_calendar(self, roster_day_off: Dict) -> NoReturn:
        self._date_day_off_list = self._get_day_off_list(roster_day_off)
        self._holiday_list = self._get_holiday_list(roster_day_off)

        start_date = convert_string_to_date(roster_day_off.get('start_date'))
        end_date = convert_string_to_date(roster_day_off.get('end_date'))
        date_range_from_start_roster_to_end = get_list_of_date_by_start_date_and_total_days(
            start_date=start_date,
            total_days=roster_day_off.get('total_days', get_total_days(start_date, end_date))
        )
        self._add_date_range_with_type_to_calendar(
            date_range_list=date_range_from_start_roster_to_end,
            date_status=roster_day_off.get('status'),
            roster_type=RosterType.DAY_OFF
        )

    def _get_day_off_list(self, roster_day_off: dict):
        if self._preview:
            return list(convert_string_to_date(date) for date in roster_day_off['day_off'].get('detail_list'))
        return roster_day_off.get('day_off')

    def _get_holiday_list(self, roster_day_off: dict):
        if self._preview:
            return self._get_preview_holiday_list_from_dict(roster_day_off)
        return roster_day_off.get('holiday_list')

    @staticmethod
    def _get_preview_holiday_list_from_dict(roster_day_off: dict):
        day_off = roster_day_off.get('day_off')
        working_hour = WorkingHour.objects.get(id=day_off.get('working_hour_id'))
        return list(day for day in DAY_OF_WEEK_LIST if not getattr(working_hour, day))

    def _add_date_range_with_type_to_calendar(self,
                                              date_range_list: List[datetime.date],
                                              date_status: ActionStatusType.choices,
                                              roster_type: RosterType.choices):
        self._calendar_list += list(
            {
                'date': date,
                'type': self._get_type_of_date(date=date, date_status=date_status, roster_type=roster_type)
            }
            for date in date_range_list
        )

    def _check_holiday_or_work_day(self, date: datetime.date) -> str:
        day_name = get_day_name_by_date_week_day(date)
        return DayStatusType.HOLIDAY if day_name in self._holiday_list else DayStatusType.WORK_DAY

    def _get_type_of_date(self, date, date_status, roster_type):
        if roster_type == RosterType.SHIFT and (date_status == ActionStatusType.APPROVE or self._preview):
            return self._day_of_week_for_shift[get_day_name_by_date_week_day(date)]
        elif roster_type == RosterType.DAY_OFF:
            if date_status == ActionStatusType.PENDING and not self._preview:
                return ActionStatusType.PENDING
            return DayStatusType.DAY_OFF if date in self._date_day_off_list else self._check_holiday_or_work_day(date)
        return ActionStatusType.PENDING


class CalendarResponseForMobile(CalendarResponse):
    def __init__(self, queryset,
                 date: datetime.date,
                 obj_days_in_month: list[datetime.date],
                 leave_request_partial_approve_queryset: QuerySet[LeaveRequestPartialApprove],
                 ot_request_queryset: QuerySet[OTRequest],
                 adjust_request_queryset: QuerySet[AdjustRequest],
                 **kwargs):
        self.date = date
        self.obj_days_in_month = obj_days_in_month
        self.leave_request_partial_approve_queryset = leave_request_partial_approve_queryset
        self.ot_request_queryset = ot_request_queryset
        self.adjust_request_queryset = adjust_request_queryset

        self.leave_request_date_list = []
        self.ot_request_date_list = []
        self.adjust_request_date_list = []
        self.adjust_request_date_and_type_dict = {}

        self.get_ot_request_dates()
        self.get_leave_request_dates()
        self.get_adjust_request_dates()
        super().__init__(queryset=queryset, **kwargs)

    def get_adjust_request_dates(self):
        adjust_request_queryset = self.adjust_request_queryset.values('date', 'type')
        self.adjust_request_date_list = [i['date'] for i in adjust_request_queryset]
        self.adjust_request_date_and_type_dict = {i['date']: i['type'] for i in adjust_request_queryset}

    def get_ot_request_dates(self):
        for ot_request in self.ot_request_queryset:
            if ot_request.multi_day:
                delta = ot_request.end_date - ot_request.start_date
                ot_dates = get_list_of_date_by_start_date_and_total_days(ot_request.start_date, delta.days)
                self.ot_request_date_list.extend(ot_dates)
            else:
                self.ot_request_date_list.append(ot_request.start_date)
        self.ot_request_date_list = list(set(self.ot_request_date_list))
        self.ot_request_date_list.sort()

    def get_leave_request_dates(self):
        for leave_request_partial_approve in self.leave_request_partial_approve_queryset:
            if leave_request_partial_approve.approve is True:
                date = leave_request_partial_approve.date
                self.leave_request_date_list.append(date)

    def _map_shifts_dict_to_calendar(self, shifts: List[Dict]) -> NoReturn:
        shifts_filter = self._exclude_shifts_status_not_display(shifts)

        for shift in shifts_filter:
            day_of_week_list_of_dict = self._get_day_of_week_from_schedules(shift)
            self._day_of_week_for_shift = self._combine_day_of_week_list(day_of_week_list_of_dict)

            start_date = convert_string_to_date(shift.get('from_date'))
            end_date = convert_string_to_date(shift.get('to_date'))

            date_list = get_list_of_date_by_start_date_and_total_days(
                start_date=start_date,
                total_days=shift.get('total_days', get_total_days(start_date, end_date))
            )  # dates come from Roster plan but might cover several months.

            self._add_date_range_with_type_to_calendar(
                date_range_list=date_list,
                date_status=shift.get('status'),
                roster_type=RosterType.SHIFT
            )

    def _set_month_date(self):
        self._month_name = calendar.month_name[self.date.month]

    def _add_date_range_with_type_to_calendar(self,
                                              date_range_list: List[datetime.date],
                                              date_status: ActionStatusType.choices,
                                              roster_type: RosterType.choices):
        calendar_list = []
        for date in self.obj_days_in_month:
            if date_status:
                date_type_from_roster = self._get_type_of_date(date=date,
                                                               date_status=date_status,
                                                               roster_type=roster_type)
            else:
                date_type_from_roster = None
            calendar_dict = {
                'date': date,
                'type': []
            }

            if date in self.leave_request_date_list:
                calendar_dict['type'].append('leave')
            if date in self.ot_request_date_list:
                calendar_dict['type'].append('ot')
            if all([date in date_range_list, date_type_from_roster == DayStatusType.WORK_DAY,
                    date not in self.adjust_request_date_list]):
                calendar_dict['type'].append(date_type_from_roster)

            if date in self.adjust_request_date_list:
                day_status_type = self.adjust_request_date_and_type_dict[date]
                if day_status_type != DayStatusType.DAY_OFF:
                    calendar_dict['type'].append(DayStatusType.WORK_DAY)

            if calendar_dict['type']:
                calendar_list.append(calendar_dict)
        self._calendar_list = calendar_list
