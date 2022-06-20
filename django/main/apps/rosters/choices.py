from django.db import models


class RosterStatusType(models.TextChoices):
    PENDING = 'pending', 'Pending'
    REJECT = 'reject', 'Reject'
    APPROVE = 'approve', 'Approve'


class RosterType(models.TextChoices):
    SHIFT = 'shift', 'Shift'
    DAY_OFF = 'day_off', 'Day off'


class DayStatusType(models.TextChoices):
    HOLIDAY = 'holiday', 'Holiday'
    WORK_DAY = 'work_day', 'Work day'
    DAY_OFF = 'day_off', 'Day off'


class ActionStatusType(models.TextChoices):
    PENDING = 'pending', 'Pending'
    EDIT_PENDING = 'edit_pending', 'Edit pending'
    REJECT = 'reject', 'Reject'
    EDIT_REJECT = 'edit_reject', 'Edit reject'
    APPROVE = 'approve', 'Approve'
    WAITING_FOR_DELETE = 'waiting_for_delete', 'Waiting for delete'
    DELETE = 'delete', 'Delete'


class EditActionStatusType(models.TextChoices):
    PENDING = 'pending', 'Pending'
    REJECT = 'reject', 'Reject'
    APPROVE = 'approve', 'Approve'


class RosterPlanType(models.TextChoices):
    WEEK = 'week', 'Week'
    MONTH = 'month', 'Month'
