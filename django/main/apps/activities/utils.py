import calendar
import datetime

from main.apps.activities.choices import ActivityType
from main.apps.activities.models import LeaveRequest


def last_day_of(date: datetime) -> tuple[int, int, int]:
    year = date.year
    month = date.month
    last_day_of_month = calendar.monthrange(year, month)[1]
    return year, month, last_day_of_month


def get_date_remain(instance: LeaveRequest) -> datetime.datetime.date:
    date = instance.end_date - instance.start_date
    return date


def get_date_remain_deduct_only_approve_leave(leave_request_partial_approves) -> int:
    return len(list(filter(lambda leave_request_partial_approve: leave_request_partial_approve.get('approve') is True,
                           leave_request_partial_approves)))


def activity_in_check_in_out(activity_type) -> bool:
    return activity_type in [ActivityType.CHECK_IN, ActivityType.CHECK_OUT]
