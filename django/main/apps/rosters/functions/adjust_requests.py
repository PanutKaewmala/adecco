from typing import List

from django.db.models import QuerySet
from django.db.models.expressions import Value
from django.db.models.functions import Concat
from rest_framework.request import Request

from main.apps.rosters.serializers.adjust_requests import AdjustRequestValidateSerialzier, AdjustRequestWriteSerializer


def adjust_request_filter_employee_name_by_user(queryset: QuerySet, name, value) -> QuerySet:
    if value:
        queryset = queryset.annotate(
            full_name=Concat(
                'employee_project__employee__user__first_name',
                Value(' '),
                'employee_project__employee__user__last_name'
            )
        ).filter(full_name__icontains=value)
    return queryset


class AdjustRequestHandle:
    _validate_data: List[dict]
    _remark: str
    _adjust_request_data: List[dict]

    def __init__(self, request: Request):
        self._request = request
        self._request_data = request.data
        self._adjust_request_data = []

    def create_adjust_request(self):
        self._set_validate_data_from_request_data()
        self._map_validate_data_to_adjust_request()
        return self._create_adjust_request_data()

    def _set_validate_data_from_request_data(self):
        serializer = AdjustRequestValidateSerialzier(data=self._request_data.get('date_list'), many=True)
        serializer.is_valid(raise_exception=True)
        self._validate_data = serializer.validated_data
        self._remark = self._request_data.get('remark', '')

    def _map_validate_data_to_adjust_request(self):
        for date_data in self._validate_data:
            for employee in date_data.get('employee_list'):
                self._adjust_request_data.append(
                    {
                        **employee,
                        'date': date_data.get('date'),
                        'remark': date_data.get('remark'),
                    }
                )

    def _create_adjust_request_data(self):
        serializer = AdjustRequestWriteSerializer(data=self._get_adjust_data_from_serializer(), many=True)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return serializer.data

    def _get_adjust_data_from_serializer(self):
        return AdjustRequestWriteSerializer(self._adjust_request_data, many=True).data
