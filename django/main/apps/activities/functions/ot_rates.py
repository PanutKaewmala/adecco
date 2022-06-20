import collections
import datetime
import typing

from django.db.models import Q, QuerySet

from main.apps.activities.choices import OTRequestType, OTRequestStatus
from main.apps.activities.models import OTRequest
from main.apps.activities.serializers.ot_rates import OTRateSerializer
from main.apps.common.utils import get_day_name_by_date_week_day, convert_time_to_datetime
from main.apps.managements.choices import DayOfWeekType, OTRuleDayType, OTRuleTimeType
from main.apps.managements.functions.lead_times import lead_time_dict
from main.apps.managements.models import OTRule, WorkingHour
from main.apps.users.functions.employee import EmployeeManagement
from main.apps.users.models import Employee


class OTRate(EmployeeManagement):
    _ot_rules: QuerySet[OTRule]
    _ot_request: OTRequest

    def __init__(self, employee: Employee, **kwargs):
        self._ot_request = kwargs.get('ot_request')
        self._ot_rates = []
        super().__init__(employee, **kwargs)

    # -------------------- Action --------------------
    def get_ot_rate(self):
        if not self._ot_request_from_associate():
            return None
        self.map_master_data()
        return self._convert_ot_rules_to_ot_rates(self._ot_rates)

    def init_master_data(self):
        super().init_master_data()
        self._ot_rules = self._set_ot_rules()

    def init_request_parameter(self):
        self._validated_data = collections.OrderedDict()
        self._validated_data['date'] = self._ot_request.start_date
        self._validated_data['project'] = self._ot_request.project
        self._save_validate_data(self._validated_data)

    def _to_results_function(self, workplaces=None, working_hour=None, from_roster=False) -> typing.NoReturn:
        day_name = get_day_name_by_date_week_day(self._start_date_target)
        ot_start_time, ot_end_time = self._get_start_time_and_end_time(self._ot_request)
        hours, minutes = self._time_delta_to_hours_and_minutes((ot_end_time - ot_start_time))
        hours_over_8_hours = hours - 8 if hours > 8 else 0

        for ot_rule in self._ot_rules:
            data = {
                'pay_code': ot_rule.pay_code_str,
                'ot_hours': '-',
                'total_hours': '-',
                'day_type': ot_rule.day,
                'time_type': ot_rule.time,
            }
            if working_hour:
                day_type = self._get_day_type(working_hour, day_name)
                if all([day_type == DayOfWeekType.WORKING_DAY, ot_rule.day == OTRuleDayType.WORKING_DAY,
                        ot_rule.time == OTRuleTimeType.OVER_NORMAL_TIME]):
                    data['ot_hours'] = f"{ot_start_time.strftime('%H:%M')} - {ot_end_time.strftime('%H:%M')}"
                    data['total_hours'] = self._hour_and_min_to_str(hours, minutes)
            else:
                if all([ot_rule.day == OTRuleDayType.DAY_OFF,
                        ot_rule.time == OTRuleTimeType.NORMAL_WORK_TIME]):
                    normal_hours = 8 if hours > 8 else hours
                    normal_ot_end_time = ot_start_time + datetime.timedelta(hours=8) if hours > 8 else ot_end_time
                    data['ot_hours'] = f"{ot_start_time.strftime('%H:%M')} - {normal_ot_end_time.strftime('%H:%M')}"
                    data['total_hours'] = self._hour_and_min_to_str(normal_hours, minutes)
                elif all([ot_rule.day == OTRuleDayType.DAY_OFF,
                          ot_rule.time == OTRuleTimeType.OVER_NORMAL_TIME, hours_over_8_hours]):
                    over_ot_start_time = ot_start_time + datetime.timedelta(hours=8) if hours > 8 else ot_end_time
                    data['ot_hours'] = f"{over_ot_start_time.strftime('%H:%M')} - {ot_end_time.strftime('%H:%M')}"
                    data['total_hours'] = self._hour_and_min_to_str(hours_over_8_hours, minutes)
            self._ot_rates.append(data)

    # -------------------- Calculation --------------------
    @staticmethod
    def _hour_and_min_to_str(hours: int, minutes: int) -> str:
        return f'{hours}.{minutes}'

    @staticmethod
    def _get_start_time_and_end_time(ot_request: OTRequest) -> [datetime.time, datetime.time]:
        if ot_request.status == OTRequestStatus.PARTIAL_APPROVE:
            start = ot_request.partial_start_time
            end = ot_request.partial_end_time
        else:
            start = ot_request.start_time
            end = ot_request.end_time
        start = convert_time_to_datetime(start)
        end = convert_time_to_datetime(end)
        return start, end

    @staticmethod
    def _time_delta_to_hours_and_minutes(time_delta: datetime.timedelta) -> [int, int]:
        times = str(time_delta).split(':')
        return int(times[0]), int(times[1])

    @staticmethod
    def _get_day_type(working_hour: WorkingHour, day_name: str) -> str:
        return DayOfWeekType.WORKING_DAY if getattr(working_hour, day_name) else DayOfWeekType.DAY_OFF

    @staticmethod
    def _get_start_time(instance: WorkingHour, date_name: str) -> typing.Dict:
        start_time = getattr(instance, f'{date_name}_start_time')
        lead_time_data = lead_time_dict(
            start_time,
            instance.lead_time_in_before,
            instance.lead_time_in_after,
        ) if start_time else None
        return lead_time_data

    @staticmethod
    def _get_end_time(instance: WorkingHour, date_name: str) -> typing.Dict:
        end_time = getattr(instance, f'{date_name}_end_time')
        lead_time_data = lead_time_dict(
            end_time,
            instance.lead_time_out_before,
            instance.lead_time_out_after,
        ) if end_time else None
        return lead_time_data

    @staticmethod
    def _convert_ot_rules_to_ot_rates(data) -> typing.Dict:
        serializer = OTRateSerializer(data, many=True)
        return serializer.data

    def _ot_request_from_associate(self) -> bool:
        return self._ot_request.type == OTRequestType.USER_REQUEST

    def _set_ot_rules(self) -> QuerySet[OTRule]:
        return OTRule.objects.filter(Q(client=self._ot_request.project.client) | Q(project=self._ot_request.project))
