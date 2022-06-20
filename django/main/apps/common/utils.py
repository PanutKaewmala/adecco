import datetime
from math import radians, cos, sin, asin, sqrt
from typing import Dict, List
from urllib.parse import urlencode, urlparse, parse_qs

from rest_flex_fields import EXPAND_PARAM
from rest_framework import serializers

from main.apps.common.constants import DAY_OF_WEEK_FROM_CALENDAR


def merge_url_query_params(url: str, additional_params: dict) -> str:
    url_components = urlparse(url)
    original_params = parse_qs(url_components.query)
    merged_params = {**original_params, **additional_params}
    updated_query = urlencode(merged_params, doseq=True)
    return url_components._replace(query=updated_query).geturl()


def validate_pincode(value):
    if not value.isnumeric() or len(value) != 6:
        raise serializers.ValidationError(['Pincode must be number and length equals 6'])
    return value


def convert_type_list_to_dictionary(data_list: list, type_name: str) -> Dict[str, Dict]:
    """
        convert list of activity to dict. key = type of activity
        simple data return
        "check_in": {...}
        "check_out": {...}
    """
    return {
        data[type_name]: data for data in data_list
    }


def get_list_of_date_by_start_date_and_total_days(start_date: datetime.date, total_days: int) -> List[datetime.date]:
    return list(
        start_date + datetime.timedelta(days=days)
        for days in range(0, total_days + 1)
    )


def get_total_days(from_date: datetime.date, to_date: datetime.date) -> int:
    return (to_date - from_date).days


def get_day_name_by_date_week_day(date: datetime.date) -> str:
    return DAY_OF_WEEK_FROM_CALENDAR[date.weekday()]


def convert_string_to_date(date_str) -> datetime.date:
    return datetime.datetime.strptime(date_str, '%Y-%m-%d').date()


def convert_date_to_str(date, format_str='%Y-%m-%d') -> str:
    if isinstance(date, datetime.datetime):
        return date.date().strftime(format_str)
    return date.strftime(format_str)


def get_expand_query_params(request):
    expand_value = request.query_params.get(EXPAND_PARAM, '')
    return expand_value.split(',')


def optimize_expanded_query(request, queryset, select_related=None, prefetch_related=None):
    expand_fields = []

    if select_related is None:
        select_related = {}

    if prefetch_related is None:
        prefetch_related = {}

    expand_values = get_expand_query_params(request)
    for f in expand_values:
        expand_fields.extend(list(f.split('.')))

    expanding_select_related = [
        value
        for key, value in select_related.items() if key in expand_fields
    ]
    if expanding_select_related:
        queryset = queryset.select_related(*expanding_select_related)

    expanding_prefetch_related = [
        value
        for key, value in prefetch_related.items() if key in expand_fields
    ]
    if expanding_prefetch_related:
        queryset = queryset.prefetch_related(*expanding_prefetch_related)

    return queryset


def is_inside_radius(longitude1, latitude1, longitude2, latitude2, radius_meter=100) -> bool:
    """
    https://stackoverflow.com/questions/42686300/how-to-check-if-coordinate-inside-certain-area-python
    Calculate the great circle distance between two points
    on the earth (specified in decimal degrees)
    """
    # convert decimal degrees to radians
    longitude1, latitude1, longitude2, latitude2 = map(radians, [longitude1, latitude1, longitude2, latitude2])

    # haversine formula
    distance_longitude = longitude2 - longitude1
    distance_latitude = latitude2 - latitude1
    a = sin(distance_latitude / 2) ** 2 + cos(latitude1) * cos(latitude2) * sin(distance_longitude / 2) ** 2
    c = 2 * asin(sqrt(a))
    r = 6371  # Radius of earth in kilometers. Use 3956 for miles
    haversine = c * r
    return haversine <= (radius_meter / 1000)


def convert_time_to_datetime(time: datetime.time) -> datetime.datetime:
    return datetime.datetime.strptime(time.strftime('%H:%M:%S'), '%H:%M:%S')


def get_minute_delta(minutes: int):
    return datetime.timedelta(days=0, minutes=minutes)


def calculate_year_month_day_in_total(start_date: str):
    current_date = datetime.datetime.now()
    if start_date:
        deadline_date = datetime.datetime.strptime(start_date, '%Y-%m-%d')
        days_left = deadline_date - current_date

        years = ((days_left.total_seconds()) / (365.242 * 24 * 3600))
        years_int = int(years)

        months = (years - years_int) * 12
        months_int = int(months)

        days = (months - months_int) * (365.242 / 12)
        days_int = int(days)

        return f'{abs(years_int)}y {abs(months_int)}m {abs(days_int)}d'
    return None


def multiple_time_by_total_days(time: datetime.time, total_days: int) -> datetime.timedelta:
    return datetime.timedelta(
        hours=time.hour * total_days,
        minutes=time.minute * total_days,
    )


def convert_time_delta_to_minutes(time: datetime.timedelta) -> int:
    return (time.days * 24 * 60) + (time.seconds // 60)


def total_minutes_to_hour_minute(total_minute) -> str:
    return str(f'{total_minute // 60:02}.{total_minute % 60:02}')


def create_list_all_dates_in_month(year: int, month: int, last_day_of_month: int) -> list[datetime.date]:
    days = [
        datetime.date(year, month, day)
        for day in range(1, last_day_of_month + 1)
    ]
    return days
