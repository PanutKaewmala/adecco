from django.db.models import Q
from rest_framework import serializers
from rest_framework.exceptions import ValidationError

from main.apps.activities.models import DailyTask, Place, LeaveQuota, LeaveType
from main.apps.common.utils import calculate_year_month_day_in_total
from main.apps.managements.models import Project
from main.apps.users.serializers.employees import EmployeeTitleInLeaveQuotaSettingPageSerializer
from main.apps.users.serializers.users import UserCommonSerializer


class PlaceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Place
        fields = '__all__'


class DailyTasksSerializer(serializers.ModelSerializer):
    place = PlaceSerializer()

    class Meta:
        model = DailyTask
        fields = '__all__'


class LeaveQuotaSerializer(serializers.ModelSerializer):
    class Meta:
        model = LeaveQuota
        fields = ['user', 'type', 'total', 'project']
        extra_kwargs = {
            'user': {'write_only': True},
            'total': {'required': True}
        }

    def validate(self, attrs):
        user = attrs.get('user', None)
        project = attrs.get('project', None)
        if user and project and not user.employee.projects.filter(id=project.id).exists():
            raise ValidationError({'project': 'This user not in the project'})
        return super().validate(attrs)


class LeaveQuotaReadSerializer(LeaveQuotaSerializer):
    type = serializers.CharField()
    project = serializers.CharField()

    class Meta(LeaveQuotaSerializer.Meta):
        fields = ('id', 'type', 'total', 'used', 'remained', 'project')


class LeaveQuotaTotalSerializer(serializers.ModelSerializer):
    id = serializers.IntegerField(required=False)
    type = serializers.CharField(read_only=True)
    type_id = serializers.IntegerField()
    project_id = serializers.IntegerField()

    class Meta:
        model = LeaveQuota
        fields = ('id', 'type', 'type_id', 'total', 'project_id')


class LeaveQuotaUpdateSerializer(serializers.ModelSerializer):
    leave_quotas = LeaveQuotaTotalSerializer(many=True)

    class Meta:
        model = LeaveQuota
        fields = ('leave_quotas',)


class LeaveQuotaDashboardSerializer(UserCommonSerializer):
    leave_quotas = LeaveQuotaTotalSerializer(many=True)
    year_total = serializers.DateField(read_only=True, source='start_date')
    employee = EmployeeTitleInLeaveQuotaSettingPageSerializer()

    class Meta(UserCommonSerializer.Meta):
        fields = (*UserCommonSerializer.Meta.fields, 'employee', 'leave_quotas', 'year_total',)

    def __init__(self, *args, **kwargs):
        self.project = kwargs.pop('project', None)
        self.leave_types = None
        if self.project:
            try:
                project = Project.objects.get(id=self.project)
                client_id = project.client_id
                self.leave_types = LeaveType.objects.filter(
                    Q(project_id=self.project) |
                    Q(client_id=client_id, project_id=None)
                ).order_by('id')
            except Project.DoesNotExist:
                raise ValidationError({'detail': 'Project does not exist'})
        super().__init__(*args, **kwargs)

    def map_leave_quotas_to_show_all_leave_types(self, leave_quotas_list) -> list:
        results = []
        leave_type_ids = [leave_quota.get('type_id') for leave_quota in leave_quotas_list]

        for leave_type in self.leave_types:
            if leave_type.id not in leave_type_ids:
                result_list = {
                    'type': leave_type.name,
                    'type_id': leave_type.id,
                    'total': 0,
                    'project_id': self.project,
                }
                results.append(result_list)
            else:
                results.append(leave_quotas_list[leave_type_ids.index(leave_type.id)])
        return results

    def to_representation(self, instance):
        ret = super().to_representation(instance)
        start_date = ret.get('year_total')
        ret['year_total'] = calculate_year_month_day_in_total(start_date)

        leave_quotas = ret.get('leave_quotas', [])
        ret['leave_quotas'] = self.map_leave_quotas_to_show_all_leave_types(leave_quotas)
        return ret
