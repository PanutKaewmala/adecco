from rest_framework import serializers

from main.apps.common.serializers import FlexedWritableNestedModelSerializer
from main.apps.managements.models import WorkingHour
from main.apps.rosters.choices import ActionStatusType
from main.apps.rosters.models import DayOff, DayOffDetail


class DayOffDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = DayOffDetail
        fields = ('id', 'date')


class DayOffSerializer(FlexedWritableNestedModelSerializer):
    status = serializers.ChoiceField(choices=ActionStatusType.choices, default=ActionStatusType.PENDING)
    details = DayOffDetailSerializer(many=True, required=False, write_only=True)
    detail_list = serializers.ListField(source='get_day_off_list', read_only=True)

    class Meta:
        model = DayOff
        fields = ('id', 'status', 'details', 'working_hour', 'detail_list')


class DayOffRetrieveSerializer(serializers.ModelSerializer):
    details = DayOffDetailSerializer(many=True, required=False)
    workplaces = serializers.ListField(source='get_workplaces_list')
    work_days = serializers.ListField(source='get_work_days_list')
    working_hour = serializers.CharField(source='working_hour.name')
    from_date = serializers.DateField(source='roster.start_date')
    to_date = serializers.DateField(source='roster.end_date')

    class Meta:
        model = DayOff
        fields = ('id', 'status', 'details', 'working_hour', 'workplaces', 'work_days', 'from_date', 'to_date')


class PreviewDayOffSerializer(DayOffSerializer):
    working_hour = serializers.CharField()
    working_hour_id = serializers.IntegerField()
    detail_list = serializers.ListField()

    def to_internal_value(self, data):
        data['working_hour_id'] = data['working_hour']
        data['working_hour'] = WorkingHour.objects.get(id=data['working_hour']).name
        return super().to_internal_value(data)

    class Meta(DayOffSerializer.Meta):
        fields = ('working_hour', 'working_hour_id', 'detail_list')
