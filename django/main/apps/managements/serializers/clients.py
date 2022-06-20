from rest_flex_fields import FlexFieldsModelSerializer
from rest_framework import serializers

from main.apps.activities.serializers.leave_types import LeaveTypeSettingSerializer
from main.apps.common.serializers import FlexedWritableNestedModelSerializer
from main.apps.managements.models import Client
from main.apps.managements.serializers.business_calendars import BusinessCalendarSerializer
from main.apps.managements.serializers.ot_rules import OTRuleSerializer
from main.apps.merchandizers.serializers.merchandizer_questions import MerchandizerQuestionSerializer
from main.apps.users.serializers.users import UserCommonSerializer


class ClientRetrieveSerializer(FlexFieldsModelSerializer):
    project_manager = UserCommonSerializer()

    class Meta:
        model = Client
        fields = '__all__'
        expandable_fields = {
            'merchandizer_questions': (MerchandizerQuestionSerializer, {'many': True}),
            'ot_rules': (OTRuleSerializer, {'many': True}),
            'business_calendars': (BusinessCalendarSerializer, {'many': True}),
        }


class ClientListSerializer(ClientRetrieveSerializer):
    class Meta:
        model = Client
        exclude = ('url',)


class ClientCreateUpdateSerializer(FlexedWritableNestedModelSerializer):
    ot_rules = OTRuleSerializer(many=True, required=False)
    business_calendars = BusinessCalendarSerializer(many=True, required=False)
    merchandizer_questions = MerchandizerQuestionSerializer(many=True, required=False)

    class Meta:
        model = Client
        fields = '__all__'
        extra_kwargs = {
            'project_manager': {'required': True},
            'name': {'required': True},
            'name_th': {'required': True},
            'branch': {'required': True},
            'contact_person': {'required': True},
            'url': {'required': True},
        }


class ClientCommonSerializer(serializers.ModelSerializer):
    class Meta:
        model = Client
        fields = ('id', 'name', 'branch')


class ClientLeaveTypeSettingSerializer(FlexedWritableNestedModelSerializer):
    leave_type_settings = LeaveTypeSettingSerializer(many=True)

    class Meta:
        model = Client
        fields = ('id', 'name', 'leave_type_settings')
        extra_kwargs = {
            'id': {'read_only': True},
            'name': {'read_only': True}
        }
