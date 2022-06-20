from rest_framework import serializers
from rest_framework.exceptions import ValidationError

from main.apps.activities.models import LeaveTypeSetting, LeaveType
from main.apps.common.serializers import FlexedWritableNestedModelSerializer


class LeaveTypeSettingSerializer(serializers.ModelSerializer):
    id = serializers.IntegerField(required=False)

    def validate(self, attrs):
        self.check_project_or_client_must_have_only_one_thing(attrs)
        return super().validate(attrs)

    def check_project_or_client_must_have_only_one_thing(self, attrs):
        instance = self.instance  # type: LeaveTypeSetting

        if (attrs.get('project') and getattr(instance, 'client', None)) \
                or (attrs.get('client') and getattr(instance, 'project', None)) \
                or (attrs.get('client') and attrs.get('project')):
            raise ValidationError({'detail': 'project or client must have only one thing'})

    def create(self, validated_data):
        if validated_data.get('project'):
            validated_data['client'] = None
        return super().create(validated_data)

    class Meta:
        model = LeaveTypeSetting
        fields = '__all__'
        extra_kwargs = {
            'default': {'read_only': True}
        }


class LeaveTypeListSerializer(FlexedWritableNestedModelSerializer):
    leave_type_setting = LeaveTypeSettingSerializer()

    class Meta:
        model = LeaveType
        fields = '__all__'


class LeaveTypeWriteSerializer(LeaveTypeListSerializer):
    leave_type_setting = serializers.PrimaryKeyRelatedField(queryset=LeaveTypeSetting.objects.all())

    def validate(self, attrs):
        self.check_project_or_client_must_have_only_one_thing(attrs)
        return super().validate(attrs)

    def check_project_or_client_must_have_only_one_thing(self, attrs):
        instance = self.instance  # type: LeaveType
        if (attrs.get('project') and getattr(instance, 'client', None)) \
                or (attrs.get('client') and getattr(instance, 'project', None)) \
                or (attrs.get('client') and attrs.get('project')):
            raise ValidationError({'detail': 'project or client must have only one thing'})
