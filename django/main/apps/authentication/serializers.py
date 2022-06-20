from rest_framework import serializers
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

from main.apps.authentication.password_validation import AdeccoPasswordPoliciesValidator
from main.apps.common.utils import validate_pincode
from main.apps.users.serializers.users import UserCreateSerializer


class MyTokenObtainPairSerializer(TokenObtainPairSerializer):
    """Serializer for returning JWT token"""

    def validate(self, attrs):
        attrs['username'] = attrs.get('username').lower()
        data = super().validate(attrs)
        refresh = self.get_token(self.user)

        data['refresh'] = str(refresh)
        data['access'] = str(refresh.access_token)
        data['user'] = UserCreateSerializer(self.user).data

        return data


class CreateNewPasswordSerializer(serializers.Serializer):
    new_password = serializers.CharField(validators=[AdeccoPasswordPoliciesValidator.serializer_validate],
                                         write_only=True)
    confirm_password = serializers.CharField(validators=[AdeccoPasswordPoliciesValidator.serializer_validate],
                                             write_only=True)


class ChangePasswordSerializer(serializers.Serializer):
    current_password = serializers.CharField()
    new_password = serializers.CharField(validators=[AdeccoPasswordPoliciesValidator.serializer_validate],
                                         write_only=True)
    confirm_new_password = serializers.CharField(validators=[AdeccoPasswordPoliciesValidator.serializer_validate],
                                                 write_only=True)


class CreatePinCodeSerializer(serializers.Serializer):
    new_pincode = serializers.CharField()

    def validate_new_pincode(self, value):
        return validate_pincode(value)


class LoginPinCodeSerializer(serializers.Serializer):
    pincode = serializers.CharField()

    def validate_pincode(self, value):
        return validate_pincode(value)
