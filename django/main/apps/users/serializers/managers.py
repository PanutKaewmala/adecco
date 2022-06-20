from rest_framework import serializers

from main.apps.common.serializers import FlexedWritableNestedModelSerializer
from main.apps.managements.models import Project
from main.apps.managements.serializers.projects import ProjectCommonSerializer
from main.apps.users.models import Manager, Employee, User
from main.apps.users.serializers.users import UserCommonManagerSerializer, UserManagerSerializer


class ManagerRetrieveSerializer(serializers.ModelSerializer):
    user = UserCommonManagerSerializer()
    projects = ProjectCommonSerializer(many=True, read_only=True)

    class Meta:
        model = Manager
        fields = '__all__'


class ManagerListSerializer(ManagerRetrieveSerializer):
    class Meta(ManagerRetrieveSerializer.Meta):
        fields = ('id', 'user', 'projects')


class ManagerWriteSerializer(FlexedWritableNestedModelSerializer, ManagerRetrieveSerializer):
    user = UserManagerSerializer(required=False)
    projects = serializers.PrimaryKeyRelatedField(queryset=Project.objects.all(), many=True)

    def create(self, validated_data):
        instance = super().create(validated_data)  # type: Manager
        request = self.context.get('request')
        user = request.data.get('user')
        Employee(
            user=instance.user,
            middle_name=user.get('middle_name')
        ).save()
        return instance


class ManagerAssignProjectSerializer(serializers.Serializer):
    user = serializers.PrimaryKeyRelatedField(queryset=User.objects.all())
    project = serializers.PrimaryKeyRelatedField(queryset=Project.objects.all())
