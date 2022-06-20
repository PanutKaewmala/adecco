import django_filters
from django.db.models import QuerySet, Value
from django.db.models.functions import Concat

from main.apps.managements.models import Client, Project, WorkPlace, PinPointType, WorkingHour, OTRule, BusinessCalendar
from main.apps.managements.utils import filter_project_and_client


def filter_project_manager_by_user(queryset: QuerySet, name, value) -> QuerySet:
    if value:
        queryset = queryset.annotate(
            full_name=Concat('project_manager__first_name', Value(' '), 'project_manager__last_name')
        ).filter(full_name__icontains=value)
    return queryset


def filter_project_assignee_by_user(queryset: QuerySet, name, value) -> QuerySet:
    if value:
        queryset = queryset.annotate(
            full_name=Concat('project_assignee__first_name', Value(' '), 'project_assignee__last_name')
        ).filter(full_name__icontains=value)
    return queryset


class ClientFilter(django_filters.FilterSet):
    project_manager = django_filters.CharFilter(label='project manager', method=filter_project_manager_by_user)
    project_assignee = django_filters.CharFilter(label='project assignee', method=filter_project_assignee_by_user)
    name = django_filters.CharFilter(label='name', lookup_expr='icontains')

    class Meta:
        model = Client
        fields = '__all__'


class ProjectFilter(django_filters.FilterSet):
    project_manager = django_filters.CharFilter(label='project manager', method=filter_project_manager_by_user)
    name = django_filters.CharFilter(label='name', lookup_expr='icontains')

    class Meta:
        model = Project
        fields = '__all__'


class WorkPlaceFilter(django_filters.FilterSet):
    name = django_filters.CharFilter(label='name', lookup_expr='icontains')

    class Meta:
        model = WorkPlace
        fields = ('name', 'address', 'project')


class WorkingHourFilter(django_filters.FilterSet):
    project = django_filters.NumberFilter(label='project', method=filter_project_and_client)

    class Meta:
        model = WorkingHour
        fields = ('id', 'project', 'client')


class PinPointTypeFilter(django_filters.FilterSet):
    name = django_filters.CharFilter(label='name', lookup_expr='icontains')
    detail = django_filters.CharFilter(label='detail', lookup_expr='icontains')

    class Meta:
        model = PinPointType
        fields = ('name', 'detail', 'project')


class ClientLeaveTypeSettingFilter(django_filters.FilterSet):
    name = django_filters.CharFilter(label='name', lookup_expr='icontains')

    class Meta:
        model = Client
        fields = ('name',)


class OTRuleFilter(django_filters.FilterSet):
    project = django_filters.NumberFilter(label='project', method=filter_project_and_client)

    class Meta:
        model = OTRule
        fields = ('id', 'project', 'client')


class BusinessCalendarFilter(django_filters.FilterSet):
    project = django_filters.NumberFilter(label='project', method=filter_project_and_client)
    name = django_filters.CharFilter(label='name', field_name='name', lookup_expr='icontains')

    class Meta:
        model = BusinessCalendar
        fields = ('id', 'project', 'client', 'type', 'name')
