import typing

from django.db import transaction
from django.db.models import QuerySet
from django_filters.rest_framework import DjangoFilterBackend
from drf_spectacular.utils import extend_schema
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.filters import OrderingFilter
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

from main.apps.common.functions import user_in_admin_or_manager_roles
from main.apps.common.permissions import IsSuperAdminOrAdmin
from main.apps.common.utils import optimize_expanded_query
from main.apps.common.views import ActionRelatedSerializerMixin
from main.apps.merchandizers.filters import MerchandizerSettingFilter, ShopFilter, ProductFilter, PriceTrackingFilter, \
    MerchandizerFilter
from main.apps.merchandizers.models import MerchandizerSetting, Shop, Product, Merchandizer, PriceTracking
from main.apps.merchandizers.serializers.merchandizer_settings import MerchandizerSettingUpdateSerializer, \
    MerchandizerSettingCreateSerializer, MerchandizerSettingListSerializer, MerchandizerSettingRetrieveSerializer, \
    MerchandizerSettingCommonSerializer
from main.apps.merchandizers.serializers.merchandizers import MerchandizerRetrieveSerializer, \
    MerchandizerListSerializer, MerchandizerWriteSerializer, MerchandizerMeSerializer
from main.apps.merchandizers.serializers.price_tracking import PriceTrackingWriteSerializer, \
    PriceTrackingListSerializer, PriceTrackingRetrieveSerializer
from main.apps.merchandizers.serializers.products import ProductRetrieveSerializer, ProductListSerializer, \
    ProductWriteSerializer, ProductMerchandizerSerializer
from main.apps.merchandizers.serializers.shops import ShopWriteSerializer, ShopRetrieveSerializer, ShopListSerializer, \
    AddProductsInMultipleShopSerializer
from main.apps.merchandizers.utils import user_merchandizer_exists


class MerchandizerSettingViewSet(ActionRelatedSerializerMixin, viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated, IsSuperAdminOrAdmin]
    queryset = MerchandizerSetting.objects.prefetch_related('shops', 'products').all().order_by('-id')
    filterset_class = MerchandizerSettingFilter
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    retrieve_serializer_class = MerchandizerSettingRetrieveSerializer
    list_serializer_class = MerchandizerSettingListSerializer
    create_serializer_class = MerchandizerSettingCreateSerializer
    update_serializer_class = MerchandizerSettingUpdateSerializer
    ordering_fields = ('id', 'name')

    def get_queryset(self):
        self.queryset = optimize_expanded_query(
            request=self.request,
            queryset=self.queryset,
            prefetch_related={
                'shops': 'shops',
                'products': 'products',
                'children': 'children',
            }
        )
        return super().get_queryset()

    def create(self, request, *args, **kwargs):
        if 'settings' in request.data:
            # create multiple settings
            data = request.data.get('settings')
            serializer = self.create_serializer_class(data=data, many=True)
            serializer.is_valid(raise_exception=True)
            serializer.save()
            return Response(serializer.data)
        return super().create(request, *args, **kwargs)

    @action(detail=False, methods=['GET'], list_serializer_class=MerchandizerSettingCommonSerializer,
            permission_classes=[IsAuthenticated])
    def merchandizer(self, request):
        merchandizer_id = request.query_params.get('merchandizer')
        user_merchandizer_exists(request.user, merchandizer_id)

        return super().list(request)


class ShopViewSet(ActionRelatedSerializerMixin, viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated, IsSuperAdminOrAdmin]
    queryset = Shop.objects.select_related('setting').all().order_by('-id')
    filterset_class = ShopFilter
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    list_serializer_class = ShopListSerializer
    retrieve_serializer_class = ShopRetrieveSerializer
    write_serializer_class = ShopWriteSerializer
    ordering_fields = ('id', 'name')

    def get_queryset(self):
        self.queryset = optimize_expanded_query(
            request=self.request,
            queryset=self.queryset,
            prefetch_related={
                'products': 'products',
                'shop_details': 'shop_details',
            }
        )
        return super().get_queryset()

    @extend_schema(request=AddProductsInMultipleShopSerializer)
    @action(detail=False, methods=['POST'], url_path='add-products-in-multiple-shop',
            url_name='add-products-in-multiple-shop')
    def add_products_in_multiple_shop(self, request):
        serializer = AddProductsInMultipleShopSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        validated_data = serializer.validated_data
        shops = validated_data.get('shops')  # type: typing.List[Shop]
        products = validated_data.get('products')  # type: typing.List[Product]
        with transaction.atomic():
            for shop in shops:
                shop.products.add(*products)
        return Response('success', status=status.HTTP_201_CREATED)


class ProductViewSet(ActionRelatedSerializerMixin, viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated, IsSuperAdminOrAdmin]
    queryset = Product.objects.select_related('setting').all().order_by('-id')
    filterset_class = ProductFilter
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    retrieve_serializer_class = ProductRetrieveSerializer
    list_serializer_class = ProductListSerializer
    write_serializer_class = ProductWriteSerializer

    def get_queryset(self):
        self.queryset = optimize_expanded_query(
            request=self.request,
            queryset=self.queryset,
            prefetch_related={
                'product_details': 'product_details',
            }
        )
        return super().get_queryset()

    @action(detail=False, methods=['GET'], list_serializer_class=ProductMerchandizerSerializer,
            permission_classes=[IsAuthenticated])
    def merchandizer(self, request):
        merchandizer_id = request.query_params.get('merchandizer')
        user_merchandizer_exists(request.user, merchandizer_id)

        return super().list(request)


class MerchandizerViewSet(ActionRelatedSerializerMixin, viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated]
    queryset = Merchandizer.objects.select_related('shop') \
        .prefetch_related('merchandizer_products').all().order_by('-id')
    retrieve_serializer_class = MerchandizerRetrieveSerializer
    list_serializer_class = MerchandizerListSerializer
    write_serializer_class = MerchandizerWriteSerializer
    filterset_class = MerchandizerFilter

    def get_queryset(self):
        user = self.request.user
        if not user_in_admin_or_manager_roles(user):
            self.queryset = self.queryset. \
                filter(employee_project__employee__user=user)
        return super().get_queryset()

    def create(self, request, *args, **kwargs):
        if isinstance(request.data, list):
            for merchandizer in request.data:
                serializer = MerchandizerWriteSerializer(data=merchandizer)
                serializer.is_valid(raise_exception=True)
                serializer.save()
            return Response('created', status=status.HTTP_201_CREATED)
        return super().create(request, args, kwargs)

    @extend_schema(responses=MerchandizerMeSerializer, parameters=[MerchandizerFilter])
    @action(detail=False, methods=['GET'])
    def me(self, request):
        queryset = self.filter_queryset(self.get_queryset())  # type: QuerySet[Merchandizer]
        page = self.paginate_queryset(queryset)
        if page is not None:
            return self.get_paginated_response(MerchandizerMeSerializer(page, many=True).data)

        return Response(MerchandizerMeSerializer(queryset, many=True).data)


class PriceTrackingViewSet(ActionRelatedSerializerMixin, viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated]
    queryset = PriceTracking.objects.all().order_by('-id')
    retrieve_serializer_class = PriceTrackingRetrieveSerializer
    list_serializer_class = PriceTrackingListSerializer
    write_serializer_class = PriceTrackingWriteSerializer
    filterset_class = PriceTrackingFilter

    def get_queryset(self):
        user = self.request.user
        if not user_in_admin_or_manager_roles(user):
            self.queryset = self.queryset. \
                filter(merchandizer_product__merchandizer__employee_project__employee__user=user)
        return super().get_queryset()
