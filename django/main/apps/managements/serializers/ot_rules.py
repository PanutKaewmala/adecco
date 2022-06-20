from rest_framework import serializers

from main.apps.managements.models import OTRule


class OTRuleSerializer(serializers.ModelSerializer):
    class Meta:
        model = OTRule
        fields = '__all__'
