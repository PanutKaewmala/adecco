import copy

from django.db.models import QuerySet
from rest_framework.request import Request

from main.apps.activities.choices import ActivityType
from main.apps.activities.serializers.no_status import ActivityAlreadyExistsSerializer
from main.apps.users.functions.employee import EmployeeManagement
from main.apps.users.models import Employee
from main.apps.users.serializers.employees import LocationParamsSerializer


class EmployeeNoStatus(EmployeeManagement):
    DEFAULT_NO_STATUS = {'check_in': True, 'check_out': True, 'pair_id': None}

    def __init__(self, employee: Employee, **kwargs):
        self._activity_no_status_exists = {}
        self._workplace_no_status = []
        super().__init__(employee, **kwargs)

    def get_dashboard(self):
        self._results_function = self._map_no_status_results
        self._get_no_status()
        dashboard = {
            'workplaces': [],
            'working_hour': []
        }
        for workplace in self._workplace_no_status:
            dashboard['workplaces'].append(workplace.get('workplace'))
            working_hour = workplace.get('working_hour')
            if working_hour:
                dashboard['working_hour'].append(working_hour)
        return dashboard

    def get_detail(self):
        self._results_function = self._map_no_status_results
        self._get_no_status()
        workplaces = [workplace.get('workplace') for workplace in self._workplace_no_status]
        return {
            'user': self._employee.user,
            'employee_project': self._employee_project_target,
            'activities': self._workplace_no_status,
            'workplaces': workplaces
        }

    def _get_no_status(self):
        self._set_activity_exists()
        self.map_master_data()
        return self._workplace_no_status

    def _set_activity_exists(self):
        """
            list of workplace from activity exists
            {
                workplace_id: {check_in: boolean, check_out: boolean, pair_id: int}
            }
        """
        queryset = self._employee.user.activities.filter(
            type__in=[ActivityType.CHECK_IN, ActivityType.CHECK_OUT],
            date_time__date=self._start_date_target,
            project=self._project
        )
        serializer_data = ActivityAlreadyExistsSerializer(queryset, many=True).data
        for activity in serializer_data:
            workplace_id = activity.get('workplace')
            type_name = activity.get('type')
            if workplace_id not in self._activity_no_status_exists:
                self._activity_no_status_exists.setdefault(workplace_id, copy.deepcopy(self.DEFAULT_NO_STATUS))
            self._activity_no_status_exists[workplace_id][type_name] = False
            self._activity_no_status_exists[workplace_id]['pair_id'] = activity.get('pair_id')

    def _map_no_status_results(self, workplaces=None, working_hour=None, from_roster=False):
        if not workplaces:
            workplaces = self._get_employee_project_workplaces()

        for workplace in workplaces:
            type_no_status = self._activity_no_status_exists.get(workplace.id, copy.deepcopy(self.DEFAULT_NO_STATUS))
            if any([type_no_status['check_in'], type_no_status['check_out']]):
                self._workplace_no_status.append(
                    {
                        'working_hour': working_hour,
                        'workplace': workplace,
                        'type_no_status': type_no_status
                    }
                )


def map_queryset_to_no_status(queryset: QuerySet[Employee], request: Request):
    return [
        {
            'user': employee.user,
            'date': request.query_params.get('date'),
            **EmployeeNoStatus(employee=employee, request=request,
                               parameter_serializer=LocationParamsSerializer).get_dashboard()
        }
        for employee in queryset
    ]
