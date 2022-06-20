from django.contrib.auth.hashers import make_password, check_password
from rest_framework import status
from rest_framework.exceptions import ValidationError
from rest_framework.generics import GenericAPIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework_simplejwt.views import TokenObtainPairView

from main.apps.authentication.serializers import MyTokenObtainPairSerializer, CreateNewPasswordSerializer, \
    CreatePinCodeSerializer, LoginPinCodeSerializer, ChangePasswordSerializer
from main.apps.common.permissions import IsSuperAdminOrAdmin


class MyTokenObtainPairView(TokenObtainPairView):
    serializer_class = MyTokenObtainPairSerializer


class ChangeFirstTimePasswordView(GenericAPIView):
    serializer_class = CreateNewPasswordSerializer

    def post(self, request, *args, **kwargs):
        user = request.user
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        new_password = request.data.get('new_password')
        confirm_password = request.data.get('confirm_password')

        if new_password != confirm_password:
            return Response({'error': 'Password not match.'}, status=status.HTTP_400_BAD_REQUEST)
        if user.check_password(new_password):
            return Response({'error': 'Cannot use old password.'}, status=status.HTTP_400_BAD_REQUEST)
        user.set_password(new_password)
        user.default_password_changed = True
        user.save()
        return Response({'detail': 'OK'}, status=status.HTTP_200_OK)


class ChangePasswordView(GenericAPIView):
    serializer_class = ChangePasswordSerializer
    permission_classes = [IsAuthenticated, IsSuperAdminOrAdmin]

    def post(self, request, *args, **kwargs):
        user = request.user
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        current_password = serializer.validated_data.get('current_password')
        new_password = serializer.validated_data.get('new_password')
        confirm_new_password = serializer.validated_data.get('confirm_new_password')

        if not user.check_password(current_password):
            raise ValidationError({'detail': 'Current password is incorrect'})
        if new_password != confirm_new_password:
            return ValidationError({'detail': 'Password do not match.'})
        if current_password == confirm_new_password:
            raise ValidationError({'detail': 'New password must different from old password'})
        user.set_password(new_password)
        user.save()
        return Response({'details': 'OK'}, status=status.HTTP_200_OK)


class CreatePinCodeView(GenericAPIView):
    serializer_class = CreatePinCodeSerializer

    def post(self, request, *args, **kwargs):
        user = request.user
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        new_pincode = request.data.get('new_pincode')
        user.pincode = make_password(new_pincode)
        user.save()
        return Response({'detail': 'OK'}, status=status.HTTP_200_OK)


class LoginPinCodeView(GenericAPIView):
    serializer_class = LoginPinCodeSerializer

    def post(self, request, *args, **kwargs):
        user = request.user
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        pincode = request.data.get('pincode')

        if not check_password(pincode, user.pincode):
            raise ValidationError({'detail': 'Pincode is incorrect'})
        return Response({'detail': 'OK'}, status=status.HTTP_200_OK)
