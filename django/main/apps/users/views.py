from django_filters.rest_framework import DjangoFilterBackend
from drf_spectacular.utils import extend_schema, OpenApiParameter
from rest_framework import viewsets
from rest_framework.decorators import action
from rest_framework.exceptions import ValidationError
from rest_framework.filters import OrderingFilter
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

from main.apps.common.functions import user_in_admin_or_manager_roles
from main.apps.common.permissions import IsSuperAdminOrAdmin, IsAssociate
from main.apps.common.utils import optimize_expanded_query
from main.apps.common.views import ActionRelatedSerializerMixin
from main.apps.managements.models import Project
from main.apps.users.filters import UserFilter, EmployeeFilter, ManagerFilter, EmployeeProjectFilter
from main.apps.users.functions.daily_tasks import DailyTaskClient
from main.apps.users.functions.employee import EmployeeManagement
from main.apps.users.models import User, Employee, Manager, EmployeeProject
from main.apps.users.serializers.employees import EmployeeProjectWriteSerializer, EmployeeListSerializer, \
    EmployeeWriteSerializer, EmployeeRetrieveSerializer, LocationSerializer, \
    LocationParamsSerializer, DailyTaskSerializer, \
    DailyTaskSerialzier, OTQuotaSerializer, EmployeeProjectListSerializer, EmployeeProjectRetrieveSerializer, \
    EmployeeProjectDetailProjectSerializer
from main.apps.users.serializers.managers import ManagerRetrieveSerializer, ManagerListSerializer, \
    ManagerWriteSerializer, ManagerAssignProjectSerializer
from main.apps.users.serializers.users import UserCreateSerializer, UserRetrieveSerializer, UserListSerializer, \
    UserBlobUploadSerializer, UserUpdateSerializer


class UserViewSet(ActionRelatedSerializerMixin, viewsets.ModelViewSet):
    queryset = User.objects.prefetch_related('project_manager_clients', 'employee').all()
    list_serializer_class = UserListSerializer
    retrieve_serializer_class = UserRetrieveSerializer
    create_serializer_class = UserCreateSerializer
    update_serializer_class = UserUpdateSerializer
    permission_classes = (IsAuthenticated, IsSuperAdminOrAdmin)
    filterset_class = UserFilter
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    ordering_fields = ('id', 'first_name', 'last_name')

    @action(detail=True, methods=['PATCH', 'PUT'], update_serializer_class=UserBlobUploadSerializer,
            url_path='blob-upload', url_name='blob-upload')
    def blob_upload(self, request, pk=None):
        self.list_serializer_class = UserBlobUploadSerializer
        return super().partial_update(request)

    @extend_schema(responses=UserRetrieveSerializer)
    @action(detail=False, methods=['GET'], url_path='me', url_name='me',
            retrieve_serializer_class=UserRetrieveSerializer)
    def me(self, request):
        serializer = UserRetrieveSerializer(request.user, context={'request': request})
        return Response(serializer.data)


class EmployeeViewSet(ActionRelatedSerializerMixin, viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated, IsSuperAdminOrAdmin]
    queryset = Employee.objects.select_related('user') \
        .prefetch_related('employee_projects', 'employee_projects__project', 'employee_projects__workplaces').all() \
        .order_by('-id')
    retrieve_serializer_class = EmployeeRetrieveSerializer
    list_serializer_class = EmployeeListSerializer
    write_serializer_class = EmployeeWriteSerializer
    filterset_class = EmployeeFilter
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    ordering_fields = ('id', 'position')

    @extend_schema(responses=EmployeeProjectWriteSerializer, request=EmployeeProjectWriteSerializer)
    @action(detail=True, methods=['POST'], url_name='assign-project', url_path='assign-project',
            permission_classes=[IsAuthenticated, IsSuperAdminOrAdmin])
    def assign_project(self, request, pk=None):
        employee_project = request.data.get('employee_project')  # type: dict
        if not employee_project:
            raise ValidationError(
                {
                    'detail': 'not found employee_project in payload'
                }
            )
        employee_project.update({'employee': pk})
        serializer = EmployeeProjectWriteSerializer(data=employee_project)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data)

    @extend_schema(parameters=[LocationParamsSerializer], responses=LocationSerializer)
    @action(detail=False, methods=['GET'], permission_classes=[IsAuthenticated, IsAssociate])
    def locations(self, request):
        employee = request.user.employee  # type: Employee
        employee_clint = EmployeeManagement(
            employee=employee,
            request=request,
            parameter_serializer=LocationParamsSerializer
        )
        serializer = LocationSerializer(employee_clint.get_locations(), many=True)
        return Response(serializer.data)

    @extend_schema(parameters=[DailyTaskSerialzier], responses=DailyTaskSerializer)
    @action(detail=False, methods=['GET'], permission_classes=[IsAuthenticated, IsAssociate],
            url_path='daily-tasks', url_name='daily-tasks')
    def daily_tasks(self, request):
        employee = request.user.employee  # type: Employee
        daily_task = DailyTaskClient(
            employee=employee,
            request=request,
            parameter_serializer=DailyTaskSerialzier
        )
        serializer = DailyTaskSerializer(daily_task.get_daily_tasks(), many=True)
        return Response(serializer.data)

    @extend_schema(parameters=[OpenApiParameter(name='project', required=True, type=int)], responses=OTQuotaSerializer)
    @action(detail=False, methods=['GET'], permission_classes=[IsAuthenticated, IsAssociate],
            url_path='ot-quotas', url_name='ot-quotas')
    def ot_quota(self, request):
        try:
            employee = request.user.employee
            project = request.query_params.get('project')
            employee_project = EmployeeProject.objects.get(employee=employee, project=project)
        except EmployeeProject.DoesNotExist:
            raise ValidationError({'detail': 'Employee not found in this project'})
        serializer = OTQuotaSerializer(instance=employee_project)
        return Response(data=serializer.data)


class ManagerViewSet(ActionRelatedSerializerMixin, viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated, IsSuperAdminOrAdmin]
    queryset = Manager.objects.select_related('user') \
        .prefetch_related('projects', 'projects__workplaces').all().order_by('-id')
    retrieve_serializer_class = ManagerRetrieveSerializer
    list_serializer_class = ManagerListSerializer
    write_serializer_class = ManagerWriteSerializer
    filterset_class = ManagerFilter
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    ordering_fields = ('id',)

    @extend_schema(responses=ManagerWriteSerializer, request=ManagerWriteSerializer,
                   parameters=[ManagerAssignProjectSerializer])
    @action(detail=False, methods=['POST'], url_name='assign-project', url_path='assign-project',
            permission_classes=[IsAuthenticated, IsSuperAdminOrAdmin])
    def assign_project(self, request):
        serializer = ManagerAssignProjectSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data.get('user')  # type: User
        project = serializer.validated_data.get('project')  # type: Project
        try:
            manager = user.manager
        except Manager.DoesNotExist:
            manager = Manager(
                user=user
            )
            manager.save()
        manager.projects.add(project)

        return Response(self.retrieve_serializer_class(manager).data)


class EmployeeProjectViewSet(ActionRelatedSerializerMixin, viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated]
    queryset = EmployeeProject.objects.prefetch_related('employee__user', 'merchandizers__shop').all().order_by('-id')
    list_serializer_class = EmployeeProjectListSerializer
    retrieve_serializer_class = EmployeeProjectRetrieveSerializer
    write_serializer_class = EmployeeProjectRetrieveSerializer
    filterset_class = EmployeeProjectFilter

    def get_queryset(self):
        user = self.request.user
        if not user_in_admin_or_manager_roles(user):
            self.queryset = self.queryset. \
                filter(employee__user=user)

        self.queryset = optimize_expanded_query(
            request=self.request,
            queryset=self.queryset,
            prefetch_related={
                'merchandizers': 'merchandizers',
            }
        )
        return super().get_queryset()

    @extend_schema(responses=EmployeeProjectDetailProjectSerializer)
    @action(detail=False, methods=['GET'])
    def me(self, request):
        user = request.user
        queryset = EmployeeProject.objects.filter(employee__user=user)
        return Response(EmployeeProjectDetailProjectSerializer(queryset, many=True).data)
