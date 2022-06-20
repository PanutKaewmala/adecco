from django.db.models import QuerySet, Value, Q
from django.db.models.functions import Concat
from rest_framework import serializers

from main.apps.users.models import User


def filter_user_full_name(queryset: QuerySet, name, value) -> QuerySet:
    if value:
        queryset = queryset.annotate(
            user_full_name=Concat('first_name', Value(' '), 'last_name')
        ).filter(user_full_name__icontains=value)
    return queryset


def filter_master_data(queryset: QuerySet, name, value) -> QuerySet:
    if value:
        user_id = int(value) if value.isnumeric() else 0
        queryset = queryset.annotate(
            user_full_name=Concat('first_name', Value(' '), 'last_name')
        ).filter(Q(user_full_name__icontains=value) | Q(id=user_id))

    return queryset


def set_username(validated_data):
    validated_data['username'] = f"{validated_data.get('first_name').lower()}." \
                                 f"{validated_data.get('last_name').lower()}"
    if User.objects.filter(username=validated_data['username']).exists():
        raise serializers.ValidationError(
            {
                'detail': f'username must unique. {validated_data["username"]} already in system'
            }
        )
    return validated_data
