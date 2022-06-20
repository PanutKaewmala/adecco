from rest_framework import serializers

from main.apps.common.constants import EXCLUDE_SOFT_DELETE_FIELD
from main.apps.merchandizers.models import PriceTracking, PriceTrackingSetting


class PriceTrackingRetrieveSerializer(serializers.ModelSerializer):
    class Meta:
        model = PriceTracking
        exclude = EXCLUDE_SOFT_DELETE_FIELD


class PriceTrackingListSerializer(PriceTrackingRetrieveSerializer):
    class Meta:
        model = PriceTracking
        fields = ('id', 'date', 'type', 'normal_price', 'promotion_price')


class PriceTrackingWriteSerializer(PriceTrackingRetrieveSerializer):
    pass


class PriceTrackingSettingWriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = PriceTrackingSetting
        exclude = EXCLUDE_SOFT_DELETE_FIELD
