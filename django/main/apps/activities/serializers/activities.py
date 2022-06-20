from drf_spectacular.utils import extend_schema_serializer, OpenApiExample
from rest_framework import serializers
from rest_framework.exceptions import ValidationError

from main.apps.activities.choices import OTRequestStatus, OTRequestType, ActivityType
from main.apps.activities.functions.activity_operator import validate_data_check_in_out_required, \
    validate_user_already_check_in_out_project, validate_inside_workplace, map_activity_by_workplaces, \
    validate_lead_times
from main.apps.activities.functions.ot_rates import OTRate
from main.apps.activities.functions.pairs import init_check_in_out_pair, set_check_out_to_pair
from main.apps.activities.models import Activity, OTRequest
from main.apps.activities.serializers.leave_requests import LeaveRequestCommonSerializer
from main.apps.activities.utils import activity_in_check_in_out
from main.apps.common.constants import EXCLUDE_TIME_STAMP_FIELDS
from main.apps.common.functions import user_in_admin_or_manager_roles
from main.apps.managements.models import WorkPlace
from main.apps.managements.serializers.workplaces import WorkPlaceCommonSerializer
from main.apps.users.models import User, EmployeeProject
from main.apps.users.serializers.employees import OTQuotaSerializer
from main.apps.users.serializers.users import UserCommonSerializer, UserCommonDetailSerializer


class ActivitySerializer(serializers.ModelSerializer):
    class Meta:
        model = Activity
        fields = ['id', 'type', 'date_time', 'location_name', 'latitude', 'longitude', 'picture',
                  'remark', 'location_address', 'reason_for_adjust_time', 'reason_for_adjust_status',
                  'workplace', 'project', 'working_hour', 'in_radius', 'extra_type']
        extra_kwargs = {
            'picture': {'required': False, 'write_only': True},
            'workplace': {'required': False},
            'project': {'required': False},
            'working_hour': {'required': False},
            'extra_type': {'required': False},
        }

    def create(self, validated_data):
        request = self.context.get('request')
        user = request.user
        validated_data['user_id'] = user.id

        if activity_in_check_in_out(validated_data.get('type')):
            validate_data_check_in_out_required(validated_data, request)
            validate_user_already_check_in_out_project(validated_data, user)
            validated_data['in_radius'] = validate_inside_workplace(validated_data)
            validate_lead_times(request, validated_data)

        instance = super().create(validated_data)  # type: Activity
        if instance.type == ActivityType.CHECK_IN:
            init_check_in_out_pair(instance)
        if instance.type == ActivityType.CHECK_OUT:
            set_check_out_to_pair(instance, request)
        return instance


@extend_schema_serializer(
    examples=[
        OpenApiExample(
            'Example',
            description='get data for admin, super admin',
            value={
                'id': 1,
                'user': UserCommonSerializer,
                'coordinate': '10',
                'type': 'check_in',
                'extra_type': 'late',
                'date_time': '2022-02-27T13:23:54.341000+07:00',
                'location_name': 'Codium',
                'latitude': '1',
                'longitude': '1',
                'picture': '',
                'workplaces': WorkPlaceCommonSerializer,
            },
            request_only=True,
        ),
    ]
)
class ActivityDashboardSerializer(serializers.ModelSerializer):
    user = UserCommonSerializer()
    coordinate = serializers.ReadOnlyField(default=None)
    workplace = WorkPlaceCommonSerializer(read_only=True)
    working_hour = serializers.CharField(source='working_hour.name', default=None)

    class Meta:
        model = Activity
        exclude = (*EXCLUDE_TIME_STAMP_FIELDS, 'reason_for_adjust_time', 'remark', 'reason_for_adjust_status')


class ActivityDetailDataSerializer(serializers.ModelSerializer):
    workplace = serializers.CharField(source='workplace.name', default=None)
    working_hour = serializers.CharField(source='working_hour.name', default=None)

    class Meta:
        model = Activity
        exclude = EXCLUDE_TIME_STAMP_FIELDS


@extend_schema_serializer(
    examples=[
        OpenApiExample(
            'Example',
            description='get detail for activity',
            value={
                'user': UserCommonDetailSerializer,
                'activities': {
                    'workplace_name': {
                        'check_in': ActivityDetailDataSerializer,
                        'check_out': ActivityDetailDataSerializer,
                    }
                }
            },
            request_only=True,
        ),
    ]
)
class ActivityDetailSerializer(serializers.Serializer):
    user = UserCommonDetailSerializer()
    supervisor = serializers.SerializerMethodField()
    workplaces = serializers.ListField(default=[])
    activities = serializers.SerializerMethodField()

    def get_activities(self, data):
        return ActivityDetailDataSerializer(data.get('activities'), many=True, default=[], context=self.context).data

    @staticmethod
    def get_supervisor(instance):
        employee_project = instance.get('employee_project')
        if employee_project:
            return UserCommonDetailSerializer(
                instance=employee_project.supervisor
            ).data
        return {}

    def to_representation(self, instance):
        ret = super().to_representation(instance)
        activities = ret.get('activities', [])
        ret['activities'] = map_activity_by_workplaces(activities)
        return ret


class ActivityDateSerializer(serializers.Serializer):
    date_time = serializers.DateField()
    check_in = serializers.DateTimeField()
    check_out = serializers.DateTimeField()
    status = serializers.CharField()
    leave = LeaveRequestCommonSerializer()


class CalendarActivitySerializer(serializers.Serializer):
    date_time = serializers.DateField()
    type = serializers.CharField()
    work_day = serializers.CharField()
    over_time = serializers.CharField()
    leave = LeaveRequestCommonSerializer()


class OTRequestRetrieveSerializer(serializers.ModelSerializer):
    user = UserCommonDetailSerializer(read_only=True)
    supervisor = serializers.SerializerMethodField()
    ot_total = serializers.SerializerMethodField()
    workplace = WorkPlaceCommonSerializer()
    ot_rates = serializers.SerializerMethodField()
    ot_quota = serializers.SerializerMethodField()

    class Meta:
        model = OTRequest
        exclude = ('alive',)

    def __init__(self, instance=None, **kwargs):
        super().__init__(instance, **kwargs)
        self.employee_project = None
        if isinstance(instance, OTRequest):
            self.employee_project = instance.employee_project

    @staticmethod
    def get_ot_rates(instance: OTRequest):
        ot_rate = OTRate(employee=instance.user.employee, ot_request=instance).get_ot_rate()
        return ot_rate

    @staticmethod
    def get_ot_total(instance: OTRequest):
        if instance.status == OTRequestStatus.PARTIAL_APPROVE:
            return f'{instance.partial_start_time}-{instance.partial_end_time} ({instance.ot_total} hrs)'
        return f'{instance.start_time}-{instance.end_time} ({instance.ot_total} hrs)'

    def get_supervisor(self, instance: OTRequest):
        if self.employee_project:
            return UserCommonDetailSerializer(
                instance=self.employee_project.supervisor
            ).data
        return {}

    def get_ot_quota(self, instance: OTRequest):
        if self.employee_project:
            return OTQuotaSerializer(self.employee_project).data
        return {}


class OTRequestListSerializer(OTRequestRetrieveSerializer):
    class Meta:
        model = OTRequest
        fields = ('id', 'user', 'workplace', 'created_at', 'start_date', 'ot_total', 'status', 'title',
                  'start_time', 'end_time')


class OTRequestWriteSerializer(OTRequestRetrieveSerializer):
    user = serializers.PrimaryKeyRelatedField(queryset=User.objects.all(), required=False)
    workplace = serializers.PrimaryKeyRelatedField(queryset=WorkPlace.objects.all())

    def create(self, validated_data):
        request_user = self.context['request'].user
        user = validated_data.get('user')
        if not user:
            validated_data['user'] = request_user
        validated_data['multi_day'] = validated_data.get('start_date') != validated_data.get('end_date')
        if user_in_admin_or_manager_roles(request_user):
            validated_data['type'] = OTRequestType.ASSIGN_OT
            validated_data['status'] = OTRequestStatus.APPROVE
        else:
            validated_data['type'] = OTRequestType.USER_REQUEST

        return super().create(validated_data)


class OTRequestAssignSerializer(OTRequestWriteSerializer):
    employee_projects = serializers.PrimaryKeyRelatedField(queryset=EmployeeProject.objects.all(),
                                                           many=True, required=True)
    project = serializers.IntegerField(help_text='Need id only')
    workplace = serializers.IntegerField(help_text='Need id only')


class OTRequestActionSerializer(serializers.Serializer):
    status = serializers.ChoiceField(choices=OTRequestStatus.choices)
    note = serializers.CharField(required=False)
    reason = serializers.CharField(required=False)
    partial_start_time = serializers.TimeField(required=False)
    partial_end_time = serializers.TimeField(required=False)

    def validate(self, attrs):
        if attrs.get('status') == OTRequestStatus.PARTIAL_APPROVE:
            instance = self.context.get('ot_request')  # type: OTRequest
            if not all([attrs.get('partial_start_time'), attrs.get('partial_end_time')]):
                raise ValidationError({'detail': 'ot request partial time required.'})
            else:
                if attrs.get('partial_start_time') < instance.start_time:
                    raise ValidationError({'detail': f'partial start time should more than {instance.start_time}.'})
                if attrs.get('partial_end_time') > instance.end_time:
                    raise ValidationError({'detail': f'partial end time should less than {instance.end_time}.'})

        return attrs
