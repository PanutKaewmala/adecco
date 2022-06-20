from rest_framework import serializers

from main.apps.common.serializers import FlexedWritableNestedModelSerializer
from main.apps.managements.models import PinPointType, PinPointQuestion


class PinPointQuestionNestRetrieveSerializer(serializers.ModelSerializer):
    class Meta:
        model = PinPointQuestion
        fields = ('id', 'name', 'require', 'hide', 'template')


class PinPointTypeRetrieveSerializer(serializers.ModelSerializer):
    questions = PinPointQuestionNestRetrieveSerializer(many=True)

    class Meta:
        model = PinPointType
        fields = '__all__'


class PinPointTypeListSerializer(PinPointTypeRetrieveSerializer):
    class Meta(PinPointTypeRetrieveSerializer.Meta):
        fields = ('id', 'name', 'detail', 'total_assignee')


class PinPointTypeWriteSerializer(FlexedWritableNestedModelSerializer):
    questions = PinPointQuestionNestRetrieveSerializer(many=True)

    class Meta:
        model = PinPointType
        fields = '__all__'


class PinPointTypeCommonSerializer(PinPointTypeRetrieveSerializer):
    class Meta(PinPointTypeRetrieveSerializer.Meta):
        fields = ('id', 'name')
