from typing import Dict

from rest_framework.request import Request

from main.apps.rosters.choices import RosterStatusType, RosterType
from main.apps.rosters.models import Roster
from main.apps.rosters.serializers.rosters import RosterActionSerializer


class RosterAction:
    _validate_data: Dict

    def __init__(self, roster: Roster, request: Request):
        self._roster = roster
        self._request = request
        self._validate_request_data()

    def _validate_request_data(self):
        serializer = RosterActionSerializer(data=self._request.data)
        serializer.is_valid(raise_exception=True)
        self._validate_data = serializer.validated_data

    def actions(self):
        if self._validate_data.get('status') == RosterStatusType.APPROVE:
            self._approve()
        if self._validate_data.get('status') == RosterStatusType.REJECT:
            self._reject()

    def _approve(self):
        self._roster.status = RosterStatusType.APPROVE
        self._roster.remark = self._validate_data.get('remark')
        self._roster.save(update_fields=['status', 'remark'])
        self._update_status_in_shift_or_day_off(status=RosterStatusType.APPROVE)

    def _reject(self):
        self._roster.status = RosterStatusType.REJECT
        self._roster.remark = self._validate_data.get('remark')
        self._roster.save(update_fields=['status', 'remark'])
        self._update_status_in_shift_or_day_off(status=RosterStatusType.REJECT)

    def _update_status_in_shift_or_day_off(self, status: RosterStatusType.choices):
        if self._roster.type == RosterType.SHIFT:
            self._roster.shifts.all().update(status=status)
        elif self._roster.type == RosterType.DAY_OFF:
            self._roster.day_off.status = status
            self._roster.day_off.save(update_fields=['status'])
