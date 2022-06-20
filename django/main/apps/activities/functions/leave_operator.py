from datetime import timedelta
from typing import NoReturn, Dict, List

from django.db.models import QuerySet, Value
from django.db.models.functions import Concat
from rest_framework.exceptions import ValidationError

from main.apps.activities.choices import LeaveStatus
from main.apps.activities.models import LeaveRequest, LeaveQuota
from main.apps.activities.serializers.leave_requests import LeaveRequestUpdateSerializer
from main.apps.activities.utils import get_date_remain, get_date_remain_deduct_only_approve_leave
from main.apps.common.utils import get_total_days


def filter_queryset_by_user(queryset: QuerySet, name, value) -> QuerySet:
    if value:
        queryset = queryset.annotate(
            full_name=Concat('user__first_name', Value(' '), 'user__last_name')
        ).filter(full_name__icontains=value)
    return queryset


def filter_user(queryset: QuerySet, value) -> QuerySet:
    if value:
        queryset = queryset.annotate(
            user_full_name=Concat('first_name', Value(' '), 'last_name')
        ).filter(user_full_name__icontains=value)
    return queryset


def loa_process(instance: LeaveRequest) -> bool:
    return True


def calculate_leave_request(instance: LeaveRequest, leave_request_partial_approves):
    try:
        quota = instance.user.leave_quotas.get(type=instance.type,
                                               project=instance.project)  # type: LeaveQuota
    except LeaveQuota.DoesNotExist:
        raise ValidationError(
            {
                'detail': 'Not found leave quota'
            }
        )

    if instance.status != LeaveStatus.PENDING:
        raise ValidationError({'detail': 'This leave request is not pending status.'})
    if leave_request_partial_approves:
        number_days_of_approval: int = get_date_remain_deduct_only_approve_leave(leave_request_partial_approves)
    else:
        number_days_of_approval: int = get_total_days(instance.start_date, instance.end_date)+1

    if quota.remained < number_days_of_approval:
        raise ValidationError(
            {
                'detail': f'{instance.type} remaining {quota.remained} day not enough for '
                          f'{instance.type.name.lower()}'
            }
        )
    quota.used += number_days_of_approval
    quota.save(update_fields=['used'])


def approve_leave_request(instance: LeaveRequest, leave_request_partial_approves, note=None) -> NoReturn:
    complete_loa = loa_process(instance)

    if complete_loa:
        calculate_leave_request(instance, leave_request_partial_approves)

        instance.status = LeaveStatus.UPCOMING
        instance.note = note
        instance.save(update_fields=['status', 'note'])


def reject_leave_request(instance: LeaveRequest, status, reason) -> NoReturn:
    instance.status = status
    instance.reason = reason
    instance.save(update_fields=['status', 'reason'])


def partial_approve(instance: LeaveRequest, leave_request_partial_approves):
    approve_leave_request(instance, leave_request_partial_approves)
    update_leave_request_partial_approve(instance, leave_request_partial_approves)


def update_leave_request_partial_approve(instance: LeaveRequest, leave_request_partial_approves):
    data = {'id': instance.id, 'leave_request_partial_approves': leave_request_partial_approves}
    serializer = LeaveRequestUpdateSerializer(instance, data=data)
    serializer.is_valid()
    serializer.save()


def leave_request_actions(instance: LeaveRequest, validated_data: Dict) -> NoReturn:
    status = validated_data.get('status')  # type: LeaveStatus
    note = validated_data.get('note')
    reason = validated_data.get('reason')
    leave_request_partial_approves = validated_data.get('leave_request_partial_approves')

    if status == LeaveStatus.PARTIAL_APPROVE:
        partial_approve(instance, leave_request_partial_approves)
    if status in [LeaveStatus.APPROVE]:
        approve_leave_request(instance, note)
    if status == LeaveStatus.REJECT:
        reject_leave_request(instance, status, reason)


def collect_leave_dates_and_compare_in_month(query_sets: QuerySet, all_days_in_month) -> NoReturn:
    for queryset in query_sets:
        start_date = queryset.start_date
        end_date = queryset.end_date
        delta = end_date - start_date
        leave_dates = [(start_date + timedelta(days=day)).strftime('%Y-%m-%d') for day in range(delta.days + 1)]
        for leave_date in leave_dates:
            if leave_date in all_days_in_month:
                all_days_in_month[leave_date]['leave'] = queryset


def get_list_date_from_leave_request(instance: LeaveRequest) -> List[str]:
    date_remain = get_date_remain(instance)
    return [(instance.start_date + timedelta(days=day)).strftime('%Y-%m-%d') for day in range(date_remain.days + 1)]


def check_type_of_calendar(value: dict):
    if value.get('leave'):
        return 'leave'
    return None


def check_status_of_checkin_checkout(value):
    if value.get('leave'):
        return 'leave'
    elif value.get('check_in') and value.get('check_out'):
        return 'on_time'
    return None
