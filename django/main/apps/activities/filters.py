from datetime import datetime

import django_filters
from django.db.models import QuerySet, Value, Q
from django.db.models.functions import Concat
from rest_framework.exceptions import ValidationError

from main.apps.activities.choices import ActivityType, OTRequestStatus
from main.apps.activities.functions.activity_operator import filter_by_user_full_name
from main.apps.activities.models import LeaveRequest, Activity, UploadAttachment, OTRequest, LeaveTypeSetting
from main.apps.common.constants import EXCLUDE_TIME_STAMP_FIELDS
from main.apps.managements.models import Project
from main.apps.users.models import Employee


class DailyTasksFilter(django_filters.FilterSet):
    date = django_filters.DateFilter()


class ActivityFilter(django_filters.FilterSet):
    date = django_filters.DateFilter(label='date', field_name='date_time__date')
    type = django_filters.ChoiceFilter(label='type', choices=ActivityType.choices)
    location_name = django_filters.CharFilter(label='location_name', lookup_expr='icontains')
    full_name = django_filters.CharFilter(label='full_name', method=filter_by_user_full_name)
    date_time = django_filters.DateTimeFromToRangeFilter(label='date_time')
    workplaces = django_filters.CharFilter(label='workplaces', field_name='workplaces__name', lookup_expr='icontains')

    class Meta:
        model = Activity
        exclude = (*EXCLUDE_TIME_STAMP_FIELDS, 'picture')


class LeaveRequestFilter(django_filters.FilterSet):
    full_name = django_filters.CharFilter(label='full_name', method=filter_by_user_full_name)
    type = django_filters.CharFilter(label='type', field_name='type__name', lookup_expr='iexact')
    project = django_filters.NumberFilter()

    class Meta:
        model = LeaveRequest
        fields = ('status', 'start_date', 'end_date', 'title', 'full_name', 'created_at', 'type')


class UploadAttachmentFilter(django_filters.FilterSet):
    class Meta:
        model = UploadAttachment
        fields = ('leave_request_id',)


class AttendanceHistoryFilter(django_filters.FilterSet):
    date = django_filters.DateFilter()


class LeaveRequestEachDayFilter(django_filters.FilterSet):
    status = django_filters.CharFilter(label='status', field_name='leave_request__status')
    type = django_filters.CharFilter(label='type', field_name='leave_request__type__name', lookup_expr='icontains')
    date = django_filters.DateFilter(label='date', field_name='date')
    month = django_filters.CharFilter(method='month_filter')
    project = django_filters.NumberFilter(label='project', field_name='leave_request__project__id')

    def month_filter(self, queryset, name, value):
        date = datetime.strptime(value, '%Y-%m-%d').date()
        return queryset.filter(date__month=date.month, date__year=date.year)


class LeaveQuotaFilter(django_filters.FilterSet):
    project = django_filters.CharFilter(label='project')


class LeaveQuotaDashboardFilter(django_filters.FilterSet):
    project = django_filters.NumberFilter(label='project', field_name='employee__employee_projects__project_id')
    full_name = django_filters.CharFilter(label='full_name', method='filter_full_name')
    client = django_filters.NumberFilter(label='client', field_name='employee__employee_projects__project__client_id')

    def filter_full_name(self, queryset: QuerySet, name, value) -> QuerySet:
        if value:
            queryset = queryset.annotate(
                full_name_concat=Concat('first_name', Value(' '), 'last_name')
            ).filter(full_name_concat__icontains=value)
        return queryset


class LeaveTypeSettingFilter(django_filters.FilterSet):
    client_name = django_filters.CharFilter(label='client_name', field_name='client__name', lookup_expr='icontains')
    project = django_filters.NumberFilter(label='project', method='filter_project')

    class Meta:
        model = LeaveTypeSetting
        fields = ('client', 'project')

    @staticmethod
    def filter_project(queryset, name, value) -> QuerySet:
        if not value:
            return queryset
        try:
            project = Project.objects.get(id=value)
            client_id = project.client_id
            queryset &= queryset.filter(
                Q(project_id=value) |
                Q(client_id=client_id, project_id=None)
            )
            return queryset
        except Project.DoesNotExist:
            raise ValidationError({'detail': 'Project does not exist'})


class PinPointFilter(django_filters.FilterSet):
    project = django_filters.NumberFilter(label='project', field_name='activity__project')
    date = django_filters.DateFilter(label='date', field_name='activity__date_time__date')
    type = django_filters.BaseInFilter(label='type id', field_name='type')
    name = django_filters.CharFilter(method='filter_answer_by_question')
    address = django_filters.CharFilter(method='filter_answer_by_question')
    branch = django_filters.CharFilter(method='filter_answer_by_question')
    owner = django_filters.CharFilter(method='filter_answer_by_question')
    telephone = django_filters.CharFilter(method='filter_answer_by_question')
    open_hours = django_filters.CharFilter(method='filter_answer_by_question')
    date_range = django_filters.DateFromToRangeFilter(label='date range', field_name='activity__date_time__date')

    def filter_answer_by_question(self, queryset, name, value):
        if value:
            name = name.replace('_', ' ')
            return queryset.filter(answers__question_name__icontains=name, answers__answer__icontains=value)
        return queryset


class TrackRouteFilter(django_filters.FilterSet):
    project = django_filters.NumberFilter(label='project', field_name='project')
    date = django_filters.DateFilter(label='date', field_name='date_time__date')
    start_date = django_filters.DateFilter(field_name='date_time__date', lookup_expr='gte')
    end_date = django_filters.DateFilter(field_name='date_time__date', lookup_expr='lte')


class LeaveTypeFilter(django_filters.FilterSet):
    client = django_filters.NumberFilter(label='client', field_name='client')
    project = django_filters.NumberFilter(label='project', method='filter_by_project')
    name = django_filters.CharFilter(label='name', lookup_expr='icontains')

    @staticmethod
    def filter_by_project(queryset, name, value):
        if value:
            try:
                project = Project.objects.get(id=value)
                client_id = project.client_id
                queryset &= queryset.filter(
                    Q(project_id=value) |
                    Q(client_id=client_id, project_id=None)
                )
                return queryset
            except Project.DoesNotExist:
                raise ValidationError({'detail': 'Project does not exist'})


class OTRequestFilter(django_filters.FilterSet):
    full_name = django_filters.CharFilter(label='full_name', method=filter_by_user_full_name)
    date = django_filters.DateFilter(label='date', method='filter_date_range')
    status = django_filters.CharFilter(label='status', method='filter_status')
    start_date = django_filters.DateFilter(field_name='start_date', lookup_expr='gte')
    end_date = django_filters.DateFilter(field_name='end_date', lookup_expr='lte')

    class Meta:
        model = OTRequest
        fields = ('id', 'date', 'type', 'status', 'project')

    @staticmethod
    def filter_date_range(queryset, name, value):
        return queryset.filter(start_date__lte=value, end_date__gte=value)

    @staticmethod
    def filter_status(queryset, name, value):
        if value == 'upcoming':
            return queryset.filter(status=OTRequestStatus.APPROVE, start_date__gte=datetime.today().date())
        if value == 'history':
            return queryset.filter(status=OTRequestStatus.APPROVE, start_date__lt=datetime.today().date())

        return queryset.filter(status=value)


class NoStatusFilter(django_filters.FilterSet):
    full_name = django_filters.CharFilter(label='full name', method=filter_by_user_full_name)

    class Meta:
        model = Employee
        fields = ('id', 'full_name')


class CalendarFilter(django_filters.FilterSet):
    project = django_filters.NumberFilter(label='project', field_name='employee_projects__project', required=True)


class AdditionalTypeFilter(django_filters.FilterSet):
    project = django_filters.NumberFilter(label='project', field_name='project', required=True)
