from rest_framework import serializers

from main.apps.managements.models import WorkPlace


class WorkPlaceRetrieveSerializer(serializers.ModelSerializer):
    class Meta:
        model = WorkPlace
        fields = '__all__'


class WorkPlaceListSerializer(WorkPlaceRetrieveSerializer):
    class Meta(WorkPlaceRetrieveSerializer.Meta):
        fields = ('id', 'name', 'address', 'project')


class WorkPlaceCreateSerializer(WorkPlaceRetrieveSerializer):
    pass


class WorkPlaceCommonSerializer(serializers.ModelSerializer):
    class Meta:
        model = WorkPlace
        fields = ('id', 'name')
