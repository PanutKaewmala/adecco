import typing

from rest_framework import serializers
from rest_framework.exceptions import ValidationError
from rest_framework.validators import UniqueTogetherValidator

from main.apps.common.constants import EXCLUDE_SOFT_DELETE_FIELD
from main.apps.common.serializers import FlexedWritableNestedModelSerializer
from main.apps.managements.models import Client
from main.apps.merchandizers.models import Merchandizer, Shop, MerchandizerProduct  # pylint: disable=unused-import
from main.apps.merchandizers.serializers.products import ProductCommonSerializer
from main.apps.merchandizers.serializers.shops import ShopDetailSerializer, ShopCommonSerializer
from main.apps.users.models import EmployeeProject


class MerchandizerProductRetrieveSerializer(serializers.ModelSerializer):
    class Meta:
        model = MerchandizerProduct
        exclude = EXCLUDE_SOFT_DELETE_FIELD + ('merchandizer', )


class MerchandizerProductCommonSerializer(MerchandizerProductRetrieveSerializer):
    product = ProductCommonSerializer()


class MerchandizerRetrieveSerializer(FlexedWritableNestedModelSerializer):
    merchandizer_products = MerchandizerProductCommonSerializer(many=True)

    class Meta:
        model = Merchandizer
        exclude = EXCLUDE_SOFT_DELETE_FIELD


class MerchandizerListSerializer(MerchandizerRetrieveSerializer):
    shop = ShopCommonSerializer()

    class Meta:
        model = Merchandizer
        fields = ('id', 'shop', 'employee_project', 'product_total')


class MerchandizerWriteSerializer(MerchandizerRetrieveSerializer):
    merchandizer_products = MerchandizerProductRetrieveSerializer(many=True)

    def validate(self, attrs):
        employee_project = attrs.get('employee_project')  # type: EmployeeProject
        client = employee_project.project.client  # type: Client
        shop = attrs.get('shop')  # type: Shop
        merchandizer_products = attrs.get('merchandizer_products')  # type: typing.List[dict]
        if shop.setting.client != client:
            raise ValidationError({'detail': f'Shop setting {shop.name} not in client {client.name}'})
        if any(
                data['product'].setting.client != client
                for data in merchandizer_products
        ):
            raise ValidationError({'detail': f'Product setting not in client {client.name}'})

        validators = [
            UniqueTogetherValidator(
                queryset=Merchandizer.objects.filter(shop=shop, employee_project=employee_project).all(),
                message='Duplicate shop in employee',
                fields=['shop', 'employee_project']
            ),
        ]

        for validator in validators:
            validator.__call__(attrs, self)

        return attrs


class MerchandizerCommonSerializer(MerchandizerRetrieveSerializer):
    shop = ShopDetailSerializer()
    merchandizer_products = MerchandizerProductCommonSerializer(many=True)

    class Meta:
        model = Merchandizer
        fields = ('id', 'shop', 'merchandizer_products')


class MerchandizerMeSerializer(MerchandizerRetrieveSerializer):
    shop = ShopCommonSerializer()

    class Meta:
        model = Merchandizer
        fields = ('id', 'shop')
