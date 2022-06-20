from rest_framework import serializers

from main.apps.common.utils import get_day_name_by_date_week_day
from main.apps.managements.models import WorkPlace, WorkingHour
from main.apps.managements.serializers.working_hours import WorkingHourCommonNameSerializer
from main.apps.managements.serializers.workplaces import WorkPlaceCommonSerializer
from main.apps.rosters.choices import DayStatusType
from main.apps.rosters.models import AdjustRequest
from main.apps.users.models import EmployeeProject


class AdjustRequestRetrieveSerializer(serializers.ModelSerializer):
    employee_name = serializers.CharField(source='employee_project.employee.user.full_name')
    working_hour = WorkingHourCommonNameSerializer()
    date = serializers.DateField()
    workplaces = WorkPlaceCommonSerializer(many=True)
    day_name = serializers.SerializerMethodField(default=None)

    class Meta:
        model = AdjustRequest
        exclude = ('alive',)

    @staticmethod
    def get_day_name(instance: AdjustRequest):
        return get_day_name_by_date_week_day(instance.date)


class AdjustRequestListSerializer(AdjustRequestRetrieveSerializer):
    working_hour = serializers.CharField(source='working_hour.name')


class AdjustRequestWriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = AdjustRequest
        exclude = ('alive',)


class AdjustRequestEmployeeListValidateSerialzier(serializers.Serializer):
    employee_project = serializers.PrimaryKeyRelatedField(queryset=EmployeeProject.objects.all())
    type = serializers.ChoiceField(choices=DayStatusType.choices)
    workplaces = serializers.PrimaryKeyRelatedField(queryset=WorkPlace.objects.all(), many=True)
    working_hour = serializers.PrimaryKeyRelatedField(queryset=WorkingHour.objects.all())


class AdjustRequestValidateSerialzier(serializers.Serializer):
    date = serializers.DateField(required=True)
    employee_list = AdjustRequestEmployeeListValidateSerialzier(many=True)
