import django_filters
from django.db.models import QuerySet
from rest_framework.exceptions import ValidationError

from main.apps.merchandizers.models import MerchandizerSetting, Shop, Product, PriceTracking, Merchandizer, \
    MerchandizerQuestion


class MerchandizerSettingFilter(django_filters.FilterSet):
    parent_only = django_filters.BooleanFilter(label='parent_only', method='get_parent_only')
    name = django_filters.CharFilter(label='name', field_name='name', lookup_expr='icontains')
    merchandizer = django_filters.NumberFilter(label='merchandizer',
                                               field_name='products__merchandizer_products__merchandizer')

    class Meta:
        model = MerchandizerSetting
        fields = ('id', 'level_name', 'type', 'parent', 'name', 'parent_only', 'client', 'merchandizer')

    @staticmethod
    def get_parent_only(queryset: QuerySet[MerchandizerSetting], name, value):
        if value:
            queryset = queryset.filter(parent__isnull=True)
        return queryset

    def filter_merchandizer(self, queryset: QuerySet[Product], name, value):
        if value:
            queryset = queryset.filter(products__merchandizer_products__merchandizer=value,
                                       products__merchandizer_products__alive=True).distinct()
        return queryset


class MerchandizerQuestionFilter(django_filters.FilterSet):
    name = django_filters.CharFilter(label='name', field_name='name', lookup_expr='icontains')

    class Meta:
        model = MerchandizerQuestion
        fields = '__all__'


class ShopFilter(django_filters.FilterSet):
    name = django_filters.CharFilter(label='name', field_name='name', lookup_expr='icontains')
    client = django_filters.NumberFilter(label='client', field_name='setting__client')
    group_only = django_filters.BooleanFilter(label='parent_only', method='get_group_only')

    class Meta:
        model = Shop
        fields = ('id', 'setting', 'name', 'client', 'setting', 'group_only')

    @staticmethod
    def get_group_only(queryset: QuerySet[Shop], name, value):
        if value:
            queryset = queryset.filter(setting__parent__isnull=True)
        return queryset


class ProductFilter(django_filters.FilterSet):
    name = django_filters.CharFilter(label='name', field_name='name', lookup_expr='icontains')
    client = django_filters.NumberFilter(label='client', field_name='setting__client')
    group_only = django_filters.BooleanFilter(label='parent_only', method='filter_group_only')
    merchandizer = django_filters.NumberFilter(label='merchandizer', method='filter_merchandizer')
    setting = django_filters.NumberFilter(label='setting', method='filter_setting')
    shop = django_filters.NumberFilter(label='shop', field_name='shops__id')

    class Meta:
        model = Product
        fields = ('id', 'setting', 'name', 'client', 'merchandizer', 'setting', 'group_only', 'barcode_number', 'shop')

    @staticmethod
    def filter_group_only(queryset: QuerySet[Product], name, value):
        if value:
            queryset = queryset.filter(setting__parent__isnull=True)
        return queryset

    def filter_setting(self, queryset: QuerySet[Product], name, value):
        if value:
            descendants = self.request.query_params.get('descendants')
            if descendants:
                try:
                    instance: MerchandizerSetting = MerchandizerSetting.objects.get(id=value)
                except MerchandizerSetting.DoesNotExist:
                    raise ValidationError({'detail': 'Setting does not exist'})
                setting_list = list(instance.get_descendants(include_self=True).values_list('id', flat=True))
                queryset = queryset.filter(setting__in=setting_list)
            else:
                queryset = queryset.filter(setting=value)
        return queryset

    def filter_merchandizer(self, queryset: QuerySet[Product], name, value):
        if value:
            queryset = queryset.filter(merchandizer_products__merchandizer=value,
                                       merchandizer_products__alive=True).distinct()
        return queryset


class MerchandizerFilter(django_filters.FilterSet):
    employee_project = django_filters.NumberFilter(label='employee project', field_name='employee_project')
    project = django_filters.NumberFilter(label='project', field_name='employee_project__project')
    shop_name = django_filters.CharFilter(label='shop_name', field_name='shop__name', lookup_expr='icontains')

    class Meta:
        model = Merchandizer
        fields = ('id', 'project')


class PriceTrackingFilter(django_filters.FilterSet):
    date_range = django_filters.DateFromToRangeFilter(label='date', field_name='date')
    merchandizer = django_filters.NumberFilter(label='merchandizer', field_name='merchandizer_product__merchandizer')
    client = django_filters.NumberFilter(label='client', field_name='setting__client')
    product = django_filters.NumberFilter(label='product', field_name='merchandizer_product')

    class Meta:
        model = PriceTracking
        fields = ('id', 'date_range', 'merchandizer_product', 'merchandizer', 'type', 'product')
