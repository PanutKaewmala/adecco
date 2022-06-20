import datetime

from main.apps.common.utils import convert_time_to_datetime, get_minute_delta


def get_time_before(time, minutes):
    return (convert_time_to_datetime(time) - get_minute_delta(minutes)).time()


def get_time_after(time, minutes):
    return (convert_time_to_datetime(time) + get_minute_delta(minutes)).time()


def lead_time_dict(time: datetime.time, lead_time_before: int, lead_time_after: int):
    return {
        'before': get_time_before(time, lead_time_before),
        'time': time,
        'after': get_time_after(time, lead_time_after)
    }
