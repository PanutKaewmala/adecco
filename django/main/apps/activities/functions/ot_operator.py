import copy
import typing

from django.db.models import QuerySet
from rest_framework.request import Request

from main.apps.activities.choices import OTRequestStatus
from main.apps.activities.models import OTRequest
from main.apps.activities.serializers.activities import OTRequestWriteSerializer
from main.apps.users.models import EmployeeProject


def ot_request_actions(instance: OTRequest, validated_data: typing.Dict) -> typing.NoReturn:
    status = validated_data.get('status')  # type: OTRequestStatus
    note = validated_data.get('note')
    reason = validated_data.get('reason')
    partial_start_time = validated_data.get('partial_start_time')
    partial_end_time = validated_data.get('partial_end_time')

    instance.note = note
    instance.reason = reason
    instance.status = status
    if status == OTRequestStatus.PARTIAL_APPROVE:
        instance.partial_start_time = partial_start_time
        instance.partial_end_time = partial_end_time

    instance.save(update_fields=['partial_start_time', 'partial_end_time', 'note', 'reason', 'status'])


def split_ot_request_to_employee_projects(validated_data: typing.Dict) -> typing.List:
    employee_projects = validated_data.pop('employee_projects')  # type: QuerySet[EmployeeProject]
    ot_request_data = dict(copy.deepcopy(validated_data))
    return [
        {
            **ot_request_data,
            'user': employee_project.employee.user.id
        }
        for employee_project in employee_projects
    ]


def create_ot_request_list(request: Request, data: list) -> OTRequestWriteSerializer:
    serializer = OTRequestWriteSerializer(data=data, many=True, context={'request': request})
    serializer.is_valid(raise_exception=True)
    serializer.save()
    return serializer
