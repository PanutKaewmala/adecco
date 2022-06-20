import datetime

from django.db.models import QuerySet
from django_filters.rest_framework import DjangoFilterBackend
from drf_spectacular.utils import extend_schema, OpenApiParameter
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.filters import OrderingFilter
from rest_framework.permissions import IsAuthenticated
from rest_framework.request import Request
from rest_framework.response import Response

from main.apps.common.functions import user_in_admin_or_manager_roles
from main.apps.common.permissions import IsSuperAdminOrAdmin, IsAssociate
from main.apps.common.views import ActionRelatedSerializerMixin
from main.apps.rosters.filters import RosterFilter, EditShiftFilter, AdjustRequestFilter
from main.apps.rosters.functions.actions import RosterAction
from main.apps.rosters.functions.adjust_requests import AdjustRequestHandle
from main.apps.rosters.functions.auto_shifts import RosterAutoShift
from main.apps.rosters.functions.calendars import calendar_params_required, \
    CalendarResponse
from main.apps.rosters.functions.day_offs import update_or_create_roster_day_off
from main.apps.rosters.functions.edit_shift import EditShiftAction
from main.apps.rosters.functions.roster_plans import convert_employee_project_to_objects
from main.apps.rosters.functions.rosters import RosterResponse, RosterDuplicate
from main.apps.rosters.models import Roster, Shift, EditShift, AdjustRequest
from main.apps.rosters.permissions import CanEditShift, RosterPlanParamsRequired, CanEditRoster
from main.apps.rosters.serializers.adjust_requests import AdjustRequestWriteSerializer, AdjustRequestListSerializer, \
    AdjustRequestRetrieveSerializer
from main.apps.rosters.serializers.calendars import CalendarResponseSerializer
from main.apps.rosters.serializers.edit_shifts import EditShiftSerializer, EditShiftRetrieveSerializer
from main.apps.rosters.serializers.roster_plans import RosterPlansSerializer
from main.apps.rosters.serializers.rosters import RosterListSerializer, RosterWriteSerializer, \
    RosterRetrieveSerializer, RosterMobileListSerializer, RosterDayOffWriteSerializer
from main.apps.rosters.serializers.shifts import ShiftSerializer


class RosterViewSet(ActionRelatedSerializerMixin, viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated, CanEditRoster]
    queryset = Roster.objects.all() \
        .prefetch_related('shifts', 'shifts__schedules', 'shifts__working_hour', 'shifts__schedules__workplaces',
                          'employee_projects', 'employee_projects__employee__user', 'employee_projects__project')
    filterset_class = RosterFilter
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    retrieve_serializer_class = RosterRetrieveSerializer
    list_serializer_class = RosterListSerializer
    write_serializer_class = RosterWriteSerializer

    def get_queryset(self):
        user = self.request.user
        if not user_in_admin_or_manager_roles(user):
            self.queryset = self.queryset.filter(employee_projects__employee__user=user)
        return super().get_queryset()

    def create(self, request, *args, **kwargs):
        if request.data.get('auto_shifts', False):
            request.data['shifts'] = RosterAutoShift(validated_data=request.data).get_shifts()
        return super().create(request, *args, **kwargs)

    @extend_schema(responses=RosterMobileListSerializer)
    @action(detail=True, methods=['GET'], permission_classes=[IsAuthenticated])
    def details(self, request: Request, pk=None):
        """
            this api for associate mobile.
        """
        roster = self.get_object()  # type: Roster
        roster_detail = RosterResponse(
            roster=roster
        ).get_detail_for_mobile()
        return Response(roster_detail)

    @extend_schema(responses=RosterRetrieveSerializer)
    @action(detail=True, methods=['POST'], permission_classes=[IsAuthenticated, IsSuperAdminOrAdmin])
    def actions(self, request, pk=None):
        roster = self.get_object()  # type: Roster
        RosterAction(
            roster=roster,
            request=request
        ).actions()
        serializer = super().retrieve(request)
        return Response(serializer.data)

    @action(detail=True, methods=['GET'], permission_classes=[IsAuthenticated],
            url_path='day-off-retrieve', url_name='day-off-retrieve')
    def retrieve_roster_type_day_off(self, request: Request, *args, **kwargs):
        instance = self.get_object()  # type: Roster
        serializer = RosterDayOffWriteSerializer(instance=instance)
        return Response(serializer.data)

    @action(detail=False, methods=['POST', 'PATCH'], permission_classes=[IsAuthenticated, CanEditRoster],
            url_path='day-off', url_name='day-off')
    def write_roster_type_day_off(self, request: Request, *args, **kwargs):
        response = update_or_create_roster_day_off(request=request)
        return Response(response)

    @action(detail=False, methods=['POST'], permission_classes=[IsAuthenticated, IsAssociate])
    def preview(self, request: Request):
        roster_detail = RosterResponse(
            roster_dict=request.data,
            preview=True
        ).get_preview_for_mobile()
        return Response(roster_detail)

    @action(detail=True, methods=['POST'], permission_classes=[IsAuthenticated, CanEditShift],
            url_path='edit-shift', url_name='edit-shift')
    def edit_shift(self, request: Request, pk=None):
        roster = self.get_object()  # type: Roster
        from_shift = Shift.objects.get(id=request.data.get('from_shift'))  # type: Shift
        response = EditShiftAction(
            roster=roster,
            from_shift=from_shift,
            request_data=request.data,
            request=request
        ).create_edit_shift()
        return Response(response)

    @extend_schema(responses=CalendarResponseSerializer)
    @action(detail=False, methods=['GET'], permission_classes=[IsAuthenticated])
    def calendars(self, request: Request):
        calendar_params_required(request)
        queryset = self.filter_queryset(self.get_queryset())  # type: QuerySet[Roster]
        calendar_data = CalendarResponse(
            queryset=queryset.order_by('start_date')
        ).get_calendar_for_mobile()
        return Response(calendar_data)

    @extend_schema(parameters=[
        OpenApiParameter(name='roster_plan_type', required=True, type=str),
        OpenApiParameter(name='roster_plan_date', required=True, type=str)
    ])
    @action(detail=False, methods=['GET'], url_path='roster-plans', url_name='roster-plans',
            permission_classes=[IsAuthenticated, IsSuperAdminOrAdmin, RosterPlanParamsRequired])
    def roster_plans(self, request: Request):
        roster_plan_date = datetime.datetime.strptime(request.query_params.get('roster_plan_date'), '%Y-%m-%d')
        roster_plan_type = request.query_params.get('roster_plan_type')
        queryset = self.filter_queryset(self.get_queryset())  # type: QuerySet[Roster]
        serializer = RosterPlansSerializer(
            queryset,
            many=True,
            roster_plan_date=roster_plan_date,
            roster_plan_type=roster_plan_type
        )
        response = convert_employee_project_to_objects(serializer.data)
        return Response(response)

    @action(detail=True, methods=['POST'], permission_classes=[IsAuthenticated, IsSuperAdminOrAdmin],
            url_name='duplicate', url_path='duplicate')
    def new_roster_from_roster_setting(self, request, pk=None):
        instance = self.get_object()  # type: Roster
        roster = RosterDuplicate(
            roster=instance,
            request_data=request.data,
            request=request
        ).duplicate_roster()
        return Response(roster)


class ShiftViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Shift.objects.select_related('roster') \
        .prefetch_related('roster__employee_projects__employee__user', 'schedules', 'schedules__workplaces').all()
    serializer_class = ShiftSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        if not user_in_admin_or_manager_roles(user):
            self.queryset = self.queryset.filter(roster__employee_projects__employee__user=user)
        return super().get_queryset()


class EditShiftViewSet(viewsets.ReadOnlyModelViewSet):
    permission_classes = [IsAuthenticated, IsSuperAdminOrAdmin]
    queryset = EditShift.objects \
        .select_related('from_shift', 'from_shift__roster',
                        'to_shift', 'to_shift__working_hour').all()
    serializer_class = EditShiftSerializer
    filterset_class = EditShiftFilter
    filter_backends = [DjangoFilterBackend, OrderingFilter]

    def retrieve(self, request, *args, **kwargs):
        self.serializer_class = EditShiftRetrieveSerializer
        return super().retrieve(request, *args, **kwargs)

    @action(detail=True, methods=['POST'], permission_classes=[IsAuthenticated, IsSuperAdminOrAdmin])
    def actions(self, request: Request, pk=None):
        instance = self.get_object()
        EditShiftAction(
            edit_shift=instance,
            request_data=request.data
        ).actions()
        return Response(data='edit shift success', status=status.HTTP_200_OK)


class AdjustRequestViewSet(ActionRelatedSerializerMixin, viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated]
    queryset = AdjustRequest.objects \
        .select_related('employee_project__employee__user', 'working_hour') \
        .prefetch_related('workplaces').all()
    retrieve_serializer_class = AdjustRequestRetrieveSerializer
    list_serializer_class = AdjustRequestListSerializer
    write_serializer_class = AdjustRequestWriteSerializer
    filterset_class = AdjustRequestFilter
    filter_backends = [DjangoFilterBackend, OrderingFilter]

    def get_queryset(self):
        user = self.request.user
        if not user_in_admin_or_manager_roles(user):
            self.queryset = self.queryset.filter(employee_project__employee__user=user)
        return super().get_queryset()

    def create(self, request, *args, **kwargs):
        adjust_request_data = AdjustRequestHandle(
            request=request
        ).create_adjust_request()
        return Response(adjust_request_data)
