from django.contrib.auth.hashers import make_password
from rest_flex_fields.serializers import FlexFieldsSerializerMixin
from rest_framework import serializers, validators

from main.apps.common.serializers import FlexedWritableNestedModelSerializer
from main.apps.managements.models import Project, Client
from main.apps.users.choices import Role
from main.apps.users.functions.users import set_username
from main.apps.users.models import User, Employee


class UserBlobUploadSerializer(serializers.ModelSerializer):
    photo = serializers.ImageField(required=False)

    class Meta:
        model = User
        fields = ('id', 'photo')
        ready_only_fields = ('id', 'full_name', 'username')


class ProjectCommonSerializer(serializers.ModelSerializer):
    class Meta:
        model = Project
        fields = ('id', 'name')


class ClientCommonSerializer(serializers.ModelSerializer):
    projects = ProjectCommonSerializer(many=True)

    class Meta:
        model = Client
        fields = ('id', 'name', 'projects')


class EmployeeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Employee
        fields = ('id', 'middle_name', 'nick_name', 'address')


class UserRetrieveSerializer(FlexFieldsSerializerMixin, serializers.ModelSerializer):
    employee = EmployeeSerializer()

    class Meta:
        model = User
        fields = ('id', 'username', 'email', 'first_name', 'last_name',
                  'role', 'full_name', 'phone_number', 'photo', 'employee')
        expandable_fields = {
            'clients': (ClientCommonSerializer, {'source': 'employee.clients', 'many': True}),
        }


class UserListSerializer(UserRetrieveSerializer):
    class Meta(UserRetrieveSerializer.Meta):
        fields = ('id', 'username', 'email', 'full_name', 'role', 'first_name', 'last_name')


class UserCreateSerializer(serializers.ModelSerializer):
    """Serializer for User model"""

    class Meta:
        model = User
        fields = ('id', 'username', 'password', 'email', 'first_name', 'last_name', 'default_password_changed',
                  'role')
        extra_kwargs = {
            'username': {
                'validators': [
                    validators.UniqueValidator(queryset=User.objects.all())
                ]
            },
            'email': {
                'validators': [
                    validators.UniqueValidator(queryset=User.objects.all())
                ]
            },
            'password': {
                'write_only': True,
                'required': False
            }
        }

    def create(self, validated_data):
        validated_data['password'] = 'adecco'
        if 'password' in validated_data:
            validated_data['password'] = make_password(validated_data['password'])
        if User.objects.filter(email=validated_data['email']).exists():
            raise serializers.ValidationError(
                {
                    'email': 'This field must be unique'
                }
            )
        return super().create(validated_data)


class UserUpdateSerializer(FlexedWritableNestedModelSerializer):
    employee = EmployeeSerializer(required=False)

    class Meta:
        model = User
        fields = ('first_name', 'last_name', 'phone_number', 'photo', 'email', 'employee')

    extra_kwargs = {
        'username': {'read_only': True},
        'role': {'read_only': True}
    }


class UserCommonSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'full_name', 'email', 'photo')


class UserCommonManagerSerializer(UserCommonSerializer):
    class Meta(UserCommonSerializer.Meta):
        fields = ('id', 'full_name', 'email', 'role', 'username')


class UserCommonDetailSerializer(UserCommonSerializer):
    class Meta(UserCommonSerializer.Meta):
        fields = ('id', 'full_name', 'email', 'photo', 'first_name', 'last_name', 'phone_number')


class UserDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'full_name', 'email', 'role', 'phone_number')


class UserAssociateSerializer(UserCreateSerializer):
    username = serializers.CharField(required=False)

    def create(self, validated_data):
        validated_data = set_username(validated_data)
        validated_data['role'] = Role.ASSOCIATE
        return super().create(validated_data)

    def update(self, instance: User, validated_data):
        if User.objects.filter(email=validated_data['email']).exists() and validated_data['email'] != instance.email:
            raise serializers.ValidationError(
                {
                    'email': 'This field must be unique'
                }
            )
        return super().update(instance, validated_data)

    class Meta(UserCreateSerializer.Meta):
        fields = ('id', 'username', 'password', 'email', 'first_name', 'last_name',
                  'role', 'phone_number')
        extra_kwargs = {
            'password': {
                'write_only': True,
                'required': False
            }
        }


class UserManagerSerializer(UserCreateSerializer):
    username = serializers.CharField(required=False)
    role = serializers.CharField()

    def create(self, validated_data):
        validated_data = set_username(validated_data)
        if validated_data.get('role') == 'supervisor':
            validated_data['role'] = Role.ASSOCIATE

        return super().create(validated_data)

    def update(self, instance: User, validated_data):
        if User.objects.filter(email=validated_data['email']).exists() and validated_data['email'] != instance.email:
            raise serializers.ValidationError(
                {
                    'email': 'This field must be unique'
                }
            )
        return super().update(instance, validated_data)

    class Meta(UserCreateSerializer.Meta):
        fields = ('id', 'username', 'password', 'email', 'first_name', 'last_name',
                  'role', 'phone_number')
        extra_kwargs = {
            'password': {
                'write_only': True,
                'required': False
            }
        }
