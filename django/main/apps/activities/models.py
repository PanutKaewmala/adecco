from django.db import models
from django.db.models import When, Value, Case
from model_controller.models import AbstractTimeStampMarker, AbstractSoftDelete

from main.apps.activities.choices import ActivityType, LeaveStatus, ActivityExtraType, OTRequestStatus, OTRequestType
from main.apps.common.minio import SwitchMinioBackend
from main.apps.common.utils import is_inside_radius
from main.apps.managements.models import Project
from main.apps.users.models import EmployeeProject


class CheckInOutPair(models.Model):
    check_in = models.OneToOneField(
        to='activities.Activity',
        on_delete=models.SET_NULL,
        null=True,
        related_name='check_in_pair',
        limit_choices_to={
            'type': ActivityType.CHECK_IN
        },
        help_text='pair check in'
    )
    check_out = models.OneToOneField(
        to='activities.Activity',
        on_delete=models.SET_NULL,
        null=True,
        related_name='check_out_pair',
        limit_choices_to={
            'type': ActivityType.CHECK_OUT
        },
        help_text='pair check out'
    )


class AdditionalType(models.Model):
    detail = models.TextField(null=True, blank=True)
    project = models.ForeignKey(Project, on_delete=models.CASCADE, related_name='additional_types')

    def __str__(self):
        return f'{self.detail}'


class Activity(AbstractTimeStampMarker):
    user = models.ForeignKey(
        to='users.User',
        related_name='activities',
        on_delete=models.CASCADE,
    )
    project = models.ForeignKey(Project, on_delete=models.SET_NULL, null=True, related_name='+')
    type = models.CharField(choices=ActivityType.choices, max_length=20)
    extra_type = models.CharField(choices=ActivityExtraType.choices, max_length=20, null=True)
    date_time = models.DateTimeField()
    location_name = models.TextField(null=True, blank=True)
    location_address = models.TextField(null=True, blank=True)
    latitude = models.DecimalField(max_digits=22, decimal_places=16)
    longitude = models.DecimalField(max_digits=22, decimal_places=16)
    picture = models.ImageField(upload_to='activities/images/%Y-%m-%d/',
                                storage=SwitchMinioBackend(bucket_name='django-media'))
    reason_for_adjust_time = models.TextField(null=True, blank=True)
    reason_for_adjust_status = models.TextField(null=True, blank=True)
    remark = models.TextField(null=True, blank=True)
    workplace = models.ForeignKey(to='managements.WorkPlace', on_delete=models.SET_NULL, related_name='+', null=True)
    working_hour = models.ForeignKey(
        to='managements.WorkingHour',
        on_delete=models.SET_NULL,
        null=True,
        related_name='+'
    )
    in_radius = models.BooleanField(default=False)
    additional_type = models.ForeignKey(
        AdditionalType,
        on_delete=models.SET_NULL,
        related_name='activities',
        null=True)

    def __str__(self):
        return f'{self.user} {self.type} {self.date_time}'

    def save(self, **kwargs):
        if self.type in [ActivityType.CHECK_IN, ActivityType.CHECK_OUT]:
            self.location_name = self.workplace.name
            self.in_radius = is_inside_radius(
                longitude1=self.longitude,
                latitude1=self.latitude,
                longitude2=self.workplace.longitude,
                latitude2=self.workplace.latitude,
                radius_meter=self.workplace.radius_meter
            )
        super().save(**kwargs)

    @property
    def coordinate(self):
        return 0

    @property
    def same_check_in_out_pair(self):
        if self.type not in [ActivityType.CHECK_IN, ActivityType.CHECK_OUT]:
            return None

        check_in_queryset = []
        check_in = self.check_in if self.type == ActivityType.CHECK_OUT else self
        if check_in:
            check_in_queryset = Activity.objects.filter(user=check_in.user, project=check_in.project,
                                                        type=ActivityType.CHECK_IN,
                                                        date_time__date=check_in.date_time.date()).order_by('id')
        check_out_queryset = [
            check_in.check_in_pair.check_out
            for check_in in check_in_queryset
            if check_in.check_in_pair.check_out
            if hasattr(check_in, 'check_in_pair')
        ]
        return [*check_in_queryset, *check_out_queryset]

    @property
    def check_in(self):
        return self.check_out_pair.check_in if hasattr(self, 'check_out_pair') else None

    @property
    def check_out(self):
        return self.check_in_pair.check_out if hasattr(self, 'check_in_pair') else None

    @property
    def employee_project(self):
        employee = self.user.employee
        if employee and self.project:
            try:
                return EmployeeProject.objects.get(project=self.project, employee=employee)
            except EmployeeProject.DoesNotExist:
                pass
        return None


class Place(models.Model):
    place_name = models.CharField(max_length=200, null=True, blank=True)
    latitude = models.DecimalField(max_digits=22, decimal_places=16, null=True, blank=True)
    longitude = models.DecimalField(max_digits=22, decimal_places=16, null=True, blank=True)

    def __str__(self):
        return f'{self.place_name}'


class DailyTask(models.Model):
    date = models.DateField()
    task_name = models.CharField(max_length=200)
    start_time = models.TimeField(null=True, blank=True)
    stop_time = models.TimeField(null=True, blank=True)
    all_day = models.BooleanField(default=False)
    place = models.ForeignKey(to=Place, on_delete=models.SET_NULL, null=True, related_name='daily_tasks')

    def save(self, **kwargs):
        if self.all_day:
            self.start_time = None
            self.stop_time = None
        return super().save(**kwargs)

    def __str__(self):
        return f'{self.task_name}'


class LeaveTypeSetting(models.Model):
    name = models.CharField(max_length=100)
    apply_before = models.PositiveSmallIntegerField(default=30, null=True)
    apply_after = models.PositiveSmallIntegerField(default=30, null=True)
    default = models.BooleanField(default=False)
    client = models.ForeignKey(
        to='managements.Client',
        related_name='leave_type_settings',
        on_delete=models.SET_NULL,
        null=True
    )
    project = models.ForeignKey(
        to='managements.Project',
        related_name='leave_type_settings',
        on_delete=models.SET_NULL,
        null=True
    )

    def __str__(self):
        return f'{self.name}'


class LeaveType(models.Model):
    name = models.CharField(max_length=50)
    earn_income = models.BooleanField(default=False)
    leave_type_setting = models.ForeignKey(to='activities.LeaveTypeSetting',
                                           related_name='leave_types', on_delete=models.CASCADE)
    client = models.ForeignKey('managements.Client',
                               related_name='leave_types',
                               on_delete=models.SET_NULL, null=True)
    project = models.ForeignKey('managements.Project',
                                related_name='leave_types',
                                on_delete=models.SET_NULL, null=True)

    def __str__(self):
        return f'{self.name}'


class LeaveQuota(models.Model):
    user = models.ForeignKey(to='users.User', related_name='leave_quotas', on_delete=models.CASCADE)
    type = models.ForeignKey(to='LeaveType', related_name='leave_quotas', on_delete=models.SET_NULL, null=True)
    total = models.DecimalField(max_digits=4, decimal_places=2, default=0)
    used = models.DecimalField(max_digits=4, decimal_places=2, default=0)
    project = models.ForeignKey(to=Project, related_name='leave_quotas', on_delete=models.CASCADE, null=True)

    class Meta:
        constraints = [
            models.UniqueConstraint(
                fields=['type', 'project', 'user'],
                name='unique-leave_quota'
            )
        ]

    @property
    def remained(self):
        return self.total - self.used

    def __str__(self):
        return f'{self.type} - {self.user} (Project: {self.project})'


class LeaveRequest(AbstractTimeStampMarker, AbstractSoftDelete):
    user = models.ForeignKey(to='users.User', related_name='leave_requests', on_delete=models.CASCADE)
    type = models.ForeignKey(to=LeaveType, related_name='leave_requests', on_delete=models.SET_NULL, null=True)
    start_date = models.DateField()
    end_date = models.DateField()
    start_time = models.TimeField(null=True, blank=True)
    end_time = models.TimeField(null=True, blank=True)
    all_day = models.BooleanField(default=False)
    title = models.CharField(max_length=100, null=True, blank=True)
    description = models.TextField(null=True, blank=True)
    status = models.CharField(choices=LeaveStatus.choices, max_length=20, default=LeaveStatus.PENDING)
    note = models.TextField(null=True, blank=True)
    reason = models.TextField(null=True, blank=True)
    project = models.ForeignKey(to=Project, related_name='leave_requests', on_delete=models.SET_NULL, null=True)

    def __str__(self):
        return f'{self.type}: {self.user} => {self.start_date} to {self.end_date}'

    @classmethod
    def sort_by_status(cls, queryset=None):
        """
        Takes a queryset, returns an ordered list; ordered by status.
        """
        if queryset is None:
            queryset = cls.objects.all()

        whens = [
            When(status=Value(value), then=i)
            for i, (value, label) in enumerate(LeaveStatus.choices)
        ]

        queryset = (
            queryset.annotate(_order=Case(*whens, output_field=models.IntegerField())).order_by('_order')
        )

        return queryset


class LeaveRequestPartialApprove(models.Model):
    leave_request = models.ForeignKey(
        to='activities.LeaveRequest',
        on_delete=models.CASCADE,
        related_name='leave_request_partial_approves'
    )
    date = models.DateField()
    approve = models.BooleanField(default=False)

    def __str__(self):
        return f'{self.date}: The result of approval = {self.approve}'


class UploadAttachment(models.Model):
    name = models.CharField(max_length=200)
    file = models.FileField(upload_to='activities/leave-files/%Y-%m-%d/')
    leave_request = models.ForeignKey(to=LeaveRequest, related_name='upload_attachments',
                                      on_delete=models.SET_NULL, null=True)

    def save(self, **kwargs):
        if self.file is not None:
            self.name = self.file.name
        return super().save(**kwargs)


class PinPoint(models.Model):
    activity = models.OneToOneField(to='activities.Activity', on_delete=models.CASCADE, related_name='pin_point')
    type = models.ForeignKey(to='managements.PinPointType', on_delete=models.CASCADE, related_name='+')

    @property
    def project(self) -> Project:
        return self.activity.project

    def __str__(self):
        return f'{self.type} - {self.activity}'


class PinPointAnswer(models.Model):
    pin_point = models.ForeignKey('activities.PinPoint', on_delete=models.CASCADE, related_name='answers')
    question = models.ForeignKey('managements.PinPointQuestion', on_delete=models.SET_NULL, related_name='+', null=True)
    question_name = models.TextField(null=True, blank=True)
    answer = models.TextField(null=True, blank=True)


class OTRequest(AbstractTimeStampMarker, AbstractSoftDelete):
    user = models.ForeignKey(to='users.User', related_name='ot_requests', on_delete=models.CASCADE)
    project = models.ForeignKey(to=Project, related_name='ot_requests', on_delete=models.SET_NULL, null=True)
    workplace = models.ForeignKey(to='managements.WorkPlace', on_delete=models.SET_NULL, related_name='+', null=True)
    start_date = models.DateField()
    end_date = models.DateField()
    start_time = models.TimeField()
    end_time = models.TimeField()
    multi_day = models.BooleanField(default=False)
    title = models.CharField(max_length=100, null=True, blank=True)
    description = models.TextField(null=True, blank=True)
    status = models.CharField(choices=OTRequestStatus.choices, max_length=15, default=OTRequestStatus.PENDING)
    type = models.CharField(choices=OTRequestType.choices, max_length=12, default=OTRequestType.USER_REQUEST)
    note = models.TextField(null=True, blank=True, help_text='note for approve')
    reason = models.TextField(null=True, blank=True, help_text='Reason for reject')
    partial_start_time = models.TimeField(null=True, help_text='For partial approve')
    partial_end_time = models.TimeField(null=True, help_text='For partial approve')

    def __str__(self):
        return f'{self.user} <{self.pk}>'

    @property
    def ot_total(self):
        if self.status == OTRequestStatus.PARTIAL_APPROVE:
            return self.partial_end_time.hour - self.partial_start_time.hour
        return self.end_time.hour - self.start_time.hour

    @property
    def employee_project(self):
        if hasattr(self.user, 'employee'):
            employee = self.user.employee
            if employee and self.project:
                try:
                    return EmployeeProject.objects.get(project=self.project, employee=employee)
                except EmployeeProject.DoesNotExist:
                    pass
        return None
