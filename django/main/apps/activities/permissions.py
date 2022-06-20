from rest_framework.permissions import BasePermission

from main.apps.activities.models import LeaveRequest


class AllowActions(BasePermission):
    message = 'api not allowed.'

    def has_permission(self, request, view):
        instance = view.get_object()  # type: LeaveRequest
        return instance
