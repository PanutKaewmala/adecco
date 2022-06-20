from drf_spectacular.utils import extend_schema_serializer, OpenApiExample
from rest_framework import serializers
from rest_framework.exceptions import ValidationError

from main.apps.activities.choices import LeaveStatus
from main.apps.activities.functions.activity_operator import validate_allowed_range_of_leave_request, \
    create_leave_request_partial_approve
from main.apps.activities.models import LeaveRequest, LeaveRequestPartialApprove, AdditionalType
from main.apps.activities.serializers.leave_quotas import LeaveQuotaReadSerializer
from main.apps.activities.serializers.upload_attachments import UploadAttachmentReadSerializer
from main.apps.common.serializers import FlexedWritableNestedModelSerializer
from main.apps.users.serializers.users import UserCommonSerializer, UserCommonDetailSerializer


class LeaveRequestSerializer(FlexedWritableNestedModelSerializer):
    start_date = serializers.DateField(format='%d %b %Y')
    end_date = serializers.DateField(format='%d %b %Y')
    start_time = serializers.TimeField(format='%H:%M', allow_null=True)
    end_time = serializers.TimeField(format='%H:%M', allow_null=True)

    class Meta:
        model = LeaveRequest
        exclude = ['user']
        extra_kwargs = {
            'project': {'required': True, 'write_only': True},
            'alive': {'read_only': True}
        }

    def create(self, validated_data):
        user = self.context['request'].user
        validated_data['user_id'] = user.id

        if validated_data.get('all_day'):
            validated_data['start_time'] = None
            validated_data['end_time'] = None
        validate_allowed_range_of_leave_request(validated_data)
        instance = super().create(validated_data)  # type: LeaveRequest
        create_leave_request_partial_approve(instance)
        return instance

    def update(self, instance, validated_data):
        if validated_data.get('all_day'):
            validated_data['start_time'] = None
            validated_data['end_time'] = None
        instance = super().update(instance, validated_data)  # type: LeaveRequest

        if validated_data.get('start_date') or validated_data.get('end_date'):
            LeaveRequestPartialApprove.objects.filter(leave_request_id=instance.id).delete()
            create_leave_request_partial_approve(instance)
        return instance


class LeaveRequestRetrieveSerializer(LeaveRequestSerializer):
    type = serializers.CharField()
    upload_attachments = UploadAttachmentReadSerializer(many=True, read_only=True)


class LeaveRequestListSerializer(LeaveRequestRetrieveSerializer):
    upload_attachments = None

    class Meta(LeaveRequestRetrieveSerializer.Meta):
        exclude = LeaveRequestRetrieveSerializer.Meta.exclude + ['title', 'description']


@extend_schema_serializer(
    examples=[
        OpenApiExample(
            'Example',
            description='get data for admin, super admin',
            value={
                'id': 1,
                'user': UserCommonSerializer,
                'upload_attachments': UploadAttachmentReadSerializer,
                'type': 'Annual Leave',
                'start_date': '2022-02-17',
                'end_date': '2022-02-18',
                'start_time': '',
                'end_time': '',
                'all_day': True,
                'title': 'annual leave',
                'description': 'pai travel na',
                'status': 'pending',
            },
            request_only=True,
        ),
    ]
)
class LeaveRequestDashboardSerializer(serializers.ModelSerializer):
    type = serializers.CharField()
    user = UserCommonSerializer()
    upload_attachments = UploadAttachmentReadSerializer(many=True, read_only=True)

    class Meta:
        model = LeaveRequest
        fields = '__all__'


class LeaveRequestPartialApproveSerializer(serializers.ModelSerializer):
    class Meta:
        model = LeaveRequestPartialApprove
        fields = '__all__'


class LeaveRequestEachDaySerializer(serializers.ModelSerializer):
    status = serializers.CharField(source='leave_request.status')
    leave_request_id = serializers.IntegerField(source='leave_request.id')
    type = serializers.CharField(source='leave_request.type')
    start_time = serializers.TimeField(source='leave_request.start_time')
    end_time = serializers.TimeField(source='leave_request.end_time')
    all_day = serializers.BooleanField(source='leave_request.all_day')
    date = serializers.DateField(format='%d %b %Y')
    project_id = serializers.IntegerField(source='leave_request.project.id')

    class Meta:
        model = LeaveRequestPartialApprove
        fields = (
            'id', 'leave_request_id', 'date', 'start_time', 'end_time', 'all_day', 'approve', 'status', 'type',
            'project_id'
        )


@extend_schema_serializer(
    examples=[
        OpenApiExample(
            'Example',
            description='get detail for admin, super admin',
            value={
                'id': 1,
                'user': UserCommonDetailSerializer,
                'leave_quotas': LeaveQuotaReadSerializer,
                'upload_attachments': UploadAttachmentReadSerializer,
                'type': 'Annual Leave',
                'start_date': '2022-02-17',
                'end_date': '2022-02-18',
                'start_time': '',
                'end_time': '',
                'all_day': True,
                'title': 'annual leave',
                'description': 'pai travel na',
                'status': 'pending',
            },
            request_only=True,
        ),
    ]
)
class LeaveRequestDetailSerializer(LeaveRequestDashboardSerializer):
    leave_quotas = LeaveQuotaReadSerializer(source='user.leave_quotas', many=True)
    user = UserCommonDetailSerializer()
    leave_request_partial_approves = LeaveRequestPartialApproveSerializer(many=True, default=[])


class LeaveRequestCommonSerializer(serializers.ModelSerializer):
    class Meta:
        model = LeaveRequest
        fields = ('start_date', 'end_date', 'start_time', 'end_time', 'all_day')


class LeaveRequestUpdateSerializer(FlexedWritableNestedModelSerializer):
    leave_request_partial_approves = LeaveRequestPartialApproveSerializer(many=True)

    class Meta:
        model = LeaveRequest
        fields = ('id', 'leave_request_partial_approves')


class LeaveRequestActionSerializer(serializers.Serializer):
    status = serializers.ChoiceField(choices=LeaveStatus.choices)
    note = serializers.CharField(required=False)
    reason = serializers.CharField(required=False)
    leave_request_partial_approves = LeaveRequestPartialApproveSerializer(many=True, required=False)

    def validate(self, attrs):
        if attrs.get('status') == LeaveStatus.PARTIAL_APPROVE and not attrs.get('leave_request_partial_approves'):
            raise ValidationError('leave request partial approves required.')
        return attrs


class AdditionalTypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = AdditionalType
        fields = '__all__'
