from model_controller.serializers import ModelControllerSerializer
from rest_framework import serializers
from rest_framework.exceptions import ValidationError

from main.apps.common.constants import EXCLUDE_SOFT_DELETE_FIELD, EXCLUDE_SOFT_DELETION_MODEL_CONTROLLER_FIELDS
from main.apps.common.serializers import FlexedWritableNestedModelSerializer
from main.apps.merchandizers.choices import SettingType
from main.apps.merchandizers.models import Product, MerchandizerSetting, MerchandizerProduct, ProductDetail
from main.apps.users.serializers.users import UserCommonSerializer


class ProductDetailWriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProductDetail
        exclude = EXCLUDE_SOFT_DELETE_FIELD


class ProductRetrieveSerializer(FlexedWritableNestedModelSerializer):
    created_user = UserCommonSerializer()
    updated_user = UserCommonSerializer()
    setting_details = serializers.SerializerMethodField()

    class Meta:
        model = Product
        exclude = EXCLUDE_SOFT_DELETE_FIELD
        expandable_fields = {
            'product_details': (ProductDetailWriteSerializer, {'many': True}),
        }

    @staticmethod
    def get_setting_details(instance: Product):
        if not instance.setting:
            return None
        settings_details = instance.setting.get_ancestors(include_self=True).values('id', 'name', 'level_name')
        return {
            settings_detail['level_name']: settings_detail['name']
            for settings_detail in settings_details
        }


class ProductListSerializer(ProductRetrieveSerializer):
    class Meta:
        model = Product
        fields = ('id', 'name', 'setting', 'brand_name', 'price', 'ratio', 'setting_details', 'active')


class ProductWriteSerializer(FlexedWritableNestedModelSerializer, ModelControllerSerializer):
    product_details = ProductDetailWriteSerializer(many=True, required=False)

    class Meta:
        model = Product
        exclude = EXCLUDE_SOFT_DELETION_MODEL_CONTROLLER_FIELDS

    def validate(self, attrs):
        setting = attrs.get('setting')  # type: MerchandizerSetting
        if setting:
            if setting.type != SettingType.PRODUCT:
                raise ValidationError({'detail': f'Setting {setting} is not product setting.'})
        return attrs


class ProductCommonSerializer(ProductRetrieveSerializer):
    setting_level = serializers.ReadOnlyField(source='setting.level_name')
    setting_name = serializers.ReadOnlyField(source='setting.name')

    class Meta:
        model = Product
        fields = ('id', 'name', 'setting_level', 'setting_name')


class ProductMerchandizerSerializer(ProductCommonSerializer):
    merchandizer_product = serializers.SerializerMethodField()

    class Meta(ProductCommonSerializer.Meta):
        fields = ('id', 'name', 'setting_level', 'setting_name', 'merchandizer_product')

    def get_merchandizer_product(self, instance: Product):
        request = self.context.get('request')
        merchandizer = request.query_params.get('merchandizer')

        try:
            return instance.merchandizer_products.get(merchandizer=int(merchandizer)).id
        except MerchandizerProduct.DoesNotExist:
            return None
