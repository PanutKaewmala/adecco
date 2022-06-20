from rest_framework import serializers
from rest_framework.exceptions import ValidationError

from main.apps.activities.choices import ActivityType
from main.apps.activities.models import PinPointAnswer, PinPoint, Activity
from main.apps.activities.serializers.activities import ActivityDetailDataSerializer
from main.apps.common.serializers import FlexedWritableNestedModelSerializer
from main.apps.managements.constants import DEFAULT_QUESTIONS
from main.apps.managements.models import PinPointType
from main.apps.managements.serializers.pin_point_types import PinPointTypeCommonSerializer
from main.apps.users.serializers.users import UserCommonDetailSerializer


class PinPointAnswerSerializer(serializers.ModelSerializer):
    class Meta:
        model = PinPointAnswer
        extra_kwargs = {
            'question': {'required': False},
        }
        exclude = ('pin_point',)


class PinPointRetrieveSerializer(FlexedWritableNestedModelSerializer):
    answers = PinPointAnswerSerializer(many=True)
    activity = ActivityDetailDataSerializer()
    user = UserCommonDetailSerializer(source='activity.user', read_only=True)
    supervisor = serializers.SerializerMethodField()
    type = PinPointTypeCommonSerializer()

    class Meta:
        model = PinPoint
        fields = '__all__'

    @staticmethod
    def get_supervisor(instance: PinPoint):
        employee_project = instance.activity.employee_project
        if employee_project:
            return UserCommonDetailSerializer(
                instance=employee_project.supervisor
            ).data
        return {}


class PinPointListSerializer(PinPointRetrieveSerializer):
    type = PinPointTypeCommonSerializer()

    class Meta(PinPointRetrieveSerializer.Meta):
        fields = ('id', 'type', 'answers')

    def to_representation(self, instance):
        ret = super().to_representation(instance)
        answers = ret.pop('answers', [])
        for answer in answers:
            question = answer['question_name']
            if question in DEFAULT_QUESTIONS:
                ret[question] = answer['answer']
        return ret


class PinPointWriteSerializer(PinPointRetrieveSerializer):
    activity = serializers.PrimaryKeyRelatedField(
        queryset=Activity.objects.filter(type=ActivityType.PIN_POINT),
        required=True
    )
    type = serializers.PrimaryKeyRelatedField(
        queryset=PinPointType.objects.all(),
        required=True
    )

    def create(self, validated_data):
        activity = validated_data.get('activity')
        if PinPoint.objects.filter(activity=activity).exists():
            raise ValidationError(
                {
                    'detail': 'Pin point already created.'
                }
            )
        return super().create(validated_data)
