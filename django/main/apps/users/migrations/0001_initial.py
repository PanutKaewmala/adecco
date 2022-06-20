# Generated by Django 3.2.5 on 2022-05-22 16:46

from django.conf import settings
import django.contrib.auth.models
import django.contrib.auth.validators
from django.db import migrations, models
import django.db.models.deletion
import django.utils.timezone
import main.apps.common.minio


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('managements', '0001_initial'),
        ('auth', '0012_alter_user_first_name_max_length'),
    ]

    operations = [
        migrations.CreateModel(
            name='User',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('password', models.CharField(max_length=128, verbose_name='password')),
                ('last_login', models.DateTimeField(blank=True, null=True, verbose_name='last login')),
                ('is_superuser', models.BooleanField(default=False, help_text='Designates that this user has all permissions without explicitly assigning them.', verbose_name='superuser status')),
                ('username', models.CharField(error_messages={'unique': 'A user with that username already exists.'}, help_text='Required. 150 characters or fewer. Letters, digits and @/./+/-/_ only.', max_length=150, unique=True, validators=[django.contrib.auth.validators.UnicodeUsernameValidator()], verbose_name='username')),
                ('first_name', models.CharField(blank=True, max_length=150, verbose_name='first name')),
                ('last_name', models.CharField(blank=True, max_length=150, verbose_name='last name')),
                ('email', models.EmailField(blank=True, max_length=254, verbose_name='email address')),
                ('is_staff', models.BooleanField(default=False, help_text='Designates whether the user can log into this admin site.', verbose_name='staff status')),
                ('is_active', models.BooleanField(default=True, help_text='Designates whether this user should be treated as active. Unselect this instead of deleting accounts.', verbose_name='active')),
                ('date_joined', models.DateTimeField(default=django.utils.timezone.now, verbose_name='date joined')),
                ('role', models.CharField(choices=[('super_admin', 'Super Admin'), ('project_manager', 'Project Manager'), ('project_assignee', 'Project Assignee'), ('associate', 'Associate')], max_length=20, null=True)),
                ('default_password_changed', models.BooleanField(default=False)),
                ('pincode', models.TextField(blank=True, null=True)),
                ('phone_number', models.CharField(blank=True, max_length=15, null=True)),
                ('photo', models.ImageField(null=True, storage=main.apps.common.minio.SwitchMinioBackend(bucket_name='django-media'), upload_to='users/photos/')),
                ('groups', models.ManyToManyField(blank=True, help_text='The groups this user belongs to. A user will get all permissions granted to each of their groups.', related_name='user_set', related_query_name='user', to='auth.Group', verbose_name='groups')),
                ('user_permissions', models.ManyToManyField(blank=True, help_text='Specific permissions for this user.', related_name='user_set', related_query_name='user', to='auth.Permission', verbose_name='user permissions')),
            ],
            options={
                'verbose_name': 'user',
                'verbose_name_plural': 'users',
                'abstract': False,
            },
            managers=[
                ('objects', django.contrib.auth.models.UserManager()),
            ],
        ),
        migrations.CreateModel(
            name='Employee',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('middle_name', models.CharField(blank=True, max_length=150, null=True)),
                ('nick_name', models.CharField(blank=True, max_length=150, null=True)),
                ('position', models.CharField(blank=True, max_length=255, null=True)),
                ('hrms_id', models.CharField(blank=True, max_length=255, null=True)),
                ('client_employee_id', models.CharField(blank=True, max_length=255, null=True)),
                ('address', models.TextField(blank=True, null=True)),
                ('reference', models.TextField(blank=True, null=True)),
                ('reference_contact', models.TextField(blank=True, null=True)),
                ('additional_note', models.TextField(blank=True, null=True)),
            ],
        ),
        migrations.CreateModel(
            name='Manager',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('projects', models.ManyToManyField(related_name='managers', to='managements.Project')),
                ('user', models.OneToOneField(limit_choices_to={'role__in': ['project_manager', 'project_assignee', 'associate']}, on_delete=django.db.models.deletion.CASCADE, related_name='manager', to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='EmployeeProject',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('start_date', models.DateField(auto_now=True)),
                ('resign_date', models.DateField(null=True)),
                ('osa_oss', models.BooleanField(default=False, help_text='Allow feature')),
                ('sku', models.BooleanField(default=False, help_text='Allow feature')),
                ('price_tracking', models.BooleanField(default=False, help_text='Allow feature')),
                ('sales_report', models.BooleanField(default=False, help_text='Allow feature')),
                ('employee', models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='employee_projects', to='users.employee')),
                ('project', models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='employee_projects', to='managements.project')),
                ('supervisor', models.ForeignKey(limit_choices_to={'role': 'associate'}, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='supervisor_employees', to=settings.AUTH_USER_MODEL)),
                ('workplaces', models.ManyToManyField(related_name='employee_projects', to='managements.WorkPlace')),
            ],
        ),
        migrations.AddField(
            model_name='employee',
            name='projects',
            field=models.ManyToManyField(related_name='employee', through='users.EmployeeProject', to='managements.Project'),
        ),
        migrations.AddField(
            model_name='employee',
            name='user',
            field=models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, related_name='employee', to=settings.AUTH_USER_MODEL),
        ),
        migrations.AddConstraint(
            model_name='employeeproject',
            constraint=models.UniqueConstraint(fields=('employee', 'project'), name='unique-employee-project'),
        ),
    ]