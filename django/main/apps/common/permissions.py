from rest_framework.permissions import BasePermission

from main.apps.common.functions import user_in_admin_or_manager_roles, user_in_associate_role
from main.apps.users.choices import Role


class IsSuperAdminOrAdmin(BasePermission):
    message = 'api not allowed.'

    def has_permission(self, request, view):
        return request.user.role in [Role.SUPER_ADMIN, Role.PROJECT_MANAGER]


class IsAssociate(BasePermission):
    message = 'This api only allow for associate'

    def has_permission(self, request, view):
        return user_in_associate_role(request.user)


class IsAllRoles(BasePermission):
    message = 'You have no permission to do this.'

    def has_permission(self, request, view):
        return request.user.role in [Role.SUPER_ADMIN, Role.PROJECT_MANAGER, Role.ASSOCIATE]


class AdminRoleWritePermission(BasePermission):
    message = "You don't have permission."

    def has_permission(self, request, view):
        if view.action in ['update', 'partial_update', 'create']:
            return user_in_admin_or_manager_roles(request.user)
        return True
