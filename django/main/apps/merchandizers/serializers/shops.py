from model_controller.serializers import ModelControllerSerializer
from rest_framework import serializers
from rest_framework.exceptions import ValidationError

from main.apps.common.constants import EXCLUDE_SOFT_DELETION_MODEL_CONTROLLER_FIELDS, EXCLUDE_SOFT_DELETE_FIELD
from main.apps.common.serializers import FlexedWritableNestedModelSerializer
from main.apps.merchandizers.choices import SettingType
from main.apps.merchandizers.models import Shop, MerchandizerSetting, Product, ShopDetail
from main.apps.merchandizers.serializers.products import ProductCommonSerializer
from main.apps.users.serializers.users import UserCommonSerializer


class ShopDetailWriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = ShopDetail
        exclude = EXCLUDE_SOFT_DELETE_FIELD


class ShopRetrieveSerializer(FlexedWritableNestedModelSerializer):
    created_user = UserCommonSerializer()
    updated_user = UserCommonSerializer()

    class Meta:
        model = Shop
        exclude = EXCLUDE_SOFT_DELETE_FIELD
        expandable_fields = {
            'shop_details': (ShopDetailWriteSerializer, {'many': True}),
            'products': (ProductCommonSerializer, {'many': True}),
        }


class ShopListSerializer(ShopRetrieveSerializer):
    open_time = serializers.CharField(default=None)

    class Meta:
        model = Shop
        fields = ('id', 'name', 'setting', 'product_total', 'open_time', 'telephone', 'city', 'active')


class ShopWriteSerializer(FlexedWritableNestedModelSerializer, ModelControllerSerializer):
    shop_details = ShopDetailWriteSerializer(many=True, required=False)
    products = serializers.PrimaryKeyRelatedField(queryset=Product.objects.all(), required=False, many=True)

    class Meta:
        model = Shop
        exclude = EXCLUDE_SOFT_DELETION_MODEL_CONTROLLER_FIELDS

    def validate(self, attrs):
        setting = attrs.get('setting')  # type: MerchandizerSetting
        if setting:
            if setting.type != SettingType.SHOP:
                raise ValidationError({'detail': f'Setting {setting} is not shop setting.'})
        return attrs


class ShopDetailSerializer(ShopRetrieveSerializer):
    class Meta:
        model = Shop
        fields = ('id', 'name', 'product_total', 'open_time', 'shop_id', 'address_1', 'telephone')


class ShopCommonSerializer(ShopDetailSerializer):
    level = serializers.CharField(source='setting.level_name')

    class Meta(ShopDetailSerializer.Meta):
        fields = ('id', 'name', 'level')


class AddProductsInMultipleShopSerializer(serializers.Serializer):
    shops = serializers.PrimaryKeyRelatedField(queryset=Shop.objects.all(), many=True, required=True)
    products = serializers.PrimaryKeyRelatedField(queryset=Product.objects.all(), many=True, required=True)
