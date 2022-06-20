from rest_framework import serializers

from main.apps.managements.serializers.workplaces import WorkPlaceCommonSerializer
from main.apps.rosters.models import Schedule


class ScheduleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Schedule
        fields = '__all__'


class ScheduleRetrieveSerializer(ScheduleSerializer):
    workplaces = WorkPlaceCommonSerializer(many=True)
