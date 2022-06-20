# Generated by Django 3.2.5 on 2022-05-24 09:01

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('managements', '0002_initial'),
        ('activities', '0003_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='AdditionalType',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('detail', models.TextField(blank=True, null=True)),
                ('project', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='additional_types', to='managements.project')),
            ],
        ),
        migrations.AddField(
            model_name='activity',
            name='additional_type',
            field=models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='activities', to='activities.additionaltype'),
        ),
    ]
