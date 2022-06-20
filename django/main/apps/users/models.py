import datetime

from django.contrib.auth.models import AbstractUser
from django.db import models
from django.db.models import F, Sum, Case, When, QuerySet

from main.apps.activities.choices import OTRequestStatus
from main.apps.common.constants import NULL_AND_BLANK
from main.apps.common.minio import SwitchMinioBackend
from main.apps.common.utils import get_total_days, multiple_time_by_total_days, convert_time_delta_to_minutes, \
    total_minutes_to_hour_minute
from main.apps.managements.models import Project, Client
from main.apps.users.choices import Role


class User(AbstractUser):
    role = models.CharField(choices=Role.choices, max_length=20, null=True)
    default_password_changed = models.BooleanField(default=False)
    pincode = models.TextField(null=True, blank=True)
    phone_number = models.CharField(max_length=15, blank=True, null=True)
    photo = models.ImageField(upload_to='users/photos/', null=True,
                              storage=SwitchMinioBackend(bucket_name='django-media'))

    @property
    def full_name(self) -> str:
        return f'{self.first_name} {self.last_name}'.strip()


class Employee(models.Model):
    """
        Employee model for user role associate
    """
    user = models.OneToOneField(
        User,
        on_delete=models.CASCADE,
        related_name='employee'
    )
    middle_name = models.CharField(max_length=150, **NULL_AND_BLANK)
    nick_name = models.CharField(max_length=150, **NULL_AND_BLANK)
    position = models.CharField(max_length=255, **NULL_AND_BLANK)
    hrms_id = models.CharField(max_length=255, **NULL_AND_BLANK)
    client_employee_id = models.CharField(max_length=255, **NULL_AND_BLANK)
    address = models.TextField(**NULL_AND_BLANK)

    reference = models.TextField(**NULL_AND_BLANK)
    reference_contact = models.TextField(**NULL_AND_BLANK)
    additional_note = models.TextField(**NULL_AND_BLANK)
    projects = models.ManyToManyField(to='managements.Project', related_name='employee',
                                      through='users.EmployeeProject')

    def __str__(self):
        return f'Employee {self.user} <{self.id}>'

    @property
    def clients(self) -> QuerySet[Project]:
        return Client.objects.filter(projects__employee_projects__employee=self)


class EmployeeProject(models.Model):
    employee = models.ForeignKey(Employee, on_delete=models.SET_NULL, null=True, related_name='employee_projects')
    supervisor = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        null=True,
        related_name='supervisor_employees',
        limit_choices_to={
            'role': Role.ASSOCIATE
        }
    )
    project = models.ForeignKey(
        to='managements.Project',
        on_delete=models.SET_NULL, null=True,
        related_name='employee_projects'
    )
    workplaces = models.ManyToManyField(to='managements.WorkPlace', related_name='employee_projects')
    start_date = models.DateField(auto_now=True)
    resign_date = models.DateField(null=True)
    osa_oss = models.BooleanField(default=False, help_text='Allow feature')
    sku = models.BooleanField(default=False, help_text='Allow feature')
    price_tracking = models.BooleanField(default=False, help_text='Allow feature')
    sales_report = models.BooleanField(default=False, help_text='Allow feature')

    class Meta:
        constraints = [
            models.UniqueConstraint(
                fields=['employee', 'project'],
                name='unique-employee-project'
            )
        ]

    def __str__(self):
        return f'Employee project {self.project} : {self.employee}'

    @property
    def ot_quota_used(self):
        ot_request_queryset = self.employee.user.ot_requests \
            .filter(status__in=[OTRequestStatus.APPROVE, OTRequestStatus.PARTIAL_APPROVE], project=self.project)

        ot_request_partial = ot_request_queryset.filter(multi_day=True)
        total_time_partial = datetime.timedelta()
        for ot_request in ot_request_partial:
            total_day = get_total_days(ot_request.start_date, ot_request.end_date) + 1
            if ot_request.status == OTRequestStatus.PARTIAL_APPROVE:
                total_start_time = multiple_time_by_total_days(ot_request.partial_start_time, total_day)
                total_end_time = multiple_time_by_total_days(ot_request.partial_end_time, total_day)
            else:
                total_start_time = multiple_time_by_total_days(ot_request.start_time, total_day)
                total_end_time = multiple_time_by_total_days(ot_request.end_time, total_day)
            total_time_partial += total_end_time - total_start_time

        total_single_day_used = ot_request_queryset.filter(multi_day=False) \
            .annotate(
            ot_used=Case(
                When(status=OTRequestStatus.PARTIAL_APPROVE, then=F('partial_end_time') - F('partial_start_time')),
                default=F('end_time') - F('start_time')
            )
        ).aggregate(total=Sum('ot_used'))
        total = total_single_day_used['total'] + total_time_partial \
            if total_single_day_used['total'] \
            else total_time_partial

        total_minute = convert_time_delta_to_minutes(total)
        total = total_minutes_to_hour_minute(total_minute)

        return total

    @property
    def merchandizer_shops(self):
        return list(self.merchandizers.all().values_list('shop__name', flat=True))


class Manager(models.Model):
    """
        ManagerProject model for user role Project Manager, Project Assignee, Supervisor
    """
    user = models.OneToOneField(
        User,
        on_delete=models.CASCADE,
        related_name='manager',
        limit_choices_to={
            'role__in': [Role.PROJECT_MANAGER, Role.PROJECT_ASSIGNEE, Role.ASSOCIATE]
        }
    )
    projects = models.ManyToManyField(to='managements.Project', related_name='managers')
