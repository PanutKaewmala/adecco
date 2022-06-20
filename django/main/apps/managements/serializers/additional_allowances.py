from rest_framework import serializers

from main.apps.managements.models import AdditionalAllowance


class AdditionalAllowanceSerializer(serializers.ModelSerializer):

    class Meta:
        model = AdditionalAllowance
        exclude = ('working_hour', )
