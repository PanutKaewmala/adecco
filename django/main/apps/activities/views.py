import datetime

from django.db.models import QuerySet, Q, Prefetch, Subquery, OuterRef
from django.utils import timezone
from django_filters.rest_framework import DjangoFilterBackend
from drf_spectacular.utils import extend_schema, OpenApiParameter
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.exceptions import ValidationError
from rest_framework.filters import OrderingFilter
from rest_framework.permissions import IsAuthenticated
from rest_framework.request import Request
from rest_framework.response import Response

from main.apps.activities.choices import LeaveStatus, ActivityType, OTRequestStatus
from main.apps.activities.filters import DailyTasksFilter, ActivityFilter, LeaveRequestFilter, UploadAttachmentFilter, \
    LeaveRequestEachDayFilter, LeaveQuotaFilter, LeaveTypeSettingFilter, PinPointFilter, TrackRouteFilter, \
    LeaveTypeFilter, OTRequestFilter, LeaveQuotaDashboardFilter, NoStatusFilter, CalendarFilter, AdditionalTypeFilter
from main.apps.activities.functions.activity_operator import objs_of_all_days_in_month, \
    get_value_date_from_query_params
from main.apps.activities.functions.inside_workplaces import get_inside_workplace_data
from main.apps.activities.functions.leave_operator import leave_request_actions, \
    collect_leave_dates_and_compare_in_month, check_type_of_calendar, check_status_of_checkin_checkout
from main.apps.activities.functions.no_status import map_queryset_to_no_status, EmployeeNoStatus
from main.apps.activities.functions.ot_operator import ot_request_actions, split_ot_request_to_employee_projects, \
    create_ot_request_list
from main.apps.activities.models import DailyTask, Activity, LeaveRequest, LeaveQuota, UploadAttachment, \
    LeaveRequestPartialApprove, LeaveTypeSetting, LeaveType, PinPoint, OTRequest, AdditionalType
from main.apps.activities.serializers.activities import ActivitySerializer, ActivityDashboardSerializer, \
    ActivityDetailSerializer, ActivityDateSerializer, CalendarActivitySerializer, OTRequestActionSerializer, \
    OTRequestAssignSerializer, OTRequestListSerializer, OTRequestWriteSerializer, OTRequestRetrieveSerializer
from main.apps.activities.serializers.leave_quotas import DailyTasksSerializer, LeaveQuotaSerializer, \
    LeaveQuotaReadSerializer, LeaveQuotaUpdateSerializer, \
    LeaveQuotaDashboardSerializer
from main.apps.activities.serializers.leave_requests import LeaveRequestSerializer, LeaveRequestRetrieveSerializer, \
    LeaveRequestDashboardSerializer, LeaveRequestPartialApproveSerializer, LeaveRequestEachDaySerializer, \
    LeaveRequestDetailSerializer, LeaveRequestActionSerializer, AdditionalTypeSerializer
from main.apps.activities.serializers.leave_types import LeaveTypeSettingSerializer, LeaveTypeListSerializer, \
    LeaveTypeWriteSerializer
from main.apps.activities.serializers.no_status import NoStatusDashboardSerializer, NoStatusDetailParamsSerializer, \
    NoStatusDetailSerializer
from main.apps.activities.serializers.pin_points import PinPointRetrieveSerializer, PinPointListSerializer, \
    PinPointWriteSerializer
from main.apps.activities.serializers.track_routes import TrackRouteSerializer, TrackRouteRetrieveSerializer, \
    InsideWorkPlaceParameterSerializer
from main.apps.activities.serializers.upload_attachments import UploadBulkAttachmentSerializer, \
    UploadAttachmentSerializer
from main.apps.activities.utils import last_day_of
from main.apps.common.functions import user_in_admin_or_manager_roles, user_in_associate_role
from main.apps.common.permissions import IsSuperAdminOrAdmin, IsAllRoles
from main.apps.common.utils import convert_string_to_date, create_list_all_dates_in_month
from main.apps.common.views import ActionRelatedSerializerMixin
from main.apps.rosters.functions.calendars import CalendarResponseForMobile
from main.apps.rosters.models import Roster, AdjustRequest
from main.apps.rosters.serializers.calendars import CalendarResponseSerializer
from main.apps.users.models import User, EmployeeProject, Employee
from main.apps.users.serializers.employees import LocationParamsSerializer


class DailyTasksViewSet(viewsets.ModelViewSet):
    queryset = DailyTask.objects.order_by('-all_day', 'start_time').select_related('place')
    serializer_class = DailyTasksSerializer
    permission_classes = [IsAuthenticated]
    filter_class = DailyTasksFilter


class ActivityViewSet(viewsets.ModelViewSet):
    queryset = Activity.objects.select_related('user', 'workplace', 'project').order_by('-date_time')
    serializer_class = ActivitySerializer
    permission_classes = [IsAuthenticated]
    filterset_class = ActivityFilter
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    ordering_fields = ('date_time', 'type', 'location_name')

    def get_queryset(self):
        user = self.request.user
        if not user_in_admin_or_manager_roles(user):
            self.queryset = self.queryset.filter(user=user)
        return super().get_queryset()

    @extend_schema(responses=ActivityDashboardSerializer)
    @action(detail=False, methods=['GET'], permission_classes=[IsAuthenticated, IsSuperAdminOrAdmin])
    def dashboard(self, request, *args, **kwargs):
        self.serializer_class = ActivityDashboardSerializer
        self.queryset = self.queryset.filter(type__in=[ActivityType.CHECK_IN, ActivityType.CHECK_OUT])
        queryset = self.filter_queryset(self.queryset)

        page = self.paginate_queryset(queryset)
        if page is not None:
            serializer = self.get_serializer(page, many=True)
            return self.get_paginated_response(serializer.data)

        serializer = self.get_serializer(queryset, many=True)
        return Response(serializer.data)

    @extend_schema(responses=ActivityDetailSerializer)
    @action(detail=True, methods=['GET'], permission_classes=[IsAuthenticated, IsSuperAdminOrAdmin])
    def details(self, request, pk=None):
        instance = self.get_object()  # type: Activity
        if instance.type not in [ActivityType.CHECK_IN, ActivityType.CHECK_OUT]:
            return Response(data={'detail': f'{instance.id} is not check in, check out'},
                            status=status.HTTP_403_FORBIDDEN)
        queryset = instance.same_check_in_out_pair  # type: QuerySet[Activity]
        workplaces = [activity.workplace.name for activity in queryset if activity.type == ActivityType.CHECK_IN]
        data = {
            'user': instance.user,
            'employee_project': instance.employee_project,
            'activities': queryset,
            'workplaces': workplaces
        }
        context = {'request': request}
        serializer = ActivityDetailSerializer(data, context=context)
        return Response(serializer.data)

    @action(detail=True, methods=['PATCH'], permission_classes=[IsAuthenticated, IsSuperAdminOrAdmin])
    def actions(self, request, pk=None):
        self.serializer_class = ActivitySerializer
        serializer = super().partial_update(request)

        return Response(serializer.data)

    @action(detail=False, methods=['POST'], url_path='clear-record', url_name='clear-record',
            permission_classes=[IsAuthenticated])
    def clear_record(self, request, pk=None):
        user = self.request.user
        Activity.objects.filter(user=user).delete()
        return Response({'detail': 'OK'})

    @extend_schema(parameters=[
        OpenApiParameter(name='date', required=False, type=str)
    ])
    @action(detail=False, methods=['GET'], permission_classes=[IsAuthenticated], url_path='attendance-histories',
            url_name='attendance-histories')
    def attendance_histories(self, request):
        date = get_value_date_from_query_params(self, query_params_name='date')
        year, month, last_day_of_month = last_day_of(date)
        days = objs_of_all_days_in_month(year, month, last_day_of_month)

        user = request.user
        activities_queryset = Activity.objects.filter(
            date_time__date__month=month,
            date_time__date__year=year,
            user=user,
        )

        leave_requests_queryset = LeaveRequest.objects.exclude(start_date__gte=timezone.localtime().today()).filter(
            start_date__month=month,
            start_date__year=year,
            user=user,
            status=LeaveStatus.HISTORY,
        )

        for activity in activities_queryset:
            date = activity.date_time.date().strftime('%Y-%m-%d')
            if activity.type == 'check_in':
                days[date]['check_in'] = activity.date_time
            if activity.type == 'check_out':
                days[date]['check_out'] = activity.date_time

        collect_leave_dates_and_compare_in_month(query_sets=leave_requests_queryset, all_days_in_month=days)
        results = [
            {
                'date_time': key,
                'check_in': value['check_in'],
                'check_out': value['check_out'],
                'status': check_status_of_checkin_checkout(value),
                'leave': value['leave']
            }
            for key, value in days.items()
        ]
        serializer = ActivityDateSerializer(results, many=True)
        return Response(serializer.data)

    @action(detail=False, methods=['POST'], url_path='inside-workplace', url_name='inside-workplace',
            permission_classes=[IsAuthenticated])
    def inside_workplace(self, request):
        serializer = InsideWorkPlaceParameterSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        return Response(get_inside_workplace_data(serializer.validated_data))

    @extend_schema(responses=NoStatusDashboardSerializer, parameters=[LocationParamsSerializer])
    @action(detail=False, methods=['GET'], permission_classes=[IsAuthenticated, IsSuperAdminOrAdmin],
            url_name='no-status-dashboard', url_path='no-status-dashboard', filterset_class=NoStatusFilter)
    def no_status_dashboard(self, request: Request, *args, **kwargs):
        queryset = Employee.objects.select_related('user').prefetch_related('user__activities') \
            .filter(employee_projects__project=request.query_params.get('project'))
        queryset = self.filter_queryset(queryset)
        page = self.paginate_queryset(queryset)
        if page is not None:
            data = map_queryset_to_no_status(page, request)
            serializer = NoStatusDashboardSerializer(data, many=True)
            return self.get_paginated_response(serializer.data)

        data = map_queryset_to_no_status(queryset, request)
        serializer = NoStatusDashboardSerializer(data, many=True)
        return Response(serializer.data)

    @extend_schema(responses=NoStatusDetailSerializer, parameters=[NoStatusDetailParamsSerializer])
    @action(detail=False, methods=['GET'], permission_classes=[IsAuthenticated, IsSuperAdminOrAdmin],
            url_name='no-status-detail', url_path='no-status-detail')
    def no_status_detail(self, request: Request, *args, **kwargs):
        serializer = NoStatusDetailParamsSerializer(data=request.query_params)
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data.get('user')
        detail_data = EmployeeNoStatus(employee=user.employee, request=request,
                                       parameter_serializer=NoStatusDetailParamsSerializer).get_detail()
        context = {'request': request, 'user': user}
        serializer = NoStatusDetailSerializer(detail_data, context=context)
        return Response(serializer.data)


class LeaveRequestViewSet(ActionRelatedSerializerMixin, viewsets.ModelViewSet):
    queryset = LeaveRequest.objects.select_related('user', 'type') \
        .prefetch_related('user__leave_quotas', 'leave_request_partial_approves').all()
    list_serializer_class = LeaveRequestEachDaySerializer
    retrieve_serializer_class = LeaveRequestRetrieveSerializer
    write_serializer_class = LeaveRequestSerializer
    permission_classes = [IsAuthenticated]
    filterset_class = LeaveRequestFilter
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    ordering_fields = ('date_time', 'start_date', 'end_date', 'title', 'description', 'status')

    def get_queryset(self):
        user = self.request.user
        if not user_in_admin_or_manager_roles(user):
            self.queryset = self.queryset.filter(user=user, start_date__year=timezone.localtime().year)
        return LeaveRequest.sort_by_status(super().get_queryset())

    def list(self, request, *args, **kwargs):
        queryset = LeaveRequestPartialApprove.objects.select_related(
            'leave_request'
        ).filter(leave_request__alive=True,
                 leave_request__user=self.request.user,
                 leave_request__start_date__year=timezone.localtime().year)
        self.filterset_class = LeaveRequestEachDayFilter
        queryset = self.filter_queryset(queryset)
        page = self.paginate_queryset(queryset)
        if page is not None:
            serializer = self.get_serializer(page, many=True)
            return self.get_paginated_response(serializer.data)

        serializer = self.get_serializer(queryset, many=True)
        return Response(serializer.data)

    def update(self, request, *args, **kwargs):
        instance = self.get_object()  # type: LeaveRequest
        if instance.status != LeaveStatus.PENDING:
            raise ValidationError({'detail': 'Not allow to edit if status is not pending'})
        return super().update(request, *args, **kwargs)

    @extend_schema(responses=LeaveRequestDashboardSerializer)
    @action(detail=False, methods=['GET'], permission_classes=[IsAuthenticated, IsSuperAdminOrAdmin],
            filterset_class=LeaveRequestFilter)
    def dashboard(self, request, *args, **kwargs):
        self.list_serializer_class = LeaveRequestDashboardSerializer
        serializer = super().list(request, *args, **kwargs)
        return Response(serializer.data)

    @extend_schema(responses=LeaveRequestDetailSerializer)
    @action(detail=True, methods=['GET'], permission_classes=[IsAuthenticated, IsSuperAdminOrAdmin])
    def details(self, request, pk=None):
        self.list_serializer_class = LeaveRequestDetailSerializer
        serializer = super().retrieve(request)
        return Response(serializer.data)

    @extend_schema(request=LeaveRequestActionSerializer)
    @action(detail=True, methods=['POST'], permission_classes=[IsAuthenticated, IsSuperAdminOrAdmin])
    def actions(self, request, pk=None):
        instance = self.get_object()  # type: LeaveRequest
        serializer = LeaveRequestActionSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.validated_data['leave_request_partial_approves'] = request.data.get('leave_request_partial_approves')
        leave_request_actions(instance, serializer.validated_data)

        self.list_serializer_class = LeaveRequestDashboardSerializer
        serializer = super().retrieve(request)

        return Response(serializer.data)

    @extend_schema(parameters=[
        OpenApiParameter(name='date', required=False, type=str)
    ])
    @action(detail=False, methods=['GET'], permission_classes=[IsAuthenticated])
    def calendars(self, request):
        date = get_value_date_from_query_params(self, query_params_name='date')
        year, month, last_day_of_month = last_day_of(date)
        days = objs_of_all_days_in_month(year, month, last_day_of_month)

        user = request.user
        leave_requests_queryset = LeaveRequest.objects.filter(
            Q(start_date__month=month, start_date__year=year)
            | Q(end_date__month=month, end_date__year=year),
            user=user
        ).distinct()
        collect_leave_dates_and_compare_in_month(query_sets=leave_requests_queryset, all_days_in_month=days)
        results = [
            {
                'date_time': key,
                'type': check_type_of_calendar(value),
                'work_day': None,
                'over_time': None,
                'leave': value['leave']
            }
            for key, value in days.items()
        ]

        serializer = CalendarActivitySerializer(results, many=True)
        return Response(serializer.data)

    @extend_schema(responses=LeaveRequestPartialApproveSerializer)
    @action(detail=True, methods=['GET'], url_path='get-partial-approve-list', url_name='get-partial-approve-list',
            permission_classes=[IsAuthenticated, IsSuperAdminOrAdmin])
    def get_partial_approve_list(self, request, pk=None):
        queryset = LeaveRequestPartialApprove.objects.select_related('leave_request').filter(leave_request_id=pk)
        serializer = LeaveRequestPartialApproveSerializer(queryset, many=True)
        return Response(serializer.data)


class LeaveQuotaViewSet(ActionRelatedSerializerMixin, viewsets.ModelViewSet):
    queryset = LeaveQuota.objects.select_related('type').order_by('id')
    write_serializer_class = LeaveQuotaSerializer
    list_serializer_class = LeaveQuotaReadSerializer
    update_serializer_class = LeaveQuotaUpdateSerializer
    permission_classes = [IsAuthenticated, IsAllRoles]
    filterset_class = LeaveQuotaFilter
    filter_backends = [DjangoFilterBackend, OrderingFilter]

    def get_queryset(self):
        user = self.request.user
        if user_in_associate_role(user):
            self.queryset = self.queryset.filter(user=user)
        return super().get_queryset()

    def get_permissions(self):
        if self.action in ('create', 'partial_update'):
            self.permission_classes = [IsSuperAdminOrAdmin]
        return super().get_permissions()

    @extend_schema(parameters=[
        OpenApiParameter(name='project', required=True, type=int)
    ], responses=LeaveQuotaDashboardSerializer)
    @action(detail=False, methods=['GET'], permission_classes=[IsAuthenticated, IsSuperAdminOrAdmin])
    def dashboard(self, request, *args, **kwargs):
        project = self.request.query_params.get('project')
        if not project:
            raise ValidationError({'detail': 'project is required.'})
        if project:
            queryset = User.objects.prefetch_related(
                'leave_quotas',
                'leave_quotas__type',
                'leave_quotas__project',
                'employee',
                Prefetch('employee__employee_projects', queryset=EmployeeProject.objects.filter(project_id=project))
            ).annotate(
                start_date=Subquery(
                    EmployeeProject.objects.filter(
                        employee=OuterRef('employee'),
                        project_id=project
                    ).order_by('id').values('start_date')[:1]
                )
            ).order_by('id')

        self.filterset_class = LeaveQuotaDashboardFilter
        queryset = self.filter_queryset(queryset)

        page = self.paginate_queryset(queryset)
        if page is not None:
            serializer = LeaveQuotaDashboardSerializer(page, many=True, project=project, context={'request': request})
            return self.get_paginated_response(serializer.data)

        serializer = LeaveQuotaDashboardSerializer(queryset, many=True, project=project, context={'request': request})
        return Response(serializer.data)

    @extend_schema(parameters=[
        OpenApiParameter(name='user', required=True, type=int)
    ], request=LeaveQuotaUpdateSerializer, responses=LeaveQuotaUpdateSerializer)
    @action(detail=False, methods=['PATCH'], permission_classes=[IsAuthenticated, IsSuperAdminOrAdmin],
            url_name='update-total', url_path='update-total')
    def update_total(self, request, *args, **kwargs):
        user = self.request.query_params.get('user')
        if not user:
            raise ValidationError({'detail': 'user is required'})
        serializer = LeaveQuotaUpdateSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        leave_quotas = serializer.validated_data.get('leave_quotas')

        leave_quotas_bulk = []
        for leave_quota in leave_quotas:
            if leave_quota.get('id'):
                LeaveQuota.objects.filter(id=leave_quota.get('id')).update(total=leave_quota.get('total'))
            else:
                leave_quotas_bulk.append(
                    LeaveQuota(
                        user_id=user,
                        type_id=leave_quota.get('type_id'),
                        total=leave_quota.get('total'),
                        project_id=leave_quota.get('project_id')
                    )
                )
        LeaveQuota.objects.bulk_create(leave_quotas_bulk)
        return Response(serializer.data)


class LeaveTypeViewSet(ActionRelatedSerializerMixin, viewsets.ModelViewSet):
    queryset = LeaveType.objects.all().order_by('id')
    permission_classes = [IsAuthenticated]
    list_serializer_class = LeaveTypeListSerializer
    write_serializer_class = LeaveTypeWriteSerializer
    filterset_class = LeaveTypeFilter


class UploadAttachmentViewSet(viewsets.ModelViewSet):
    queryset = UploadAttachment.objects.all()
    serializer_class = UploadAttachmentSerializer
    permission_classes = [IsAuthenticated]
    filterset_class = UploadAttachmentFilter

    def get_queryset(self):
        user = self.request.user
        if user_in_associate_role(user):
            self.queryset = self.queryset.filter(leave_request__user=user)
        return super().get_queryset()

    @extend_schema(description='"file" field can be multiple')
    @action(methods=['POST'], detail=False, url_path='bulk', url_name='bulk',
            serializer_class=UploadBulkAttachmentSerializer)
    def bulk(self, request):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        leave_request = serializer.validated_data.get('leave_request')
        objs = []
        for file in request.FILES.getlist('file'):
            instance = UploadAttachment(
                file=file,
                name=file.name,
                leave_request=leave_request,
            )
            objs.append(instance)
        upload_attachments = UploadAttachment.objects.bulk_create(objs)
        serializer = UploadAttachmentSerializer(upload_attachments, many=True, context={'request': request})
        return Response(serializer.data)


class LeaveTypeSettingViewSet(viewsets.ModelViewSet):
    queryset = LeaveTypeSetting.objects.all().order_by('id')
    permission_classes = [IsAuthenticated, IsSuperAdminOrAdmin]
    serializer_class = LeaveTypeSettingSerializer
    filterset_class = LeaveTypeSettingFilter


class PinPointViewSet(ActionRelatedSerializerMixin, viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated]
    queryset = PinPoint.objects.select_related('type', 'activity__user', 'activity__project') \
        .prefetch_related('answers').all().order_by('-id')
    write_serializer_class = PinPointWriteSerializer
    retrieve_serializer_class = PinPointRetrieveSerializer
    list_serializer_class = PinPointListSerializer
    filterset_class = PinPointFilter

    def get_queryset(self):
        user = self.request.user
        if not user_in_admin_or_manager_roles(user):
            self.queryset = self.queryset.filter(activity__user=user)
        return super().get_queryset()


class TrackRouteViewSet(viewsets.ReadOnlyModelViewSet):
    permission_classes = [IsAuthenticated, IsSuperAdminOrAdmin]
    queryset = Activity.objects.filter(type=ActivityType.TRACK_ROUTE).order_by('-id')
    filterset_class = TrackRouteFilter
    serializer_class = TrackRouteSerializer

    def retrieve(self, request, *args, **kwargs):
        self.serializer_class = TrackRouteRetrieveSerializer
        return super().retrieve(request, *args, **kwargs)


class OTRequestViewSet(ActionRelatedSerializerMixin, viewsets.ModelViewSet):
    queryset = OTRequest.objects.select_related('user', 'workplace') \
        .prefetch_related('project__client__ot_rules').all().order_by('-id')
    retrieve_serializer_class = OTRequestRetrieveSerializer
    list_serializer_class = OTRequestListSerializer
    write_serializer_class = OTRequestWriteSerializer
    permission_classes = [IsAuthenticated]
    filterset_class = OTRequestFilter

    def get_queryset(self):
        user = self.request.user
        if not user_in_admin_or_manager_roles(user):
            self.queryset = self.queryset.filter(user=user)
        return super().get_queryset()

    def create(self, request, *args, **kwargs):
        if user_in_admin_or_manager_roles(request.user):
            serializer = OTRequestAssignSerializer(data=request.data)
            serializer.is_valid(raise_exception=True)
            request_ot_list = split_ot_request_to_employee_projects(serializer.validated_data)
            serializer_create = create_ot_request_list(request, request_ot_list)
            return Response(serializer_create.data)

        return super().create(request, *args, **kwargs)

    @extend_schema(request=OTRequestActionSerializer)
    @action(detail=True, methods=['POST'], permission_classes=[IsAuthenticated, IsSuperAdminOrAdmin])
    def actions(self, request, pk=None):
        instance = self.get_object()  # type: OTRequest
        serializer = OTRequestActionSerializer(data=request.data, context={'ot_request': instance})
        serializer.is_valid(raise_exception=True)
        ot_request_actions(instance, serializer.validated_data)

        serializer = super().retrieve(request)
        return Response(serializer.data)


class CalendarViewSet(viewsets.ReadOnlyModelViewSet):
    permission_classes = [IsAuthenticated]
    queryset = Roster.objects.all() \
        .prefetch_related('shifts', 'shifts__schedules', 'shifts__working_hour', 'shifts__schedules__workplaces',
                          'employee_projects', 'employee_projects__employee__user', 'employee_projects__project')
    filterset_class = CalendarFilter
    serializer_class = CalendarResponseSerializer

    def get_queryset(self):
        user = self.request.user
        project_id = self.request.query_params.get('project')
        date = convert_string_to_date(self.request.query_params.get('date'))
        self.queryset = self.queryset.filter(
            start_date__month__lte=date.month,
            end_date__month__gte=date.month,
            employee_projects__employee__user=user,
            employee_projects__project=project_id,
        )  # type: Roster
        return super().get_queryset()

    @extend_schema(parameters=[
        OpenApiParameter(name='date', required=True, type=str)
    ])
    def list(self, request, *args, **kwargs):
        if not self.request.query_params.get('date'):
            raise ValidationError({'detail': 'date is required.'})
        date = convert_string_to_date(self.request.query_params.get('date'))
        project = self.request.query_params.get('project')
        year, month, last_day_of_month = last_day_of(date)
        obj_days_in_month: list[datetime.date] = create_list_all_dates_in_month(year, month, last_day_of_month)

        self.filterset_class = CalendarFilter
        queryset = self.filter_queryset(self.get_queryset())  # type: QuerySet[Roster]
        leave_request_partial_approve_queryset = LeaveRequestPartialApprove.objects.filter(
            leave_request__user=self.request.user,
            leave_request__project=project
        )
        ot_request_queryset = OTRequest.objects.filter(
            Q(start_date__month=date.month, start_date__year=date.year) |
            Q(end_date__month=date.month, end_date__year=date.year),
            Q(status__in=[OTRequestStatus.PARTIAL_APPROVE, OTRequestStatus.APPROVE]),
            user=request.user,
            project=project
        )
        adjust_request_queryset = AdjustRequest.objects.filter(
            employee_project__project=project,
            employee_project__employee__user=request.user,
            date__month=date.month,
            date__year=date.year
        )
        calendar_data = CalendarResponseForMobile(
            queryset=queryset.order_by('start_date'),
            date=date,
            obj_days_in_month=obj_days_in_month,
            leave_request_partial_approve_queryset=leave_request_partial_approve_queryset,
            ot_request_queryset=ot_request_queryset,
            adjust_request_queryset=adjust_request_queryset
        ).get_calendar_for_mobile()

        return Response(calendar_data)


class AdditionalTypeViewSet(viewsets.ModelViewSet):
    queryset = AdditionalType.objects.all()
    serializer_class = AdditionalTypeSerializer
    filterset_class = AdditionalTypeFilter
    permission_classes = [IsAuthenticated, IsSuperAdminOrAdmin]
