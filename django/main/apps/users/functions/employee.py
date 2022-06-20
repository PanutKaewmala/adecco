import collections
import datetime
import typing

from django.db.models import Q, QuerySet
from rest_framework.exceptions import ValidationError
from rest_framework.request import Request

from main.apps.activities.choices import ActivityType
from main.apps.activities.functions.activity_operator import query_user_by_full_name
from main.apps.activities.models import Activity
from main.apps.common.utils import get_day_name_by_date_week_day
from main.apps.managements.models import Project, WorkPlace
from main.apps.rosters.choices import RosterType, DayStatusType, ActionStatusType, RosterStatusType
from main.apps.rosters.models import Roster, Shift, AdjustRequest
from main.apps.users.models import Employee, EmployeeProject
from main.apps.users.serializers.employees import EmployeeClientParamsSerializer


class EmployeeManagement:
    _parameter_serializer: typing.Callable

    # Data
    _employee: Employee
    _request: Request
    _parameter_data: typing.Dict
    _validated_data: collections.OrderedDict
    _start_date_target: datetime.date
    _end_date_target: datetime.date
    _project: Project
    _employee_project_target: EmployeeProject
    _single_date: bool
    _rosters_target: QuerySet[Roster]
    _adjust_request: AdjustRequest
    _results_function: typing.Callable
    _location_results: typing.List

    def __init__(self, employee: Employee, **kwargs):
        self._employee = employee
        self._request = kwargs.get('request')
        self._parameter_data = kwargs.get('parameter_data')
        self._parameter_serializer = kwargs.get('parameter_serializer', EmployeeClientParamsSerializer)
        self.init_request_parameter()
        self.init_master_data()

    # -------------------- Action Main --------------------
    def get_locations(self):
        self._results_function = self._data_to_locations
        self.map_master_data()
        return self._location_results

    def map_master_data(self):
        if self._adjust_request:
            self._to_results_function(
                workplaces=self._adjust_request.workplaces.all(),
                working_hour=self._adjust_request.working_hour
            )
        else:
            if self._rosters_target:
                self._get_workplaces_working_hour_from_roster()
            else:
                self._to_results_function()

    def init_master_data(self) -> typing.NoReturn:
        """ master data = roster, adjust-request """
        self._rosters_target = self._get_rosters_from_date_range()
        self._adjust_request = self._get_adjust_request()

    def init_request_parameter(self) -> typing.NoReturn:
        parameter_data = self._get_parameter_data()
        self._validated_data = self._get_validated_data_from_serializer(parameter_data)
        self._save_validate_data(self._validated_data)

    def _to_results_function(self, workplaces=None, working_hour=None, from_roster=False) -> typing.NoReturn:
        """
            right here will have workplace, working-hours from roster, adjust-request
        """
        if not workplaces:
            workplaces = self._get_employee_project_workplaces()

        # call function setting by main actions
        self._results_function(
            workplaces=workplaces,
            working_hour=working_hour,
            from_roster=from_roster,
        )

    # -------------------- Action --------------------
    def _data_to_locations(self, workplaces=None, working_hour=None, from_roster=False):
        self._location_results = []
        for workplace in workplaces:
            location_data = {
                'workplace': workplace,
                'project': self._project,
                'date': self._start_date_target,
                'working_hour': working_hour,
                'from_roster': from_roster,
                'activity': {
                    'check_in': None,
                    'check_out': None,
                    'pair_id': None,
                }
            }
            activity = self._get_check_in_check_out_date(workplace, working_hour)
            location_data['activity'].update(activity)
            self._location_results.append(
                location_data
            )

    def _get_workplaces_working_hour_from_roster(self):
        for roster in self._rosters_target.order_by('start_date'):
            if roster.type == RosterType.SHIFT:
                self._get_from_shifts_data(roster.shifts_without_delete.all())
            elif roster.type == RosterType.DAY_OFF:
                self._get_day_off_data(roster)

    def _get_from_shifts_data(self, shifts) -> typing.NoReturn:
        shifts_filter = self._filter_shifts_from_roster(shifts)
        for shift in shifts_filter.prefetch_related('schedules'):
            day_of_week = shift.get_day_of_week_with_details
            if self._is_date_in_range(self._start_date_target, shift.from_date, shift.to_date):
                day_name = get_day_name_by_date_week_day(self._start_date_target)
                data = day_of_week[day_name]
                if data.get('type') == DayStatusType.HOLIDAY:
                    self._to_results_function()
                else:
                    self._to_results_function(
                        workplaces=data['workplaces'],
                        working_hour=data['working_hour'],
                        from_roster=True
                    )

    def _get_day_off_data(self, roster: Roster) -> typing.NoReturn:
        self._date_day_off_list = roster.day_off.get_day_off_list
        working_hour = roster.day_off.working_hour
        self._date_holiday_list = roster.day_off.get_holiday_days_list

        if self._is_date_in_range(self._start_date_target, roster.start_date, roster.end_date):
            day_name = get_day_name_by_date_week_day(self._start_date_target)
            date_type = self._get_type_from_day_off(self._date_day_off_list, self._start_date_target, day_name)
            if date_type == DayStatusType.HOLIDAY:
                self._to_results_function()
            else:
                self._to_results_function(working_hour=working_hour, from_roster=True)

    def _save_validate_data(self, validated_data) -> typing.NoReturn:
        self._save_project_and_employee_project(validated_data)
        self._save_date(validated_data)

    # -------------------- Calculation --------------------
    def _get_check_in_check_out_date(self, workplace, working_hour=None) -> typing.Dict:
        activities = Activity.objects.filter(user=self._request.user, project=self._project,
                                             type=ActivityType.CHECK_IN,
                                             workplace=workplace, date_time__date=self._start_date_target)
        if working_hour:
            activities = activities.filter(working_hour=working_hour)
        check_in = activities.first()
        if check_in:
            check_out = check_in.check_out
            return {
                activity.type: {
                    'date_time': activity.date_time,
                    'extra_type': activity.extra_type,
                    'pair_id': check_in.check_in_pair,
                }
                for activity in [check_in, check_out] if activity
            }
        return {}

    @staticmethod
    def _is_date_in_range(target: datetime.date, start_date: datetime.date, end_date: datetime.date) -> bool:
        return start_date <= target <= end_date

    def _filter_shifts_from_roster(self, shifts: QuerySet[Shift]) -> QuerySet[Shift]:
        return shifts.filter(
            Q(status__in=[ActionStatusType.APPROVE, ActionStatusType.WAITING_FOR_DELETE]) &
            (
                    Q(from_date__range=(self._start_date_target, self._end_date_target)) |
                    Q(to_date__range=(self._start_date_target, self._end_date_target)) |
                    Q(from_date__lte=self._start_date_target, to_date__gte=self._end_date_target)
            )
        )

    def _get_type_from_day_off(self, date_day_off_list, date, day_name: str) -> str:
        if date in date_day_off_list:
            return DayStatusType.DAY_OFF
        return DayStatusType.HOLIDAY if day_name in self._date_holiday_list else DayStatusType.WORK_DAY

    def _get_employee_project_workplaces(self) -> QuerySet[WorkPlace]:
        return self._employee_project_target.workplaces.all()

    def _get_adjust_request(self) -> AdjustRequest:
        return AdjustRequest.objects.filter(
            date=self._start_date_target,
            employee_project=self._employee_project_target,
            type=DayStatusType.WORK_DAY
        ).order_by('-id').first()

    def _get_rosters_from_date_range(self) -> QuerySet[Roster]:
        return self._employee_project_target.rosters.filter(
            Q(status=RosterStatusType.APPROVE) &
            self._get_roster_filter_date_range()
        )

    def _get_roster_filter_date_range(self) -> Q:
        if self._single_date:
            return Q(
                start_date__lte=self._start_date_target,
                end_date__gte=self._start_date_target,
            )
        else:
            return (
                    Q(end_date__range=(self._start_date_target, self._end_date_target)) |
                    Q(start_date__range=(self._start_date_target, self._end_date_target)) |
                    Q(start_date__lt=self._start_date_target, end_date__gt=self._end_date_target)
            )

    def _save_date(self, validated_data) -> typing.NoReturn:
        validated_data = self._check_activity_remaining_yesterday(validated_data)

        self._single_date = validated_data.get('single_date', True)
        if self._single_date:
            self._start_date_target = validated_data.get('date')
            self._end_date_target = validated_data.get('date')
        else:
            self._start_date_target = validated_data.get('start_date')
            self._end_date_target = validated_data.get('end_date')

    def _check_activity_remaining_yesterday(self, validated_data):
        date = validated_data.get('date')
        date_yesterday = date - datetime.timedelta(days=1)
        activity = Activity.objects.filter(date_time__date=date_yesterday, project=self._project,
                                           type=ActivityType.CHECK_IN, user=self._employee.user)
        check_out_list = list(activity.values_list('check_in_pair__check_out', flat=True))
        if None in check_out_list:
            validated_data['date'] = date_yesterday

        return validated_data

    def _save_project_and_employee_project(self, validated_data) -> typing.NoReturn:
        self._project = validated_data.get('project')
        try:
            self._employee_project_target = self._employee.employee_projects.get(project_id=self._project)
        except EmployeeProject.DoesNotExist:
            raise ValidationError({'detail': f'Associate not found project <{self._project.name}>'})

    def _get_validated_data_from_serializer(self, data: typing.Dict) -> collections.OrderedDict:
        serializer = self._parameter_serializer(data=data)
        serializer.is_valid(raise_exception=True)
        return serializer.validated_data

    def _get_parameter_data(self) -> typing.Dict:
        return self._request.query_params if self._request else self._parameter_data


def filter_by_employee_project_full_name(queryset: QuerySet, name, value) -> QuerySet:
    return query_user_by_full_name(
        queryset=queryset,
        full_name=value,
        first_name_field='employee__user__first_name',
        last_name_field='employee__user__last_name',
    )
