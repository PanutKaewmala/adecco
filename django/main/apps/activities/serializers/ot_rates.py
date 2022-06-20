from rest_framework import serializers


class OTRateSerializer(serializers.Serializer):
    pay_code = serializers.CharField()
    ot_hours = serializers.CharField()
    total_hours = serializers.CharField()
    day_type = serializers.CharField()
    time_type = serializers.CharField()
