from typing import List

from django.db import models
from django.db.models import Q
from model_controller.models import AbstractSoftDelete
from rest_framework.exceptions import ValidationError

from main.apps.common.constants import DAY_OF_WEEK_LIST, DAY_OF_WEEK_FROM_CALENDAR
from main.apps.rosters.choices import RosterStatusType, DayStatusType, ActionStatusType, EditActionStatusType, \
    RosterType
from main.apps.rosters.utils import schedule_map_data_to_dict


class Roster(models.Model):
    employee_projects = models.ManyToManyField(
        to='users.EmployeeProject',
        related_name='rosters',
    )
    name = models.CharField(max_length=255, null=False, blank=False)
    type = models.CharField(choices=RosterType.choices, default=RosterType.SHIFT, max_length=20)
    description = models.TextField(null=True, blank=True)
    start_date = models.DateField(null=False, blank=False)
    end_date = models.DateField(null=False, blank=False)
    status = models.CharField(choices=RosterStatusType.choices, default=RosterStatusType.PENDING, max_length=20)
    remark = models.TextField(null=True, blank=True)
    roster_setting = models.BooleanField(default=False)

    @property
    def shifts_without_delete(self):
        return self.shifts.exclude(status__in=[ActionStatusType.EDIT_PENDING, ActionStatusType.DELETE])

    @property
    def get_employee_name_list(self) -> List[str]:
        return [
            employee_project.employee.user.full_name
            for employee_project in self.employee_projects.select_related('employee__user').all()
        ]

    @property
    def get_total_days(self) -> int:
        return (self.end_date - self.start_date).days

    @property
    def get_shifts_sequence(self) -> dict:
        self.shifts.filter(status__in=['approve', 'waiting_for_delete']).order_by('from_date')
        return {}

    def __str__(self):
        return f'roster {self.name} <{self.pk}>'


class Shift(models.Model):
    roster = models.ForeignKey(
        to='rosters.Roster',
        on_delete=models.SET_NULL,
        null=True,
        related_name='shifts'
    )
    from_date = models.DateField(null=False, blank=False)
    to_date = models.DateField(null=False, blank=False)
    status = models.CharField(choices=ActionStatusType.choices, default=ActionStatusType.PENDING, max_length=20)
    remark = models.TextField(null=True, blank=True)
    working_hour = models.ForeignKey(
        to='managements.WorkingHour',
        on_delete=models.SET_NULL,
        null=True,
        related_name='shifts'
    )

    def save(self, *args, **kwargs):
        self.validate_shift_date_range_unique_in_roster()
        super().save(*args, **kwargs)

    def validate_shift_date_range_unique_in_roster(self):
        if Shift.objects.exclude(id=self.id).filter(
                Q(roster=self.roster,
                  status__in=[ActionStatusType.PENDING, ActionStatusType.APPROVE, ActionStatusType.REJECT]) &
                (
                        Q(from_date__range=(self.from_date, self.to_date)) |
                        Q(to_date__range=(self.from_date, self.to_date)) |
                        Q(from_date__lt=self.from_date, to_date__gt=self.to_date)
                )
        ).exists() and self.status != ActionStatusType.DELETE:
            raise ValidationError(
                {
                    'detail': f'roster {self.roster} from_date and to_date must unique.'
                }
            )

    @property
    def range_date_name(self) -> str:
        return f'{self.from_date} - {self.to_date}'

    @property
    def get_all_workplaces_in_shift(self) -> List[str]:
        workplaces = list(self.schedules.all().values_list('workplaces__name', flat=True).distinct())
        return workplaces

    @property
    def get_total_days(self) -> int:
        return (self.to_date - self.from_date).days

    @property
    def get_holiday_list(self) -> List:
        return [day for day in DAY_OF_WEEK_LIST if not getattr(self.working_hour, day)]

    @property
    def get_day_of_week_with_details(self) -> dict:
        day_of_week_result = dict.fromkeys(DAY_OF_WEEK_FROM_CALENDAR, {})
        for day_name in DAY_OF_WEEK_FROM_CALENDAR:
            for schedule in self.schedules.all():
                day_status_target = getattr(schedule, day_name)
                if day_status_target == DayStatusType.WORK_DAY:
                    day_of_week_result.update({
                        day_name: schedule_map_data_to_dict(
                            day_status_target, schedule.workplaces.all(), self.working_hour
                        )
                    })
                elif day_status_target in [DayStatusType.DAY_OFF, DayStatusType.HOLIDAY] \
                        and day_of_week_result[day_name].get('type') != DayStatusType.WORK_DAY:
                    day_of_week_result.update({
                        day_name: schedule_map_data_to_dict(day_status_target, [], None)
                    })
        return day_of_week_result

    def __str__(self):
        return f'shift {self.range_date_name} <{self.pk}>'


class Schedule(models.Model):
    shift = models.ForeignKey(
        to='rosters.Shift',
        on_delete=models.SET_NULL,
        null=True,
        related_name='schedules'
    )
    sunday = models.CharField(max_length=10, choices=DayStatusType.choices)
    monday = models.CharField(max_length=10, choices=DayStatusType.choices)
    tuesday = models.CharField(max_length=10, choices=DayStatusType.choices)
    wednesday = models.CharField(max_length=10, choices=DayStatusType.choices)
    thursday = models.CharField(max_length=10, choices=DayStatusType.choices)
    friday = models.CharField(max_length=10, choices=DayStatusType.choices)
    saturday = models.CharField(max_length=10, choices=DayStatusType.choices)
    workplaces = models.ManyToManyField(
        to='managements.WorkPlace',
        related_name='+'
    )

    class Meta:
        constraints = [
            models.UniqueConstraint(
                fields=['shift', 'sunday'],
                condition=Q(sunday=DayStatusType.WORK_DAY),
                name='unique-shift-sunday-working'
            ),
            models.UniqueConstraint(
                fields=['shift', 'monday'],
                condition=Q(monday=DayStatusType.WORK_DAY),
                name='unique-shift-monday-working'
            ),
            models.UniqueConstraint(
                fields=['shift', 'tuesday'],
                condition=Q(tuesday=DayStatusType.WORK_DAY),
                name='unique-shift-tuesday-working'
            ),
            models.UniqueConstraint(
                fields=['shift', 'wednesday'],
                condition=Q(wednesday=DayStatusType.WORK_DAY),
                name='unique-shift-wednesday-working'
            ),
            models.UniqueConstraint(
                fields=['shift', 'thursday'],
                condition=Q(thursday=DayStatusType.WORK_DAY),
                name='unique-shift-thursday-working'
            ),
            models.UniqueConstraint(
                fields=['shift', 'friday'],
                condition=Q(friday=DayStatusType.WORK_DAY),
                name='unique-shift-friday-working'
            ),
            models.UniqueConstraint(
                fields=['shift', 'saturday'],
                condition=Q(saturday=DayStatusType.WORK_DAY),
                name='unique-shift-saturday-working'
            )
        ]


class EditShift(models.Model):
    from_shift = models.ForeignKey(to='rosters.Shift', on_delete=models.CASCADE, related_name='+')
    to_shift = models.ForeignKey(to='rosters.Shift', on_delete=models.CASCADE, related_name='+')
    status = models.CharField(choices=EditActionStatusType.choices, default=EditActionStatusType.PENDING, max_length=20)
    sequence = models.PositiveSmallIntegerField(default=0)


class DayOff(models.Model):
    roster = models.OneToOneField(
        to='rosters.Roster',
        on_delete=models.SET_NULL,
        null=True,
        related_name='day_off'
    )
    working_hour = models.ForeignKey(
        to='managements.WorkingHour',
        on_delete=models.SET_NULL,
        null=True,
        related_name='day_offs'
    )
    status = models.CharField(choices=ActionStatusType.choices, default=ActionStatusType.PENDING, max_length=20)

    @property
    def get_day_off_list(self) -> list[str]:
        return list(self.details.values_list('date', flat=True))

    @property
    def get_workplaces_list(self) -> list[str]:
        employee_project = self.roster.employee_projects.all().first()
        return list(employee_project.workplaces.all().values_list('name', flat=True) if employee_project else [])

    @property
    def get_work_days_list(self) -> list[str]:
        return list(day for day in DAY_OF_WEEK_LIST if getattr(self.working_hour, day))

    @property
    def get_holiday_days_list(self) -> list[str]:
        return list(day for day in DAY_OF_WEEK_LIST if not getattr(self.working_hour, day))


class DayOffDetail(models.Model):
    day_off = models.ForeignKey(
        to='rosters.DayOff',
        on_delete=models.SET_NULL,
        null=True,
        related_name='details'
    )
    date = models.DateField(null=False, blank=False)


class AdjustRequest(AbstractSoftDelete):
    employee_project = models.ForeignKey(
        to='users.EmployeeProject',
        on_delete=models.SET_NULL,
        null=True,
        related_name='adjust_requests'
    )
    date = models.DateField(null=False, blank=False)
    type = models.CharField(max_length=10, choices=DayStatusType.choices)
    workplaces = models.ManyToManyField(
        to='managements.WorkPlace',
        related_name='+'
    )
    working_hour = models.ForeignKey(
        to='managements.WorkingHour',
        on_delete=models.SET_NULL,
        null=True,
        related_name='+'
    )
    remark = models.TextField(null=True, blank=True)

    @property
    def get_date_details(self) -> list[str]:
        return schedule_map_data_to_dict(self.type, self.workplaces.all(), self.working_hour)
