import datetime
import typing

from main.apps.activities.choices import ActivityType
from main.apps.activities.models import Activity
from main.apps.common.utils import is_inside_radius
from main.apps.users.choices import DailyTaskType, TaskType
from main.apps.users.functions.employee import EmployeeManagement
from main.apps.users.serializers.employees import DailyTaskSerialzier


class DailyTaskClient(EmployeeManagement):
    _parameter_serializer = DailyTaskSerialzier
    _latitude = 0
    _longitude = 0
    _daily_tasks: typing.List

    def get_daily_tasks(self):
        self._results_function = self._no_roster_get_daily_tasks_from_activity
        self._daily_tasks = []

        self._get_track_routes()
        self._get_pin_points()

        if self._track_routes:
            self._create_daily_task_track_routes()
        if self._pin_points:
            self._create_daily_task_pin_points()

        if self._adjust_request:
            self._no_roster_get_daily_tasks_from_activity(
                workplaces=self._adjust_request.workplaces.all(),
                working_hour=self._adjust_request.working_hour
            )
        else:
            if self._rosters_target:
                self._get_workplaces_working_hour_from_roster()
            else:
                # No roster in Holiday check associate have activity(check_in, check_out)
                self._no_roster_get_daily_tasks_from_activity()

        return self._daily_tasks

    def init_request_parameter(self):
        super().init_request_parameter()
        self._latitude = self._validated_data.get('latitude')
        self._longitude = self._validated_data.get('longitude')

    def _get_track_routes(self):
        self._track_routes = Activity.objects.filter(user=self._employee.user, date_time__date=self._start_date_target,
                                                     type=ActivityType.TRACK_ROUTE)

    def _get_pin_points(self):
        self._pin_points = Activity.objects.filter(user=self._employee.user, date_time__date=self._start_date_target,
                                                   type=ActivityType.PIN_POINT)

    def _create_daily_task_track_routes(self):
        for track_route in self._track_routes:
            self._create_daily_task(
                location_name=track_route.location_name,
                daily_task_type=DailyTaskType.TRACK_ROUTE,
                inside=self._check_inside(track_route.longitude, track_route.latitude),
                from_roster=False,
                daily_task_from='track-route',
                tasks=[
                    {
                        'name': 'New Track Route',
                        'type': TaskType.TRACK_ROUTE,
                        'extra_type': None,
                        'date_time': track_route.date_time
                    }
                ]
            )

    def _create_daily_task_pin_points(self):
        for pin_point in self._pin_points:
            self._create_daily_task(
                location_name=pin_point.location_name,
                daily_task_type=DailyTaskType.PIN_POINT,
                inside=self._check_inside(pin_point.longitude, pin_point.latitude),
                from_roster=False,
                daily_task_from='pin-point',
                tasks=[
                    {
                        'name': 'Visit new store',
                        'type': TaskType.PIN_POINT,
                        'extra_type': None,
                        'date_time': pin_point.date_time
                    }
                ]
            )

    def _to_results_function(self, workplaces=None, working_hour=None, from_roster=False):
        if workplaces:
            for workplace in workplaces:
                activity = self._get_check_in_check_out_date(workplace, working_hour)
                tasks = self._create_roster_default_tasks(activity)
                self._create_daily_task(
                    location_name=workplace.name,
                    daily_task_type=DailyTaskType.DAILY_TASK,
                    inside=self._check_inside(workplace.longitude, workplace.latitude, workplace.radius_meter),
                    from_roster=from_roster,
                    daily_task_from='roster',
                    tasks=tasks
                )
        else:
            # No roster in Holiday check associate have activity(check_in, check_out)
            self._no_roster_get_daily_tasks_from_activity()

    def _no_roster_get_daily_tasks_from_activity(self, workplaces=None, working_hour=None):
        if not workplaces:
            workplaces = self._get_employee_project_workplaces()

        for workplace in workplaces:
            activity = self._get_check_in_check_out_date(workplace, working_hour)
            if activity:
                tasks = self._create_roster_default_tasks(activity)
                self._create_daily_task(
                    location_name=workplace.name,
                    daily_task_type=DailyTaskType.DAILY_TASK,
                    inside=self._check_inside(workplace.longitude, workplace.latitude, workplace.radius_meter),
                    from_roster=False,
                    daily_task_from='check in/out',
                    tasks=tasks
                )

    def _check_inside(self, location_longitude, location_latitude, radius_meter=300) -> bool:
        return is_inside_radius(
            longitude1=self._longitude,
            latitude1=self._latitude,
            longitude2=location_longitude,
            latitude2=location_latitude,
            radius_meter=radius_meter
        )

    def _create_daily_task(self, location_name=None, daily_task_type: DailyTaskType.choices = None,
                           inside=False, from_roster=False, tasks=None, daily_task_from=None):
        daily_task = {
            'name': location_name,
            'type': daily_task_type,
            'inside': inside,
            'daily_task_from': daily_task_from,
            'tasks': tasks
        }
        if daily_task_type == DailyTaskType.DAILY_TASK:
            self._create_mock_tasks(daily_task)
        self._add_daily_task_to_result(daily_task)

    @staticmethod
    def _create_roster_default_tasks(activity):
        return [
            {
                'name': 'Check In Time',
                'type': TaskType.CHECK_IN,
                'extra_type': activity.get('extra_type'),
                'date_time': activity.get(TaskType.CHECK_IN, None)
            },
            {
                'name': 'Check Out Time',
                'type': TaskType.CHECK_IN,
                'extra_type': activity.get('extra_type'),
                'date_time': activity.get(TaskType.CHECK_OUT, None)
            }
        ]

    @staticmethod
    def _create_mock_tasks(daily_task: dict):
        daily_task['tasks'].insert(
            1,
            {
                'name': 'MOCK TASK FOR TEST',
                'type': TaskType.TASK,
                'date_time': datetime.datetime.today().time()
            }
        )

    def _add_daily_task_to_result(self, daily_task):
        self._daily_tasks.append(
            daily_task
        )
