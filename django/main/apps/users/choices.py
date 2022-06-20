from django.db import models


class Role(models.TextChoices):
    SUPER_ADMIN = 'super_admin', 'Super Admin'
    PROJECT_MANAGER = 'project_manager', 'Project Manager'
    PROJECT_ASSIGNEE = 'project_assignee', 'Project Assignee'
    ASSOCIATE = 'associate', 'Associate'


class DailyTaskType(models.TextChoices):
    DAILY_TASK = 'daily_task', 'Daily Task'
    PIN_POINT = 'pin_point', 'Pin Point'
    TRACK_ROUTE = 'track_route', 'Track Route'


class TaskType(models.TextChoices):
    CHECK_IN = 'check_in', 'Check in'
    CHECK_OUT = 'check_out', 'Check out'
    PIN_POINT = 'pin_point', 'Pin Point'
    TRACK_ROUTE = 'track_route', 'Track Route'
    TASK = 'task', 'Task'
