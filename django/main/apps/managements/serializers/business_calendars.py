from rest_framework import serializers

from main.apps.managements.models import BusinessCalendar


class BusinessCalendarSerializer(serializers.ModelSerializer):
    class Meta:
        model = BusinessCalendar
        fields = '__all__'


class DefaultBusinessCalendar(serializers.Serializer):
    date = serializers.DateField(source='date.iso')
    name = serializers.ReadOnlyField()
