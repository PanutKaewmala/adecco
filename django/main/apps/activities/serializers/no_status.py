import copy
import typing

from rest_framework import serializers

from main.apps.activities.choices import ActivityType
from main.apps.activities.models import Activity
from main.apps.managements.serializers.working_hours import WorkingHourCommonNameSerializer
from main.apps.managements.serializers.workplaces import WorkPlaceCommonSerializer
from main.apps.users.models import User
from main.apps.users.serializers.employees import LocationParamsSerializer
from main.apps.users.serializers.users import UserCommonSerializer, UserCommonDetailSerializer


class ActivityAlreadyExistsSerializer(serializers.ModelSerializer):
    working_hour = serializers.CharField(source='working_hour.name', default=None)
    pair_id = serializers.SerializerMethodField()

    class Meta:
        model = Activity
        fields = ('workplace', 'type', 'working_hour', 'pair_id')

    @staticmethod
    def get_pair_id(instance: Activity):
        if instance.type == ActivityType.CHECK_IN:
            return instance.check_in_pair.id
        return None


class NoStatusDashboardSerializer(serializers.Serializer):
    user = UserCommonSerializer()
    date = serializers.DateField(format='%d %b %Y')
    workplaces = WorkPlaceCommonSerializer(many=True)
    working_hour = WorkingHourCommonNameSerializer(many=True)


class NoStatusDetailParamsSerializer(LocationParamsSerializer):
    user = serializers.PrimaryKeyRelatedField(queryset=User.objects.all(), required=True)


class TypeNoStatusSerializer(serializers.Serializer):
    check_in = serializers.BooleanField(default=True)
    check_out = serializers.BooleanField(default=True)
    pair_id = serializers.IntegerField(default=None)


class NoStatusDetailDataSerializer(serializers.Serializer):
    workplace = serializers.CharField(source='workplace.name', default=None)
    working_hour = serializers.CharField(source='working_hour.name', default=None)
    type_no_status = TypeNoStatusSerializer()


class NoStatusDetailSerializer(serializers.Serializer):
    user = UserCommonDetailSerializer()
    supervisor = serializers.SerializerMethodField()
    workplaces = serializers.SerializerMethodField()
    activities = serializers.SerializerMethodField()

    def get_activities(self, data):
        return NoStatusDetailDataSerializer(data.get('activities'), many=True, default=[], context=self.context).data

    @staticmethod
    def get_workplaces(data):
        return [workplace.name for workplace in data.get('workplaces')]

    @staticmethod
    def get_supervisor(instance):
        employee_project = instance.get('employee_project')
        if employee_project:
            return UserCommonDetailSerializer(
                instance=employee_project.supervisor
            ).data
        return {}

    def to_representation(self, instance):
        def map_no_status_by_workplaces(no_status_list: list) -> typing.Dict[str, typing.Dict]:
            user = self.context.get('user')
            request = self.context.get('request')
            results = {}
            for no_status in no_status_list:
                workplace = no_status['workplace']
                if workplace not in results:
                    results.setdefault(workplace, {})
                template_no_status = {
                    'workplace': no_status.get('workplace'),
                    'working_hour': no_status.get('working_hour'),
                    'type': None,
                    'extra_type': None,
                    'date_time': None,
                    'location_name': None,
                    'location_address': None,
                    'latitude': None,
                    'longitude': None,
                    'picture': None,
                    'reason_for_adjust_time': None,
                    'reason_for_adjust_status': None,
                    'remark': None,
                    'in_radius': None,
                    'pair_id': None,
                    'user': user.id,
                    'project': request.query_params.get('project'),
                }
                if no_status['type_no_status']['check_in']:
                    results[workplace]['check_in'] = copy.deepcopy(template_no_status)
                    results[workplace]['check_in']['type'] = 'check_in'
                if no_status['type_no_status']['check_out']:
                    results[workplace]['check_out'] = copy.deepcopy(template_no_status)
                    results[workplace]['check_out']['type'] = 'check_out'
                    results[workplace]['check_out']['pair_id'] = no_status['type_no_status']['pair_id']
            return results

        ret = super().to_representation(instance)
        activities = ret.get('activities', [])
        ret['activities'] = map_no_status_by_workplaces(activities)
        return ret
