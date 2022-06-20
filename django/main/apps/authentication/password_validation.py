import re

from django.core.exceptions import ValidationError
from django.utils.translation import gettext as _
from rest_framework.exceptions import ValidationError as RESTValidationError


class AdeccoPasswordPoliciesValidator:
    """
    - 6 letters at least
    - Must contain Uppercase
    - Must contain Lowercase
    - Must contain Number
    - Must contain Special character
    """

    @staticmethod
    def _validate(password):
        at_least_6_characters = len(password) >= 6
        contain_lowercase = re.match('.*[a-z]+', password)
        contain_uppercase = re.match('.*[A-Z]+', password)
        contain_number = re.match('.*[0-9]+', password)
        contain_special_character = re.match('.*[ -/:-@[-`{-~]+', password)
        return (at_least_6_characters
                and contain_lowercase
                and contain_uppercase
                and contain_number
                and contain_special_character)

    @staticmethod
    def serializer_validate(password):
        validated = AdeccoPasswordPoliciesValidator._validate(password)
        if not validated:
            raise RESTValidationError(
                _('Password must contain lowercase, uppercase, number, special character '
                  'and have at least 6 characters')
            )

    def validate(self, password):
        validated = self._validate(password)
        if not validated:
            raise ValidationError(
                _('Password must contain lowercase, uppercase, number, special character '
                  'and have at least 6 characters'),
                code='password_not_pass_adecco_policies',
            )

    def get_help_text(self):
        return _('Password must contain lowercase, uppercase, number, special character and have at least 6 characters')
