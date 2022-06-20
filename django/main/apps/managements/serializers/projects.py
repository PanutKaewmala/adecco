from rest_framework import serializers

from main.apps.common.serializers import FlexedWritableNestedModelSerializer
from main.apps.managements.models import Project
from main.apps.managements.serializers.clients import ClientCommonSerializer
from main.apps.merchandizers.serializers.price_tracking import PriceTrackingSettingWriteSerializer
from main.apps.users.serializers.users import UserCommonSerializer


class ProjectCommonSerializer(serializers.ModelSerializer):
    class Meta:
        model = Project
        fields = ('id', 'name', 'description')


class ProjectCommonWithDateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Project
        fields = ('id', 'name', 'description', 'start_date', 'end_date')


class ProjectRetrieveSerializer(FlexedWritableNestedModelSerializer):
    project_manager = UserCommonSerializer()
    client = ClientCommonSerializer()

    class Meta:
        model = Project
        fields = '__all__'
        expandable_fields = {
            'price_tracking_settings': (PriceTrackingSettingWriteSerializer, {'many': True}),
        }


class ProjectSerializer(ProjectRetrieveSerializer):
    class Meta(ProjectRetrieveSerializer.Meta):
        fields = ('id', 'project_assignee', 'client', 'name',
                  'description', 'start_date', 'end_date')


class ProjectCreateSerializer(FlexedWritableNestedModelSerializer):
    price_tracking_settings = PriceTrackingSettingWriteSerializer(many=True, required=False)

    class Meta:
        model = Project
        fields = '__all__'
        extra_kwargs = {
            'leave_types': {'required': False},
            'project_manager': {'required': False},
            'name': {'required': True},
            'start_date': {'required': True},
            'country': {'required': True},
            'city': {'required': True},
            'project_assignee': {'required': True},
        }
        expandable_fields = {
            'price_tracking_settings': (PriceTrackingSettingWriteSerializer, {'many': True}),
        }

    def create(self, validated_data):
        client = validated_data.get('client')
        if client:
            validated_data['project_manager'] = client.project_manager
        return super().create(validated_data)
