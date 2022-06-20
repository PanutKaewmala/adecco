from rest_framework import serializers

from main.apps.common.serializers import FlexedWritableNestedModelSerializer
from main.apps.rosters.choices import RosterStatusType, RosterType
from main.apps.rosters.functions.shifts import delete_shift_not_found_in_payload
from main.apps.rosters.functions.validates import associate_edit_roster_change_status_to_pending
from main.apps.rosters.functions.validates import validate_employee_project_and_date_range_must_unique
from main.apps.rosters.functions.validates import validate_roster_setting
from main.apps.rosters.models import Roster, Schedule
from main.apps.rosters.serializers.day_offs import DayOffSerializer, PreviewDayOffSerializer, DayOffRetrieveSerializer
from main.apps.rosters.serializers.shifts import ShiftSerializer, ShiftRetrieveSerializer, \
    PreviewShiftSerializer, ShiftMobileListSerializer
from main.apps.users.serializers.employees import EmployeeProjectRosterCommonSerializer


class RosterWriteSerializer(FlexedWritableNestedModelSerializer):
    shifts = ShiftSerializer(many=True, required=True)
    remark = serializers.CharField(required=False, allow_null=True)
    description = serializers.CharField(required=False, allow_blank=True, allow_null=True)
    type = serializers.CharField(default=RosterType.SHIFT)

    class Meta:
        model = Roster
        fields = '__all__'

    def create(self, validated_data):
        validate_employee_project_and_date_range_must_unique(validated_data)

        request = self.context.get('request')
        validated_data = validate_roster_setting(request, validated_data)
        return super().create(validated_data)

    def update(self, instance, validated_data):
        validate_employee_project_and_date_range_must_unique(validated_data, instance)

        request = self.context.get('request')
        validated_data = validate_roster_setting(request, validated_data)
        delete_shift_not_found_in_payload(instance=instance, request_data=request.data)
        instance = super().update(instance, validated_data)
        return associate_edit_roster_change_status_to_pending(instance, request.user)


class RosterRetrieveSerializer(RosterWriteSerializer):
    employee_projects = EmployeeProjectRosterCommonSerializer(many=True)
    project = serializers.SerializerMethodField(method_name='get_project')
    working_hours = serializers.SerializerMethodField(method_name='get_working_hours')
    shifts = serializers.SerializerMethodField(method_name='get_shifts')
    day_off = serializers.ListField(source='day_off.get_day_off_list', default=[])
    holiday_list = serializers.ListField(source='day_off.get_holiday_days_list', default=[])
    total_days = serializers.IntegerField(source='get_total_days', default=None)

    @staticmethod
    def get_project(instance: Roster):
        first_employee_project = instance.employee_projects.first()
        return first_employee_project.project.name if first_employee_project else None

    @staticmethod
    def get_working_hours(instance: Roster):
        if instance.type == RosterType.SHIFT:
            return set(shift.working_hour.name for shift in instance.shifts_without_delete.all())
        elif instance.type == RosterType.DAY_OFF:
            return [instance.day_off.working_hour.name]

    @staticmethod
    def get_shifts(instance: Roster):
        if instance.type == RosterType.SHIFT:
            serializer = ShiftRetrieveSerializer(instance=instance.shifts_without_delete.all().order_by('from_date'), many=True)
            return serializer.data
        if instance.type == RosterType.DAY_OFF:
            return [DayOffRetrieveSerializer(instance.day_off).data]
        return []


class RosterListSerializer(RosterRetrieveSerializer):
    employee_name_list = serializers.ListField(source='get_employee_name_list')
    workplaces = serializers.SerializerMethodField(method_name='get_workplaces')

    class Meta(RosterRetrieveSerializer.Meta):
        fields = ('id', 'name', 'status', 'start_date', 'end_date', 'type', 'workplaces', 'employee_name_list',
                  'working_hours', 'description')

    @staticmethod
    def get_workplaces(instance: Roster):
        if instance.type == RosterType.SHIFT:
            return Schedule.objects.filter(shift__roster=instance).values_list('workplaces__name', flat=True).distinct()
        if instance.type == RosterType.DAY_OFF:
            return instance.day_off.get_workplaces_list


class RosterMobileListSerializer(serializers.Serializer):
    shifts = ShiftMobileListSerializer(many=True)
    id = serializers.IntegerField()
    name = serializers.CharField()
    type = serializers.CharField()
    status = serializers.ChoiceField(choices=RosterStatusType.choices)
    start_date = serializers.DateField()
    end_date = serializers.DateField()
    description = serializers.CharField()
    working_hours = serializers.ListField()
    employee_name_list = serializers.ListField()


class RosterActionSerializer(serializers.Serializer):
    status = serializers.ChoiceField(choices=RosterStatusType.choices)
    remark = serializers.CharField(required=False)


class RosterDayOffWriteSerializer(FlexedWritableNestedModelSerializer):
    remark = serializers.CharField(required=False)
    type = serializers.CharField(default=RosterType.DAY_OFF)
    day_off = DayOffSerializer(required=True)

    class Meta:
        model = Roster
        fields = '__all__'

    def create(self, validated_data):
        validate_employee_project_and_date_range_must_unique(validated_data)

        request = self.context.get('request')
        validated_data = validate_roster_setting(request, validated_data)
        return super().create(validated_data)

    def update(self, instance, validated_data):
        validate_employee_project_and_date_range_must_unique(validated_data, instance)

        request = self.context.get('request')
        validated_data = validate_roster_setting(request, validated_data)

        instance = super().update(instance, validated_data)
        return associate_edit_roster_change_status_to_pending(instance, request.user)


class PreviewRosterTypeShiftSerializer(RosterWriteSerializer):
    shifts = PreviewShiftSerializer(many=True)


class PreviewRosterTypeDayOffSerializer(RosterDayOffWriteSerializer):
    day_off = PreviewDayOffSerializer()


class RosterCommonSerializer(RosterRetrieveSerializer):
    class Meta(RosterRetrieveSerializer.Meta):
        fields = ('id', 'name', 'start_date', 'end_date', 'description', 'status', 'working_hours')
