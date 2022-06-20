from django.db import models


class SettingType(models.TextChoices):
    SHOP = 'shop', 'Shop'
    PRODUCT = 'product', 'Product'


class MerchandizerSettingType(models.TextChoices):
    GROUP = 'group', 'Group'
    CATEGORY = 'category', 'Category'
    SUBCATEGORY = 'subcategory', 'Subcategory'


class PriceTrackingType(models.TextChoices):
    SINGLE_CATEGORY_PRODUCT = 'single_category_product', 'Single category product'
    EACH_PRODUCT_CATEGORY = 'each_product_category', 'Each product category'
    NO = 'no', 'No'


class PriceTrackingReasonType(models.TextChoices):
    PRODUCT_NOT_FOUND = 'product_not_found', 'Product not found'
    OUT_OF_STOCK = 'out_of_stock', 'Out of stock'
    NO_PRICE_TAG = 'no_price_tag', 'No price tag'
    NO_POSTER = 'no_poster', 'No poster'
    NO_PRICE_STICKER = 'no_price_sticker', 'No price stocker'


class DetailType(models.TextChoices):
    SHOP = 'shop', 'Shop'
    PRODUCT = 'product', 'Product'
