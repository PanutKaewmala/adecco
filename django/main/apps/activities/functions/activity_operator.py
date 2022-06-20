import datetime
import typing

from django.db.models import QuerySet, Value, Count
from django.db.models.functions import Concat
from django.utils import timezone
from rest_framework.exceptions import ValidationError

from main.apps.activities.choices import ActivityType, ActivityExtraType, OTRequestType
from main.apps.activities.models import Activity, LeaveRequestPartialApprove, LeaveType, LeaveTypeSetting, OTRequest
from main.apps.common.utils import convert_date_to_str, is_inside_radius, get_day_name_by_date_week_day
from main.apps.managements.functions.lead_times import lead_time_dict
from main.apps.managements.models import WorkingHour


def filter_by_user_full_name(queryset: QuerySet, name, value) -> QuerySet:
    return query_user_by_full_name(
        queryset=queryset,
        full_name=value,
        first_name_field='user__first_name',
        last_name_field='user__last_name',
    )


def query_user_by_full_name(queryset: QuerySet, full_name,
                            first_name_field='first_name', last_name_field='last_name') -> QuerySet:
    if full_name:
        queryset = queryset.annotate(
            full_name=Concat(first_name_field, Value(' '), last_name_field)
        ).filter(full_name__icontains=full_name)
    return queryset


def objs_of_all_days_in_month(year, month, last_day_of_month) -> dict:
    days = {
        datetime.date(year, month, day).strftime('%Y-%m-%d'): {
            'check_in': None,
            'check_out': None,
            'leave': None,
        }
        for day in range(1, last_day_of_month + 1)
    }
    return days


def get_value_date_from_query_params(self, query_params_name: str) -> datetime:
    if self.request.query_params.get('date'):
        return datetime.datetime.strptime(self.request.query_params.get('date'), '%Y-%m-%d')
    return datetime.date.today()


def get_list_user_data_forget_check_out(date) -> QuerySet[str]:
    return Activity.objects \
        .filter(type__in=[ActivityType.CHECK_IN, ActivityType.CHECK_OUT], date_time__date=date) \
        .values('user', 'workplace', 'project') \
        .annotate(count_activity=Count('user')) \
        .annotate(count_workplace=Count('workplace')) \
        .annotate(count_project=Count('project')) \
        .filter(count_activity__lt=2) \
        .values('user', 'workplace', 'project')


def get_leave_type_column() -> typing.List[str]:
    return list(LeaveTypeSetting.objects.all().values_list('name', flat=True).distinct())


def create_leave_request_partial_approve(instance):
    list_leave_request_partial_approve = []
    delta = instance.end_date - instance.start_date
    leave_dates = [(instance.start_date + datetime.timedelta(days=day)).strftime('%Y-%m-%d') for day in
                   range(delta.days + 1)]
    for leave_date in leave_dates:
        list_leave_request_partial_approve.append(
            LeaveRequestPartialApprove(
                date=leave_date,
                leave_request_id=instance.id
            )
        )
    LeaveRequestPartialApprove.objects.bulk_create(list_leave_request_partial_approve)


def validate_allowed_range_of_leave_request(validated_data):
    today = timezone.now().date()
    delta_from_start_date = (today - validated_data['start_date']).days

    queryset = LeaveType.objects.select_related(
        'leave_type_setting'
    ).filter(
        name=validated_data.get('type'),
        project=validated_data.get('project')
    ).first()
    if not queryset:
        raise ValidationError({'detail': 'Leave type not found in this project'})
    setting = queryset.leave_type_setting
    if not setting:
        raise ValidationError({'detail': 'Setting not found'})
    if (delta_from_start_date < 0 and abs(delta_from_start_date) > setting.apply_before) or (
            delta_from_start_date > setting.apply_after):
        raise ValidationError({'detail': 'Not allow to create leave request because not in the allowed range'})


def validate_user_already_check_in_out_project(validated_data, user) -> typing.NoReturn:
    project = validated_data.get('project')
    activity_type = validated_data.get('type')
    date_time = validated_data.get('date_time')
    workplace = validated_data.get('workplace')

    if Activity.objects.filter(
            type=activity_type,
            user=user,
            project=project,
            date_time__date=date_time.date(),
            workplace=workplace
    ).exists():
        raise ValidationError({'detail': f'{workplace.name}: {convert_date_to_str(date_time)} '
                                         f'user already {activity_type} in project {project.name}'})


def validate_data_check_in_out_required(validated_data, request):
    activity_type = validated_data.get('type')
    if activity_type == ActivityType.CHECK_OUT and not request.data.get('pair_id'):
        raise ValidationError({'detail': f'{activity_type} pair id required'})
    if not validated_data.get('workplace'):
        raise ValidationError({'detail': f'{activity_type} workplace required'})
    if not validated_data.get('project'):
        raise ValidationError({'detail': f'{activity_type} project required'})


def map_activity_by_workplaces(activity_list: list) -> typing.Dict[str, typing.Dict]:
    results = {}
    for activity in activity_list:
        workplace = activity['workplace']
        if workplace not in results:
            results.setdefault(workplace, {'check_in': {}, 'check_out': {}})
        results[workplace][activity['type']] = activity
    return results


def validate_inside_workplace(validated_data) -> bool:
    workplace = validated_data.get('workplace')
    latitude = validated_data.get('latitude')
    longitude = validated_data.get('longitude')
    return is_inside_radius(
        longitude1=longitude,
        latitude1=latitude,
        longitude2=workplace.longitude,
        latitude2=workplace.latitude,
        radius_meter=workplace.radius_meter
    )


def get_lead_time_by_type(activity_type: ActivityType.choices, working_hour: WorkingHour, date_time: datetime.datetime):
    date_name = get_day_name_by_date_week_day(date_time.date())
    if activity_type == ActivityType.CHECK_IN:
        time = getattr(working_hour, f'{date_name}_start_time')
        lead_time_data = lead_time_dict(
            time,
            working_hour.lead_time_in_before,
            working_hour.lead_time_in_after,
        ) if time else {}
    else:
        time = getattr(working_hour, f'{date_name}_end_time')
        lead_time_data = lead_time_dict(
            time,
            working_hour.lead_time_out_before,
            working_hour.lead_time_out_after,
        ) if time else {}

    return lead_time_data.get('before', None), lead_time_data.get('after', None)


def create_ot_request(request, validated_data, start_time, end_time):
    OTRequest(
        user_id=validated_data.get('user_id'),
        project=validated_data.get('project'),
        workplace=validated_data.get('workplace'),
        start_date=validated_data.get('date_time'),
        end_date=validated_data.get('date_time'),
        start_time=start_time,
        end_time=end_time,
        type=OTRequestType.USER_REQUEST,
        description=request.data.get('description')
    ).save()


def validate_lead_times(request, validated_data) -> typing.NoReturn:
    working_hour = validated_data.get('working_hour')  # type: WorkingHour
    extra_type = validated_data.get('extra_type')  # type: ActivityExtraType.choices

    if working_hour:
        activity_type = validated_data.get('type')  # type: ActivityType.choices
        date_time = validated_data.get('date_time')  # type: datetime.datetime
        time_before, time_after = get_lead_time_by_type(activity_type, working_hour, date_time)

        if time_before and time_after:
            if activity_type == ActivityType.CHECK_IN:
                if all([date_time.time() > time_after]):
                    # Late
                    if not Activity.objects.filter(date_time=date_time, project=validated_data.get('project'),
                                                   type=ActivityType.CHECK_IN, user=validated_data.get('user_id'),
                                                   extra_type=ActivityExtraType.LATE).exists():
                        validated_data['extra_type'] = ActivityExtraType.LATE

                elif all([date_time.time() < time_before, extra_type == ActivityExtraType.OT]):
                    create_ot_request(request, validated_data, date_time.time(), time_before)
            elif activity_type == ActivityType.CHECK_OUT:
                if all([date_time.time() > time_after, extra_type == ActivityExtraType.OT]):
                    create_ot_request(request, validated_data, time_after, date_time.time())
