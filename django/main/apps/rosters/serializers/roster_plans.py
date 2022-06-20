from rest_framework import serializers

from main.apps.rosters.choices import RosterType, ActionStatusType
from main.apps.rosters.functions.roster_plans import filter_shifts_from_roster_plan_type
from main.apps.rosters.models import Roster, Shift
from main.apps.rosters.serializers.day_offs import DayOffDetailSerializer
from main.apps.rosters.serializers.schedules import ScheduleSerializer
from main.apps.users.models import EmployeeProject


class RosterPlansRosterSerializer(serializers.ModelSerializer):
    start = serializers.DateField(source='start_date')
    end = serializers.DateField(source='end_date')
    roster_name = serializers.CharField(source='name')

    class Meta:
        model = Roster
        fields = ('id', 'start', 'end', 'roster_name', 'status', 'roster_setting', 'type')


class ShiftForRosterPlansSerializer(serializers.ModelSerializer):
    start = serializers.DateField(source='from_date')
    end = serializers.DateField(source='to_date')
    working_hour = serializers.CharField(source='working_hour.name')
    workplaces = serializers.ListField(source='get_all_workplaces_in_shift')
    schedules = ScheduleSerializer(many=True)
    holiday_list = serializers.ListField(source='get_holiday_list', default=[])
    roster = RosterPlansRosterSerializer()

    class Meta:
        model = Shift
        fields = ('id', 'start', 'end', 'working_hour', 'workplaces', 'schedules', 'holiday_list', 'roster')


class RosterPlansEmployeeProjectSerializer(serializers.ModelSerializer):
    employee_name = serializers.CharField(source='employee.user.full_name')

    class Meta:
        model = EmployeeProject
        fields = ('id', 'employee_name')


class RosterPlansSerializer(serializers.ModelSerializer):
    shifts = serializers.SerializerMethodField(method_name='get_shift_by_roster_type')
    employee_projects = RosterPlansEmployeeProjectSerializer(many=True)

    class Meta:
        model = Roster
        fields = ('id', 'shifts', 'employee_projects')

    def __init__(self, instance=None, **kwargs):
        self.roster_plan_date = kwargs.pop('roster_plan_date')
        self.roster_plan_type = kwargs.pop('roster_plan_type')
        super().__init__(instance, **kwargs)

    def get_shift_by_roster_type(self, instance: Roster):
        if instance.type == RosterType.SHIFT:
            shifts_queryset = instance.shifts.select_related('working_hour').exclude(
                status__in=[ActionStatusType.EDIT_PENDING, ActionStatusType.EDIT_REJECT, ActionStatusType.DELETE]
            ).all().order_by('from_date')
            shifts_filter = filter_shifts_from_roster_plan_type(shifts_queryset,
                                                                self.roster_plan_date,
                                                                self.roster_plan_type)
            return ShiftForRosterPlansSerializer(shifts_filter, many=True).data
        if instance.type == RosterType.DAY_OFF:
            day_off = instance.day_off
            return [
                {
                    'id': day_off.id,
                    'start': instance.start_date,
                    'end': instance.end_date,
                    'status': day_off.status,
                    'details': DayOffDetailSerializer(day_off.details.all(), many=True).data,
                    'working_hour': day_off.working_hour.name,
                    'workplaces': day_off.get_workplaces_list,
                    'holiday_list': day_off.get_holiday_days_list,
                    'roster': RosterPlansRosterSerializer(day_off.roster).data
                }
            ]
        return []
