import typing

from rest_framework.exceptions import ValidationError

from main.apps.common.functions import user_in_admin_or_manager_roles
from main.apps.merchandizers.models import Merchandizer
from main.apps.users.models import User


def user_merchandizer_exists(user: User, merchandizer_id: int) -> typing.NoReturn:
    merchandizer_and_request_match = Merchandizer.objects.filter(id=merchandizer_id,
                                                                 employee_project__employee__user=user).exists()
    if all([
        not merchandizer_and_request_match,
        not user_in_admin_or_manager_roles(user)
    ]):
        raise ValidationError({'detail': 'Merchandizer does not exist'})
