from rest_framework import serializers

from main.apps.common.serializers import FlexedWritableNestedModelSerializer
from main.apps.managements.models import WorkingHour, WorkPlace
from main.apps.managements.serializers.workplaces import WorkPlaceCommonSerializer
from main.apps.rosters.choices import ActionStatusType, RosterStatusType
from main.apps.rosters.models import Shift
from main.apps.rosters.serializers.schedules import ScheduleSerializer, ScheduleRetrieveSerializer


class ShiftSerializer(FlexedWritableNestedModelSerializer):
    schedules = ScheduleSerializer(many=True)
    working_hour = serializers.PrimaryKeyRelatedField(queryset=WorkingHour.objects.all(), required=True)
    remark = serializers.CharField(required=False, allow_null=True)
    status = serializers.ChoiceField(choices=ActionStatusType.choices, default=ActionStatusType.PENDING)

    class Meta:
        model = Shift
        fields = '__all__'

    def create(self, validated_data):
        roster = validated_data.get('roster')
        if roster and validated_data['status'] != ActionStatusType.EDIT_PENDING:
            validated_data['status'] = ActionStatusType.APPROVE \
                if roster.status == RosterStatusType.APPROVE \
                else ActionStatusType.PENDING

        return super().create(validated_data)

    def update(self, instance, validated_data):
        """
            delete all schedule make NestUpdate create it again
            because NestUpdate do UniqueConstraint in first update schedule
        """
        instance.schedules.all().delete()
        return super().update(instance, validated_data)


class PreviewShiftSerializer(ShiftSerializer):
    schedules = ScheduleRetrieveSerializer(many=True)
    working_hour = serializers.CharField()

    def to_internal_value(self, data):
        def map_id_to_instance_workplace(schedule: dict):
            serializer = WorkPlaceCommonSerializer(instance=WorkPlace.objects.filter(id__in=schedule['workplaces']),
                                                   many=True)
            schedule['workplaces'] = serializer.data
            return schedule

        data['schedules'] = list(map_id_to_instance_workplace(schedule) for schedule in data['schedules'])
        data['working_hour'] = WorkingHour.objects.get(id=data['working_hour']).name
        return super().to_internal_value(data)


class ShiftRetrieveSerializer(ShiftSerializer):
    schedules = ScheduleRetrieveSerializer(many=True)
    working_hour = serializers.CharField(source='working_hour.name')
    total_days = serializers.IntegerField(source='get_total_days', default=None)


class ShiftMobileListSerializer(serializers.Serializer):
    id = serializers.IntegerField(default=None)
    status = serializers.ChoiceField(choices=ActionStatusType.choices, default=None)
    working_hour = serializers.CharField()
    from_date = serializers.DateField()
    to_date = serializers.DateField()
    sunday = serializers.ReadOnlyField(default=None)
    monday = serializers.ReadOnlyField(default=None)
    tuesday = serializers.ReadOnlyField(default=None)
    wednesday = serializers.ReadOnlyField(default=None)
    thursday = serializers.ReadOnlyField(default=None)
    friday = serializers.ReadOnlyField(default=None)
    saturday = serializers.ReadOnlyField(default=None)

    class Meta:
        model = Shift
