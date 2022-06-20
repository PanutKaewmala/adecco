import json

from django.db.models import Prefetch, Q
from django_filters.rest_framework import DjangoFilterBackend
from drf_spectacular.utils import extend_schema
from rest_framework import viewsets, mixins
from rest_framework.decorators import action
from rest_framework.exceptions import ValidationError
from rest_framework.filters import OrderingFilter
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.viewsets import GenericViewSet

from main.apps.activities.models import LeaveTypeSetting, LeaveType
from main.apps.common.functions import user_in_admin_or_manager_roles
from main.apps.common.permissions import IsSuperAdminOrAdmin, IsAssociate, AdminRoleWritePermission
from main.apps.common.utils import optimize_expanded_query
from main.apps.common.views import ActionRelatedSerializerMixin
from main.apps.managements.constants import PIN_POINT_TYPE_TEMPLATE
from main.apps.managements.filters import ClientFilter, ProjectFilter, WorkPlaceFilter, PinPointTypeFilter, \
    ClientLeaveTypeSettingFilter, WorkingHourFilter, OTRuleFilter, BusinessCalendarFilter
from main.apps.managements.functions.projects import get_employee_project_from_user
from main.apps.managements.models import Project, Client, WorkPlace, PinPointType, WorkingHour, OTRule, BusinessCalendar
from main.apps.managements.serializers.business_calendars import BusinessCalendarSerializer, DefaultBusinessCalendar
from main.apps.managements.serializers.clients import ClientRetrieveSerializer, \
    ClientListSerializer, ClientLeaveTypeSettingSerializer, ClientCreateUpdateSerializer
from main.apps.managements.serializers.ot_rules import OTRuleSerializer
from main.apps.managements.serializers.pin_point_types import PinPointTypeWriteSerializer, \
    PinPointTypeRetrieveSerializer, PinPointTypeListSerializer
from main.apps.managements.serializers.projects import ProjectSerializer, ProjectRetrieveSerializer, \
    ProjectCreateSerializer
from main.apps.managements.serializers.working_hours import WorkingHourForRosterSerializer, \
    WorkingHourRetrieveSerializer, WorkingHourCreateSerializer, WorkingHourListSerializer
from main.apps.managements.serializers.workplaces import WorkPlaceCommonSerializer, WorkPlaceListSerializer, \
    WorkPlaceRetrieveSerializer, WorkPlaceCreateSerializer
from main.apps.users.models import User, EmployeeProject


class ProjectViewSet(ActionRelatedSerializerMixin, viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated, IsSuperAdminOrAdmin]
    queryset = Project.objects.select_related('project_manager', 'client') \
        .prefetch_related('employee_projects', 'employee_projects__employee').all().order_by('-id')
    list_serializer_class = ProjectSerializer
    retrieve_serializer_class = ProjectRetrieveSerializer
    write_serializer_class = ProjectCreateSerializer
    filterset_class = ProjectFilter
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    ordering_fields = ('name', 'description', 'start_date', 'end_date')

    def get_queryset(self):
        user = self.request.user
        if not user_in_admin_or_manager_roles(user):
            self.queryset = self.queryset.filter(employee_projects__employee__user=user)
        self.queryset = optimize_expanded_query(
            request=self.request,
            queryset=self.queryset,
            prefetch_related={
                'price_tracking_settings': 'price_tracking_settings',
            }
        )
        return super().get_queryset()

    @extend_schema(responses=WorkingHourForRosterSerializer)
    @action(detail=True, methods=['GET'], permission_classes=[IsAuthenticated],
            url_path='working-hours', url_name='working-hours')
    def working_hours(self, request, pk=None):
        project = self.get_object()  # type: Project
        working_hours = WorkingHour.objects.filter(Q(project=project) | Q(client=project.client))
        serializer = WorkingHourForRosterSerializer(working_hours, many=True)
        return Response(serializer.data)

    @extend_schema(responses=WorkPlaceCommonSerializer)
    @action(detail=True, methods=['GET'], permission_classes=[IsAuthenticated, IsAssociate])
    def workplaces(self, request, pk=None):
        user = request.user  # type: User
        employee_project = get_employee_project_from_user(user, pk)  # type: EmployeeProject
        serializer = WorkPlaceCommonSerializer(employee_project.workplaces.all(), many=True)
        return Response(serializer.data)


class ClientViewSet(ActionRelatedSerializerMixin, viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated, IsSuperAdminOrAdmin]
    queryset = Client.objects.select_related('project_manager').all().order_by('-id')
    list_serializer_class = ClientListSerializer
    retrieve_serializer_class = ClientRetrieveSerializer
    write_serializer_class = ClientCreateUpdateSerializer
    filterset_class = ClientFilter
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    ordering_fields = ('name', 'branch')

    def get_queryset(self):
        user = self.request.user
        if not user_in_admin_or_manager_roles(user):
            self.queryset = self.queryset.filter(project_manager=user)
        self.queryset = optimize_expanded_query(
            request=self.request,
            queryset=self.queryset,
            prefetch_related={
                'merchandizer_questions': 'merchandizer_questions',
                'ot_rules': 'ot_rules',
                'business_calendars': 'business_calendars',
            }
        )
        return super().get_queryset()

    @action(detail=False, methods=['GET'], url_name='default-business-calendars', url_path='default-business-calendars',
            permission_classes=[IsAuthenticated, IsSuperAdminOrAdmin])
    def default_business_calendars(self, request):
        with open('main/apps/common/holidays/2022.json', 'r', encoding='utf-8') as file:
            raw_holiday = json.load(file)
            serializer = DefaultBusinessCalendar(raw_holiday, many=True)
        return Response(serializer.data)


class ClientLeaveTypeSettingViewSet(mixins.RetrieveModelMixin,
                                    mixins.UpdateModelMixin,
                                    mixins.ListModelMixin,
                                    GenericViewSet):
    queryset = Client.objects.prefetch_related(
        Prefetch(
            'leave_type_settings',
            LeaveTypeSetting.objects.all().order_by('id')
        )
    ).order_by('id')
    permission_classes = [IsAuthenticated, IsSuperAdminOrAdmin]
    serializer_class = ClientLeaveTypeSettingSerializer
    filterset_class = ClientLeaveTypeSettingFilter

    def update(self, request, *args, **kwargs):
        leave_type_settings_id_from_request = []

        instance = self.get_object()  # type: Client
        leave_type_settings_from_db = instance.leave_type_settings.get_queryset().values('id', 'name')

        leave_type_settings_id_from_db = [setting['id'] for setting in leave_type_settings_from_db]

        leave_type_settings = request.data['leave_type_settings']
        for leave_type_setting in leave_type_settings:
            leave_type_settings_id_from_request.append(leave_type_setting.get('id'))

        list_of_deleted_id = list(set(leave_type_settings_id_from_db).difference(leave_type_settings_id_from_request))
        list_of_deleted_name = [
            setting.get('name') for setting in leave_type_settings_from_db if setting.get('id') in list_of_deleted_id
        ]

        if list_of_deleted_id:
            leave_type_queryset = LeaveType.objects.filter(
                Q(leave_type_setting_id__in=list_of_deleted_id) |
                Q(leave_type_setting__default=True)
            )
            if leave_type_queryset:
                raise ValidationError({
                    'detail': f'Not able to delete Leave Type name: {list_of_deleted_name} because it\'s bind to Leave Name'
                })

        return super().update(request, *args, **kwargs)


class PintPointTypeViwSet(ActionRelatedSerializerMixin, viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated, AdminRoleWritePermission]
    queryset = PinPointType.objects.prefetch_related('questions').all().order_by('-id')
    list_serializer_class = PinPointTypeListSerializer
    retrieve_serializer_class = PinPointTypeRetrieveSerializer
    write_serializer_class = PinPointTypeWriteSerializer
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    filterset_class = PinPointTypeFilter
    ordering_fields = ('name', 'detail')

    def get_queryset(self):
        user = self.request.user
        if not user_in_admin_or_manager_roles(user):
            self.queryset = self.queryset.filter(employee_projects__employee__user=user)
        return super().get_queryset()

    @extend_schema(responses=PinPointTypeRetrieveSerializer)
    @action(detail=False, methods=['GET'], permission_classes=[IsAuthenticated, IsSuperAdminOrAdmin])
    def template(self, request):
        return Response(PIN_POINT_TYPE_TEMPLATE)


class WorkPlaceViewSet(ActionRelatedSerializerMixin, viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated, IsSuperAdminOrAdmin]
    list_serializer_class = WorkPlaceListSerializer
    retrieve_serializer_class = WorkPlaceRetrieveSerializer
    write_serializer_class = WorkPlaceCreateSerializer
    queryset = WorkPlace.objects.all().order_by('-id')
    filterset_class = WorkPlaceFilter
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    ordering_fields = ('name', 'address')


class WorkingHourViewSet(ActionRelatedSerializerMixin, viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated]
    queryset = WorkingHour.objects.all().order_by('-id')
    list_serializer_class = WorkingHourListSerializer
    write_serializer_class = WorkingHourCreateSerializer
    retrieve_serializer_class = WorkingHourRetrieveSerializer
    filterset_class = WorkingHourFilter
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    ordering_fields = ('name', 'project')


class OTRuleViewSet(viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated, IsSuperAdminOrAdmin]
    queryset = OTRule.objects.all().order_by('-id')
    filterset_class = OTRuleFilter
    serializer_class = OTRuleSerializer


class BusinessCalendarViewSet(viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated, IsSuperAdminOrAdmin]
    queryset = BusinessCalendar.objects.all().order_by('-id')
    filterset_class = BusinessCalendarFilter
    serializer_class = BusinessCalendarSerializer
