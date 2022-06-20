from django.db import models


class OTRuleDayType(models.TextChoices):
    WORKING_DAY = 'working_day', 'Working day'
    DAY_OFF = 'day_off', 'Day off'


class OTRuleTimeType(models.TextChoices):
    NORMAL_WORK_TIME = 'normal_work_hour', 'Normal work hour'
    OVER_NORMAL_TIME = 'over_normal_time', 'Over normal time'


class BusinessCalendarType(models.TextChoices):
    DEFAULT_HOLIDAY = 'default_holiday', 'Default holiday'
    CUSTOM_HOLIDAY = 'custom_holiday', 'Custom holiday'


class DayOfWeekType(models.TextChoices):
    WORKING_DAY = 'working_day', 'Working day'
    DAY_OFF = 'day_off', 'Day off'


class ProjectFeatureSetting(models.TextChoices):
    DISABLE = 'disable', 'Disable'
    ADECCO_ONLY = 'adecco_only', 'Adecco only'
    ADECCO_AND_CLIENT = 'adecco_and_client', 'Adecco and client'
