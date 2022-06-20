import django_filters
from django.db.models import QuerySet

from main.apps.activities.functions.activity_operator import filter_by_user_full_name
from main.apps.users.functions.employee import filter_by_employee_project_full_name
from main.apps.users.functions.users import filter_user_full_name, filter_master_data
from main.apps.users.models import User, Employee, Manager, EmployeeProject


class UserFilter(django_filters.FilterSet):
    full_name = django_filters.CharFilter(label='full name', method=filter_user_full_name)
    clients_id = django_filters.BaseInFilter(label='clients id', field_name='project_manager_clients')
    client_name = django_filters.CharFilter(label='client name',
                                            field_name='project_manager_clients__name',
                                            lookup_expr='icontains')
    master_data = django_filters.CharFilter(label='search id or full name', method=filter_master_data)

    class Meta:
        model = User
        fields = ('id', 'full_name', 'clients_id', 'client_name', 'role', 'phone_number', 'master_data')


class EmployeeFilter(django_filters.FilterSet):
    full_name = django_filters.CharFilter(label='full name', method=filter_by_user_full_name)
    projects = django_filters.BaseInFilter(label='projects', field_name='employee_projects__project')
    project = django_filters.NumberFilter(label='project', field_name='employee_projects__project')

    class Meta:
        model = Employee
        fields = ('position', 'nick_name', 'full_name', 'projects', 'project')


class ManagerFilter(django_filters.FilterSet):
    full_name = django_filters.CharFilter(label='full name', method=filter_by_user_full_name)
    projects = django_filters.BaseInFilter(label='project', field_name='projects', distinct=True)

    class Meta:
        model = Manager
        fields = ('full_name', 'projects')


class EmployeeProjectFilter(django_filters.FilterSet):
    full_name = django_filters.CharFilter(label='full name', method=filter_by_employee_project_full_name)
    merchandizers = django_filters.BooleanFilter(label='merchandizers', method='filter_merchandizers')

    class Meta:
        model = EmployeeProject
        fields = ('id', 'project', 'full_name')

    @staticmethod
    def filter_merchandizers(queryset: QuerySet[EmployeeProject], name, value) -> QuerySet:
        if value:
            queryset = queryset.exclude(merchandizers__isnull=True)
        return queryset
