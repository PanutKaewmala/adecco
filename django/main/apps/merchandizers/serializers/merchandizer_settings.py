from rest_framework import serializers
from rest_framework.validators import UniqueTogetherValidator

from main.apps.common.constants import EXCLUDE_SOFT_DELETE_FIELD
from main.apps.common.serializers import FlexedWritableNestedModelSerializer
from main.apps.managements.models import Client
from main.apps.merchandizers.choices import MerchandizerSettingType, SettingType
from main.apps.merchandizers.models import MerchandizerSetting
from main.apps.merchandizers.serializers.products import ProductListSerializer
from main.apps.merchandizers.serializers.shops import ShopListSerializer


class MerchandizerSettingCommonSerializer(serializers.ModelSerializer):
    class Meta:
        model = MerchandizerSetting
        fields = ('id', 'name', 'level_name')


class MerchandizerSettingRetrieveSerializer(FlexedWritableNestedModelSerializer):
    class Meta:
        model = MerchandizerSetting
        exclude = EXCLUDE_SOFT_DELETE_FIELD + ('lft', 'rght', 'tree_id', 'level')
        expandable_fields = {
            'shops': (ShopListSerializer, {'many': True}),
            'products': (ProductListSerializer, {'many': True}),
            'children': (MerchandizerSettingCommonSerializer, {'many': True}),
        }


class MerchandizerSettingListSerializer(MerchandizerSettingRetrieveSerializer):
    shop_total = serializers.IntegerField()
    product_total = serializers.IntegerField()

    class Meta(MerchandizerSettingRetrieveSerializer.Meta):
        exclude = MerchandizerSettingRetrieveSerializer.Meta.exclude + ('parent',)


class MerchandizerSettingCreateSerializer(MerchandizerSettingRetrieveSerializer):
    def validate(self, attrs):
        client = attrs.get('client')  # type: Client
        setting_type = attrs.get('type')  # type: SettingType.choices
        level_name = attrs.get('level_name')  # type: MerchandizerSettingType.choices

        validators = [
            UniqueTogetherValidator(
                queryset=MerchandizerSetting.objects.filter(client=client, type=setting_type,
                                                            level_name=level_name).all(),
                message='Duplicate setting name',
                fields=['name', 'type', 'level_name', 'client']
            ),
        ]

        for validator in validators:
            validator.__call__(attrs, self)

        return attrs


class MerchandizerSettingUpdateSerializer(MerchandizerSettingCreateSerializer):
    class Meta(MerchandizerSettingCreateSerializer.Meta):
        extra_kwargs = {
            'parent': {'read_only': True},
            'type': {'read_only': True},
            'level_name': {'read_only': True}
        }
