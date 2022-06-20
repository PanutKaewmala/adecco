from rest_framework import serializers

from main.apps.rosters.models import EditShift
from main.apps.rosters.serializers.rosters import RosterCommonSerializer
from main.apps.rosters.serializers.shifts import ShiftRetrieveSerializer


class EditShiftSerializer(serializers.ModelSerializer):
    employee_name_list = serializers.ListField(source='from_shift.roster.get_employee_name_list')
    roster_name = serializers.CharField(source='from_shift.roster.name')
    to_working_hour = serializers.CharField(source='to_shift.working_hour.name')
    to_workplaces = serializers.ListField(source='to_shift.get_all_workplaces_in_shift')

    class Meta:
        model = EditShift
        fields = '__all__'


class EditShiftRetrieveSerializer(serializers.ModelSerializer):
    employee_name_list = serializers.ListField(source='from_shift.roster.get_employee_name_list')
    roster_detail = RosterCommonSerializer(source='from_shift.roster')
    from_shift = ShiftRetrieveSerializer()
    to_shift = ShiftRetrieveSerializer()

    class Meta:
        model = EditShift
        fields = '__all__'
