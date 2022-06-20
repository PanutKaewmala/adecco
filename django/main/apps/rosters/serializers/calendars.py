from rest_framework import serializers

from main.apps.rosters.choices import DayStatusType


class CalendarDateSerializer(serializers.Serializer):
    date = serializers.DateField()
    type = serializers.ChoiceField(choices=DayStatusType.choices)


class CalendarResponseSerializer(serializers.Serializer):
    month_name = serializers.CharField()
    calendars = CalendarDateSerializer(many=True)
