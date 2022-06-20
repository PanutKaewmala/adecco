from django.db import models
from django.db.models import Q

from main.apps.common.constants import NULL_AND_BLANK
from main.apps.managements.choices import OTRuleDayType, OTRuleTimeType, BusinessCalendarType, DayOfWeekType
from main.apps.managements.constants import FEATURE_SETTING
from main.apps.users.choices import Role


class Client(models.Model):
    name = models.TextField()
    name_th = models.TextField(**NULL_AND_BLANK)
    branch = models.TextField()
    contact_person = models.TextField()
    contact_person_email = models.EmailField(**NULL_AND_BLANK)
    contact_number = models.TextField(**NULL_AND_BLANK)
    project_manager = models.ForeignKey(
        to='users.User',
        null=True,
        related_name='project_manager_clients',
        on_delete=models.SET_NULL,
    )
    url = models.TextField()
    ot_quota = models.PositiveSmallIntegerField(null=True, help_text='OT quota (in minutes)')
    lead_time_in_before = models.PositiveSmallIntegerField(null=True, default=30,
                                                           help_text='Lead time in before (in minutes)')
    lead_time_in_after = models.PositiveSmallIntegerField(null=True, default=30,
                                                          help_text='Lead time in after (in minutes)')
    lead_time_out_before = models.PositiveSmallIntegerField(null=True, default=30,
                                                            help_text='Lead time out before (in minutes)')
    lead_time_out_after = models.PositiveSmallIntegerField(null=True, default=30,
                                                           help_text='Lead time out after (in minutes)')
    business_calendar_type = models.CharField(max_length=15, choices=BusinessCalendarType.choices,
                                              default=BusinessCalendarType.DEFAULT_HOLIDAY)

    def __str__(self):
        return f'{self.name}'


class Project(models.Model):
    name = models.TextField()
    description = models.TextField(null=True, blank=True)
    start_date = models.DateField(null=True)
    end_date = models.DateField(null=True)
    country = models.TextField()
    city = models.TextField()
    project_manager = models.ForeignKey(
        to='users.User',
        null=True,
        related_name='projects',
        on_delete=models.SET_NULL,
        limit_choices_to={
            'role__in': [Role.PROJECT_MANAGER, Role.SUPER_ADMIN]
        }
    )
    project_assignee = models.ForeignKey(
        to='users.User',
        null=True,
        related_name='project_assignee_clients',
        on_delete=models.SET_NULL,
    )
    client = models.ForeignKey(
        Client,
        null=True,
        on_delete=models.SET_NULL,
        related_name='projects'
    )
    ot_quota = models.PositiveSmallIntegerField(null=True, help_text='OT quota (in minutes)')
    lead_time_in_before = models.PositiveSmallIntegerField(null=True, default=30,
                                                           help_text='Lead time in before (in minutes)')
    lead_time_in_after = models.PositiveSmallIntegerField(null=True, default=30,
                                                          help_text='Lead time in after (in minutes)')
    lead_time_out_before = models.PositiveSmallIntegerField(null=True, default=30,
                                                            help_text='Lead time out before (in minutes)')
    lead_time_out_after = models.PositiveSmallIntegerField(null=True, default=30,
                                                           help_text='Lead time out after (in minutes)')
    business_calendar_type = models.CharField(max_length=15, choices=BusinessCalendarType.choices,
                                              default=BusinessCalendarType.DEFAULT_HOLIDAY)

    # Feature Setting
    feature_check_in_check_out = models.CharField(**FEATURE_SETTING)
    feature_roster_plan = models.CharField(**FEATURE_SETTING)
    feature_leave_request = models.CharField(**FEATURE_SETTING)
    feature_ot_request = models.CharField(**FEATURE_SETTING)
    feature_todo = models.CharField(**FEATURE_SETTING)
    feature_track_route_pin_point = models.CharField(**FEATURE_SETTING)
    feature_osa_oss = models.CharField(**FEATURE_SETTING)
    feature_price_tracking = models.CharField(**FEATURE_SETTING)
    feature_sku = models.CharField(**FEATURE_SETTING)
    feature_sales_report = models.CharField(**FEATURE_SETTING)
    feature_event_stock = models.CharField(**FEATURE_SETTING)
    feature_survey = models.CharField(**FEATURE_SETTING)

    def __str__(self):
        return f'{self.name}'

    @property
    def ot_quota_time(self):
        minute = self.ot_quota % 60
        time = [str(self.ot_quota // 60), '{:02d}'.format(minute)]  # pylint: disable=consider-using-f-string
        return '.'.join(time)


class WorkPlace(models.Model):
    name = models.TextField()
    address = models.TextField()
    wifi = models.TextField(blank=True, null=True)
    bluetooth = models.TextField(blank=True, null=True)
    qr_code = models.TextField(blank=True, null=True)
    addition_note = models.TextField(blank=True, null=True)
    latitude = models.DecimalField(max_digits=22, decimal_places=16)
    longitude = models.DecimalField(max_digits=22, decimal_places=16)
    project = models.ForeignKey(Project, on_delete=models.SET_NULL, null=True, related_name='workplaces')
    radius_meter = models.PositiveIntegerField(default=100)

    def __str__(self):
        return f'{self.name}'


class WorkingHour(models.Model):
    client = models.ForeignKey(to=Client, on_delete=models.SET_NULL, null=True, related_name='working_hours')
    project = models.ForeignKey(to=Project, on_delete=models.SET_NULL, null=True, related_name='working_hours')
    name = models.CharField(max_length=255, null=True, blank=True)
    sunday = models.BooleanField(default=False)
    monday = models.BooleanField(default=False)
    tuesday = models.BooleanField(default=False)
    wednesday = models.BooleanField(default=False)
    thursday = models.BooleanField(default=False)
    friday = models.BooleanField(default=False)
    saturday = models.BooleanField(default=False)
    sunday_start_time = models.TimeField(null=True)
    sunday_end_time = models.TimeField(null=True)
    monday_start_time = models.TimeField(null=True)
    monday_end_time = models.TimeField(null=True)
    tuesday_start_time = models.TimeField(null=True)
    tuesday_end_time = models.TimeField(null=True)
    wednesday_start_time = models.TimeField(null=True)
    wednesday_end_time = models.TimeField(null=True)
    thursday_start_time = models.TimeField(null=True)
    thursday_end_time = models.TimeField(null=True)
    friday_start_time = models.TimeField(null=True)
    friday_end_time = models.TimeField(null=True)
    saturday_start_time = models.TimeField(null=True)
    saturday_end_time = models.TimeField(null=True)

    def __str__(self):
        return f'{self.name} <{self.pk}>'

    @property
    def lead_time_in_before(self):
        return self.client.lead_time_in_before if self.client else self.project.lead_time_in_before

    @property
    def lead_time_in_after(self):
        return self.client.lead_time_in_after if self.client else self.project.lead_time_in_after

    @property
    def lead_time_out_before(self):
        return self.client.lead_time_out_before if self.client else self.project.lead_time_out_before

    @property
    def lead_time_out_after(self):
        return self.client.lead_time_out_after if self.client else self.project.lead_time_out_after


class AdditionalAllowance(models.Model):
    working_hour = models.ForeignKey(to='managements.WorkingHour', on_delete=models.CASCADE,
                                     related_name='additional_allowances')
    type = models.CharField(max_length=255)
    pay_code = models.CharField(max_length=255)
    day_of_week = models.CharField(choices=DayOfWeekType.choices, max_length=11)
    description = models.TextField(**NULL_AND_BLANK)


class PinPointType(models.Model):
    project = models.ForeignKey('managements.Project', on_delete=models.CASCADE, related_name='pin_point_types')
    name = models.CharField(max_length=255, null=False, blank=False)
    detail = models.TextField(blank=True, null=True)
    employee_projects = models.ManyToManyField(
        to='users.EmployeeProject',
        related_name='pin_point_types',
    )

    @property
    def total_assignee(self) -> int:
        return self.employee_projects.count()

    def __str__(self):
        return f'{self.name}'


class PinPointQuestion(models.Model):
    pin_point_type = models.ForeignKey('managements.PinPointType', on_delete=models.CASCADE, related_name='questions')
    name = models.CharField(max_length=255, null=False, blank=False)
    require = models.BooleanField(default=True)
    hide = models.BooleanField(default=False)
    template = models.BooleanField(default=False)

    def __str__(self):
        return f'{self.name}'


class OTRule(models.Model):
    client = models.ForeignKey(to=Client, on_delete=models.SET_NULL, null=True, related_name='ot_rules')
    project = models.ForeignKey(to=Project, on_delete=models.SET_NULL, null=True, related_name='ot_rules')
    type = models.TextField()
    pay_code = models.DecimalField(max_digits=4, decimal_places=2)
    day = models.CharField(max_length=11, choices=OTRuleDayType.choices)
    time = models.CharField(max_length=16, choices=OTRuleTimeType.choices)
    description = models.TextField(blank=True, null=True)

    class Meta:
        constraints = [
            models.UniqueConstraint(
                fields=['client', 'day', 'time'],
                name='unique-client-day-time'
            ),
            models.UniqueConstraint(
                fields=['project', 'day', 'time'],
                name='unique-project-day-time'
            )
        ]

    @property
    def pay_code_str(self):
        return f'OT {self.pay_code:.2f}'


class BusinessCalendar(models.Model):
    client = models.ForeignKey(to=Client, on_delete=models.SET_NULL, null=True, related_name='business_calendars')
    project = models.ForeignKey(to=Project, on_delete=models.SET_NULL, null=True, related_name='business_calendars')
    type = models.CharField(max_length=15, choices=BusinessCalendarType.choices)
    date = models.DateField()
    name = models.TextField()

    class Meta:
        constraints = [
            models.UniqueConstraint(
                fields=['client', 'type', 'date'],
                condition=Q(client__isnull=False),
                name='unique-client-type-date'
            )
        ]
