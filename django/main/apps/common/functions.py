from django.utils import timezone

from main.apps.users.models import User
from main.apps.users.choices import Role


def user_in_admin_or_manager_roles(user: User) -> bool:
    return user.role in [Role.SUPER_ADMIN, Role.PROJECT_MANAGER, Role.PROJECT_ASSIGNEE]


def user_in_associate_role(user: User) -> bool:
    return user.role == Role.ASSOCIATE


def get_date_from_request(date) -> timezone.datetime.date:
    return timezone.datetime.strptime(date, '%Y-%m-%d')
