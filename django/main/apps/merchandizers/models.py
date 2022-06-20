from django.db import models
from django.db.models import UniqueConstraint, Q
from model_controller.models import AbstractSoftDelete, AbstractSoftDeletionModelController
from mptt.models import MPTTModel, TreeForeignKey

from main.apps.common.constants import NULL_AND_BLANK
from main.apps.merchandizers.choices import MerchandizerSettingType, SettingType, PriceTrackingType, \
    DetailType


class MerchandizerSetting(AbstractSoftDelete, MPTTModel):
    client = models.ForeignKey(
        to='managements.Client',
        null=True, blank=True,
        on_delete=models.SET_NULL,
        related_name='merchandizer_settings'
    )
    parent = TreeForeignKey('self', on_delete=models.CASCADE, null=True, blank=True, related_name='children')
    type = models.CharField(choices=SettingType.choices, max_length=7, help_text='type of setting shop or product')
    level_name = models.CharField(choices=MerchandizerSettingType.choices, max_length=12)
    name = models.CharField(max_length=255)

    class Meta:
        constraints = [
            UniqueConstraint(
                fields=['name', 'type', 'level_name', 'client'],
                condition=Q(alive=True),
                name='unique-name-type-setting-level-client'
            )
        ]

    def __str__(self):
        return f'setting {self.name} <{self.id}>'

    @property
    def shop_total(self) -> int:
        return self.shops.count()

    @property
    def product_total(self) -> int:
        return self.products.count()


class MerchandizerQuestion(AbstractSoftDelete):
    client = models.ForeignKey(
        to='managements.Client',
        null=True, blank=True,
        on_delete=models.SET_NULL,
        related_name='merchandizer_questions'
    )
    type = models.CharField(choices=DetailType.choices, max_length=7,
                            help_text='type of detail question shop or product')
    name = models.CharField(max_length=255, null=False, blank=False)
    active = models.BooleanField(default=True)

    def __str__(self):
        return f'client <{self.client}> : {self.name}'


class Shop(AbstractSoftDeletionModelController):
    setting = models.ForeignKey(
        to='merchandizers.MerchandizerSetting',
        null=True, blank=True,
        on_delete=models.SET_NULL,
        limit_choices_to={
            'type': SettingType.SHOP
        },
        related_name='shops',
    )
    products = models.ManyToManyField(to='merchandizers.Product', related_name='shops', help_text='add product to shop')
    shop_id = models.CharField(**NULL_AND_BLANK, max_length=255)
    name = models.CharField(**NULL_AND_BLANK, max_length=255)
    address_1 = models.TextField(**NULL_AND_BLANK)
    address_2 = models.TextField(**NULL_AND_BLANK)
    city = models.CharField(**NULL_AND_BLANK, max_length=150)
    state = models.CharField(**NULL_AND_BLANK, max_length=150)
    country = models.CharField(**NULL_AND_BLANK, max_length=150)
    postalcode = models.CharField(**NULL_AND_BLANK, max_length=20)
    telephone = models.CharField(**NULL_AND_BLANK, max_length=15)
    mobile = models.CharField(**NULL_AND_BLANK, max_length=15)
    fax = models.CharField(**NULL_AND_BLANK, max_length=15)
    email = models.EmailField(**NULL_AND_BLANK)
    latitude = models.DecimalField(max_digits=22, decimal_places=16)
    longitude = models.DecimalField(max_digits=22, decimal_places=16)
    longitude = models.DecimalField(max_digits=22, decimal_places=16)
    open_time_start = models.TimeField(**NULL_AND_BLANK)
    open_time_end = models.TimeField(**NULL_AND_BLANK)
    active = models.BooleanField(default=True)

    def __str__(self):
        return f'{self.name} <{self.pk}>'

    @property
    def product_total(self) -> int:
        return self.products.count()

    @property
    def open_time(self) -> str:
        return f'{self.open_time_start.strftime("%H:%M")} - {self.open_time_end.strftime("%H:%M")}'


class ShopDetail(AbstractSoftDelete):
    shop = models.ForeignKey(
        to='merchandizers.Shop',
        null=True, blank=True,
        on_delete=models.SET_NULL,
        related_name='shop_details',
    )
    question = models.ForeignKey(
        to='merchandizers.MerchandizerQuestion',
        null=True, blank=True,
        on_delete=models.SET_NULL,
        limit_choices_to={
            'type': DetailType.SHOP
        },
        related_name='shop_details',
    )
    question_name = models.CharField(max_length=255, null=False, blank=False)
    answer = models.TextField(null=True, blank=True)

    class Meta:
        constraints = [
            UniqueConstraint(
                fields=['shop', 'question'],
                condition=Q(alive=True),
                name='unique-shop-question'
            )
        ]

    def __str__(self):
        return f'{self.question_name} <{self.pk}>'


class Product(AbstractSoftDeletionModelController):
    setting = models.ForeignKey(
        to='merchandizers.MerchandizerSetting',
        null=True, blank=True,
        on_delete=models.SET_NULL,
        limit_choices_to={
            'type': SettingType.PRODUCT
        },
        related_name='products'
    )
    product_id = models.CharField(**NULL_AND_BLANK, max_length=255)
    name = models.CharField(**NULL_AND_BLANK, max_length=255)
    brand_name = models.CharField(**NULL_AND_BLANK, max_length=255)
    distributor = models.CharField(**NULL_AND_BLANK, max_length=255)
    price = models.DecimalField(max_digits=16, decimal_places=2)
    ratio = models.DecimalField(max_digits=16, decimal_places=2)
    barcode_number = models.TextField(**NULL_AND_BLANK)
    active = models.BooleanField(default=True)

    def __str__(self):
        return f'{self.name} <{self.pk}>'


class ProductDetail(AbstractSoftDelete):
    product = models.ForeignKey(
        to='merchandizers.Product',
        null=True, blank=True,
        on_delete=models.SET_NULL,
        related_name='product_details',
    )
    question = models.ForeignKey(
        to='merchandizers.MerchandizerQuestion',
        null=True, blank=True,
        on_delete=models.SET_NULL,
        limit_choices_to={
            'type': DetailType.PRODUCT
        },
        related_name='product_details',
    )
    question_name = models.CharField(max_length=255, null=False, blank=False)
    answer = models.TextField(null=True, blank=True)

    class Meta:
        constraints = [
            UniqueConstraint(
                fields=['product', 'question'],
                condition=Q(alive=True),
                name='unique-product-question'
            )
        ]

    def __str__(self):
        return f'{self.question_name} <{self.pk}>'


class Merchandizer(AbstractSoftDelete):
    employee_project = models.ForeignKey(
        to='users.EmployeeProject',
        on_delete=models.SET_NULL,
        null=True,
        related_name='merchandizers'
    )
    shop = models.ForeignKey(
        to='merchandizers.Shop',
        null=True, blank=True,
        on_delete=models.SET_NULL,
        related_name='merchandizers'
    )

    class Meta:
        constraints = [
            UniqueConstraint(
                fields=['employee_project', 'shop'],
                condition=Q(alive=True),
                name='unique-employee-project-shop'
            )
        ]

    def __str__(self):
        return f'{self.employee_project}'

    @property
    def product_total(self) -> int:
        return self.merchandizer_products.count()


class MerchandizerProduct(AbstractSoftDelete):
    merchandizer = models.ForeignKey(
        to='merchandizers.Merchandizer',
        null=True, blank=True,
        on_delete=models.SET_NULL,
        related_name='merchandizer_products',
    )
    product = models.ForeignKey(
        to='merchandizers.Product',
        null=True, blank=True,
        on_delete=models.SET_NULL,
        related_name='merchandizer_products',
    )

    class Meta:
        constraints = [
            UniqueConstraint(
                fields=['merchandizer', 'product'],
                condition=Q(alive=True),
                name='unique-merchandizer-product'
            )
        ]

    def __str__(self):
        return f'{self.product} <{self.pk}>'


class PriceTracking(AbstractSoftDelete):
    merchandizer_product = models.ForeignKey(
        to='merchandizers.MerchandizerProduct',
        null=True, blank=True,
        on_delete=models.SET_NULL,
        related_name='all_price_tracking',
    )
    date = models.DateField(null=True)
    normal_price = models.DecimalField(max_digits=16, decimal_places=2)
    type = models.CharField(choices=PriceTrackingType.choices, default=PriceTrackingType.NO, max_length=23)
    start_date = models.DateField(null=True)
    end_date = models.DateField(null=True)
    promotion_price = models.DecimalField(max_digits=16, decimal_places=2, default=0,
                                          help_text='for single category product')
    buy_free = models.IntegerField(null=True, help_text='for single category product')
    buy_free_percentage = models.IntegerField(null=True, help_text='for single category product')
    buy_off = models.IntegerField(null=True, help_text='for single category product')
    buy_off_percentage = models.IntegerField(null=True, help_text='for single category product')
    promotion_name = models.CharField(**NULL_AND_BLANK, max_length=255,
                                      help_text='for each product category')
    reason = models.ForeignKey(to='merchandizers.PriceTrackingSetting', null=True, on_delete=models.SET_NULL,
                               related_name='+', help_text='for type no promotion')
    additional_note = models.TextField(**NULL_AND_BLANK)

    def __str__(self):
        return f'{self.date} <{self.pk}>'


class PriceTrackingSetting(AbstractSoftDelete):
    project = models.ForeignKey(
        to='managements.Project',
        null=True, blank=True,
        on_delete=models.SET_NULL,
        related_name='price_tracking_settings'
    )
    name = models.CharField(max_length=255, null=False, blank=False)

    def __str__(self):
        return f'reason {self.name} <{self.pk}>'
