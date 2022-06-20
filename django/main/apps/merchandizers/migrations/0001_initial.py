# Generated by Django 3.2.5 on 2022-05-22 16:46

from django.db import migrations, models
import django.db.models.manager
import model_controller.fields


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Merchandizer',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('alive', model_controller.fields.LiveField(db_index=True, default=True, null=True)),
            ],
        ),
        migrations.CreateModel(
            name='MerchandizerProduct',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('alive', model_controller.fields.LiveField(db_index=True, default=True, null=True)),
            ],
        ),
        migrations.CreateModel(
            name='MerchandizerSetting',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('alive', model_controller.fields.LiveField(db_index=True, default=True, null=True)),
                ('type', models.CharField(choices=[('shop', 'Shop'), ('product', 'Product')], help_text='type of setting shop or product', max_length=7)),
                ('level_name', models.CharField(choices=[('group', 'Group'), ('category', 'Category'), ('subcategory', 'Subcategory')], max_length=12)),
                ('name', models.CharField(max_length=255)),
                ('lft', models.PositiveIntegerField(editable=False)),
                ('rght', models.PositiveIntegerField(editable=False)),
                ('tree_id', models.PositiveIntegerField(db_index=True, editable=False)),
                ('level', models.PositiveIntegerField(editable=False)),
            ],
            managers=[
                ('_tree_manager', django.db.models.manager.Manager()),
            ],
        ),
        migrations.CreateModel(
            name='PriceTracking',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('alive', model_controller.fields.LiveField(db_index=True, default=True, null=True)),
                ('date', models.DateField(null=True)),
                ('normal_price', models.DecimalField(decimal_places=2, max_digits=16)),
                ('type', models.CharField(choices=[('single_category_product', 'Single category product'), ('each_product_category', 'Each product category'), ('no', 'No')], default='no', max_length=23)),
                ('start_date', models.DateField(null=True)),
                ('end_date', models.DateField(null=True)),
                ('promotion_price', models.DecimalField(decimal_places=2, default=0, help_text='for single category product', max_digits=16)),
                ('buy_free', models.IntegerField(help_text='for single category product', null=True)),
                ('buy_free_percentage', models.IntegerField(help_text='for single category product', null=True)),
                ('buy_off', models.IntegerField(help_text='for single category product', null=True)),
                ('buy_off_percentage', models.IntegerField(help_text='for single category product', null=True)),
                ('promotion_name', models.CharField(blank=True, help_text='for each product category', max_length=255, null=True)),
                ('reason', models.CharField(choices=[('product_not_found', 'Product not found'), ('out_of_stock', 'Out of stock'), ('no_price_tag', 'No price tag'), ('no_poster', 'No poster'), ('no_price_sticker', 'No price stocker')], help_text='for type promotion no', max_length=17, null=True)),
                ('additional_note', models.TextField(blank=True, null=True)),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='Product',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('created_at', models.DateTimeField(auto_now_add=True, verbose_name='Created at')),
                ('updated_at', models.DateTimeField(auto_now=True, verbose_name='Updated at')),
                ('alive', model_controller.fields.LiveField(db_index=True, default=True, null=True)),
                ('product_id', models.CharField(blank=True, max_length=255, null=True)),
                ('name', models.CharField(blank=True, max_length=255, null=True)),
                ('brand_name', models.CharField(blank=True, max_length=255, null=True)),
                ('distributor', models.CharField(blank=True, max_length=255, null=True)),
                ('price', models.DecimalField(decimal_places=2, max_digits=16)),
                ('ratio', models.DecimalField(decimal_places=2, max_digits=16)),
                ('barcode_number', models.TextField(blank=True, null=True)),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='Shop',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('created_at', models.DateTimeField(auto_now_add=True, verbose_name='Created at')),
                ('updated_at', models.DateTimeField(auto_now=True, verbose_name='Updated at')),
                ('alive', model_controller.fields.LiveField(db_index=True, default=True, null=True)),
                ('shop_id', models.CharField(blank=True, max_length=255, null=True)),
                ('name', models.CharField(blank=True, max_length=255, null=True)),
                ('address_1', models.TextField(blank=True, null=True)),
                ('address_2', models.TextField(blank=True, null=True)),
                ('city', models.CharField(blank=True, max_length=150, null=True)),
                ('state', models.CharField(blank=True, max_length=150, null=True)),
                ('country', models.CharField(blank=True, max_length=150, null=True)),
                ('postalcode', models.CharField(blank=True, max_length=20, null=True)),
                ('telephone', models.CharField(blank=True, max_length=15, null=True)),
                ('mobile', models.CharField(blank=True, max_length=15, null=True)),
                ('fax', models.CharField(blank=True, max_length=15, null=True)),
                ('email', models.EmailField(blank=True, max_length=254, null=True)),
                ('latitude', models.DecimalField(decimal_places=16, max_digits=22)),
                ('longitude', models.DecimalField(decimal_places=16, max_digits=22)),
                ('open_time_start', models.TimeField(blank=True, null=True)),
                ('open_time_end', models.TimeField(blank=True, null=True)),
            ],
            options={
                'abstract': False,
            },
        ),
    ]