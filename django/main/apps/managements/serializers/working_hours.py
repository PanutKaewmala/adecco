from rest_framework import serializers
from rest_framework.exceptions import ValidationError

from main.apps.common.constants import DAY_OF_WEEK_LIST
from main.apps.common.serializers import FlexedWritableNestedModelSerializer
from main.apps.common.utils import get_day_name_by_date_week_day
from main.apps.managements.functions.lead_times import lead_time_dict
from main.apps.managements.functions.projects import get_holiday_of_working_hour
from main.apps.managements.models import WorkingHour
from main.apps.managements.serializers.additional_allowances import AdditionalAllowanceSerializer


class LeadTimeSerializer(serializers.Serializer):
    before = serializers.TimeField()
    time = serializers.TimeField()
    after = serializers.TimeField()


class WorkingHourCommonSerializer(serializers.ModelSerializer):
    start_time = serializers.SerializerMethodField()
    end_time = serializers.SerializerMethodField()

    class Meta:
        model = WorkingHour
        fields = ('id', 'start_time', 'end_time')

    def __init__(self, instance=None, **kwargs):
        super().__init__(instance, **kwargs)
        self.date = self.context.get('date')
        self.date_name = get_day_name_by_date_week_day(self.date) if self.date else None

    def get_start_time(self, instance: WorkingHour):
        start_time = getattr(instance, f'{self.date_name}_start_time')
        return start_time if start_time else None

    def get_end_time(self, instance: WorkingHour):
        end_time = getattr(instance, f'{self.date_name}_end_time')
        return end_time if end_time else None


class WorkingHourWithLeadTimeSerializer(WorkingHourCommonSerializer):
    class Meta(WorkingHourCommonSerializer.Meta):
        fields = ('id', 'start_time', 'end_time')

    def get_start_time(self, instance: WorkingHour):
        start_time = getattr(instance, f'{self.date_name}_start_time')
        lead_time_data = lead_time_dict(
            start_time,
            instance.lead_time_in_before,
            instance.lead_time_in_after,
        ) if start_time else None
        return LeadTimeSerializer(lead_time_data).data

    def get_end_time(self, instance: WorkingHour):
        end_time = getattr(instance, f'{self.date_name}_end_time')
        lead_time_data = lead_time_dict(
            end_time,
            instance.lead_time_out_before,
            instance.lead_time_out_after,
        ) if end_time else None
        return LeadTimeSerializer(lead_time_data).data


class WorkingHourRetrieveSerializer(FlexedWritableNestedModelSerializer):
    class Meta:
        model = WorkingHour
        fields = '__all__'
        expandable_fields = {
            'additional_allowances': (AdditionalAllowanceSerializer, {'many': True}),
        }


class WorkingHourListSerializer(WorkingHourRetrieveSerializer):
    pass


class WorkingHourCommonNameSerializer(WorkingHourRetrieveSerializer):
    class Meta(WorkingHourRetrieveSerializer.Meta):
        fields = ('id', 'name', 'project')


class WorkingHourForRosterSerializer(WorkingHourRetrieveSerializer):
    sunday = serializers.SerializerMethodField()
    monday = serializers.SerializerMethodField()
    tuesday = serializers.SerializerMethodField()
    wednesday = serializers.SerializerMethodField()
    thursday = serializers.SerializerMethodField()
    friday = serializers.SerializerMethodField()
    saturday = serializers.SerializerMethodField()

    @staticmethod
    def get_sunday(instance: WorkingHour):
        return get_holiday_of_working_hour(instance.sunday)

    @staticmethod
    def get_monday(instance: WorkingHour):
        return get_holiday_of_working_hour(instance.monday)

    @staticmethod
    def get_tuesday(instance: WorkingHour):
        return get_holiday_of_working_hour(instance.tuesday)

    @staticmethod
    def get_wednesday(instance: WorkingHour):
        return get_holiday_of_working_hour(instance.wednesday)

    @staticmethod
    def get_thursday(instance: WorkingHour):
        return get_holiday_of_working_hour(instance.thursday)

    @staticmethod
    def get_friday(instance: WorkingHour):
        return get_holiday_of_working_hour(instance.friday)

    @staticmethod
    def get_saturday(instance: WorkingHour):
        return get_holiday_of_working_hour(instance.saturday)


class WorkingHourCreateSerializer(WorkingHourRetrieveSerializer):
    additional_allowances = AdditionalAllowanceSerializer(many=True, required=False)

    def validate(self, attrs):
        error_messages = {
            day: 'start_time and end_time required'
            for day in DAY_OF_WEEK_LIST
            if attrs.get(day) and not all([attrs.get(f'{day}_start_time'), attrs.get(f'{day}_end_time')])
        }
        if error_messages:
            raise ValidationError(error_messages)
        return attrs
