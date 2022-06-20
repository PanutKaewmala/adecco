from drf_writable_nested import UniqueFieldsMixin
from rest_framework import serializers
from rest_framework.exceptions import ValidationError

from main.apps.common.serializers import FlexedWritableNestedModelSerializer
from main.apps.managements.models import Project
from main.apps.managements.serializers.projects import ProjectCommonSerializer, ProjectCommonWithDateSerializer
from main.apps.managements.serializers.working_hours import WorkingHourCommonSerializer, \
    WorkingHourWithLeadTimeSerializer
from main.apps.managements.serializers.workplaces import WorkPlaceCommonSerializer
from main.apps.merchandizers.models import Shop
from main.apps.merchandizers.serializers.merchandizers import MerchandizerRetrieveSerializer
from main.apps.merchandizers.serializers.shops import ShopCommonSerializer
from main.apps.rosters.choices import DayStatusType
from main.apps.users.choices import DailyTaskType, TaskType
from main.apps.users.models import Employee, EmployeeProject
from main.apps.users.serializers.users import UserCommonSerializer, UserCommonDetailSerializer, \
    UserAssociateSerializer


class EmployeeProjectRetrieveSerializer(FlexedWritableNestedModelSerializer):
    user = UserCommonSerializer(source='employee.user', default=None)
    project = ProjectCommonSerializer(read_only=True)
    workplaces = WorkPlaceCommonSerializer(many=True, read_only=True)

    class Meta:
        model = EmployeeProject
        fields = '__all__'
        expandable_fields = {
            'merchandizers': (MerchandizerRetrieveSerializer, {'many': True}),
        }


class EmployeeProjectWriteSerializer(UniqueFieldsMixin, serializers.ModelSerializer):
    class Meta:
        model = EmployeeProject
        fields = '__all__'


class EmployeeProjectCommonSerializer(EmployeeProjectRetrieveSerializer):
    class Meta(EmployeeProjectRetrieveSerializer.Meta):
        fields = ('id', 'project', 'workplaces', 'supervisor', 'start_date', 'resign_date')


class EmployeeProjectLoginCommonSerializer(EmployeeProjectRetrieveSerializer):
    class Meta(EmployeeProjectRetrieveSerializer.Meta):
        fields = ('id', 'project')


class EmployeeProjectListSerializer(EmployeeProjectRetrieveSerializer):
    project = serializers.PrimaryKeyRelatedField(queryset=Project.objects.all())
    shops = serializers.SerializerMethodField(default=None)

    class Meta(EmployeeProjectRetrieveSerializer.Meta):
        fields = ('id', 'project', 'osa_oss', 'sku', 'price_tracking', 'sales_report', 'user', 'shops')

    @staticmethod
    def get_shops(instance: EmployeeProject):
        shops = Shop.objects.filter(merchandizers__employee_project=instance)
        return ShopCommonSerializer(shops, many=True).data


class EmployeeRetrieveSerializer(serializers.ModelSerializer):
    user = UserCommonDetailSerializer()
    employee_projects = EmployeeProjectCommonSerializer(many=True, read_only=True)

    class Meta:
        model = Employee
        fields = '__all__'


class EmployeeProjectDetailProjectSerializer(EmployeeProjectRetrieveSerializer):
    project = ProjectCommonWithDateSerializer(read_only=True)

    class Meta(EmployeeProjectRetrieveSerializer.Meta):
        fields = ('id', 'project', 'start_date', 'resign_date')


class EmployeeLoginSerializer(serializers.ModelSerializer):
    employee_projects = EmployeeProjectLoginCommonSerializer(many=True, read_only=True)

    class Meta:
        model = Employee
        fields = ('id', 'position', 'employee_projects')


class EmployeeListSerializer(EmployeeRetrieveSerializer):
    user = UserCommonSerializer()

    class Meta(EmployeeRetrieveSerializer.Meta):
        fields = ('id', 'user', 'position', 'nick_name')


class EmployeeWriteSerializer(FlexedWritableNestedModelSerializer, EmployeeRetrieveSerializer):
    user = UserAssociateSerializer()
    employee_projects = EmployeeProjectWriteSerializer(many=True)


class EmployeeTitleInLeaveQuotaSettingPageSerializer(EmployeeRetrieveSerializer):
    class Meta(EmployeeRetrieveSerializer.Meta):
        fields = ('id', 'position', 'nick_name')


class EmployeeProjectRosterCommonSerializer(serializers.ModelSerializer):
    employee_project_id = serializers.IntegerField(source='id')
    full_name = serializers.CharField(source='employee.user.full_name')

    class Meta:
        model = EmployeeProject
        fields = ('employee_project_id', 'full_name')


class EmployeeClientParamsSerializer(serializers.Serializer):
    date = serializers.DateField(required=False)
    start_date = serializers.DateField(required=False)
    end_date = serializers.DateField(required=False)
    project = serializers.PrimaryKeyRelatedField(queryset=Project.objects.all(), required=True)
    single_date = serializers.BooleanField(default=False)

    def validate(self, attrs):
        if attrs.get('single_date', False) and not attrs.get('date'):
            raise ValidationError(
                {
                    'detail': 'Single date require date'
                }
            )
        if not attrs.get('single_date', False) and not all([attrs.get('start_date'), attrs.get('end_date')]):
            raise ValidationError(
                {
                    'detail': 'Range date require start_date and end_date'
                }
            )

        return attrs


class EmployeeClientDateDataSerializer(serializers.Serializer):
    date = serializers.DateField()
    day_name = serializers.CharField()
    type = serializers.ChoiceField(choices=DayStatusType.choices, default=None)
    workplaces = WorkPlaceCommonSerializer(many=True, default=[])
    working_hour = serializers.SerializerMethodField()

    @staticmethod
    def get_working_hour(attrs):
        context = {'date': attrs.get('date')}
        return WorkingHourCommonSerializer(attrs.get('working_hour'), context=context).data


class LocationParamsSerializer(serializers.Serializer):
    date = serializers.DateField(required=True)
    project = serializers.PrimaryKeyRelatedField(queryset=Project.objects.all(), required=True)


class LocationActivity(serializers.Serializer):
    check_in = serializers.DateTimeField(source='check_in.date_time', default=None)
    check_out = serializers.DateTimeField(source='check_out.date_time', default=None)
    pair_id = serializers.IntegerField(source='check_in.pair_id.id', default=None)


class LocationSerializer(serializers.Serializer):
    workplace = WorkPlaceCommonSerializer()
    project = serializers.PrimaryKeyRelatedField(queryset=Project.objects.all())
    date = serializers.DateField(format='%d %b %Y')
    working_hour = serializers.SerializerMethodField(default=None)
    from_roster = serializers.BooleanField()
    activity = LocationActivity()

    @staticmethod
    def get_working_hour(attrs):
        context = {'date': attrs.get('date')}
        serializers_data = WorkingHourWithLeadTimeSerializer(attrs.get('working_hour'), context=context).data
        return serializers_data if serializers_data else None


class DailyTaskSerialzier(LocationParamsSerializer):
    latitude = serializers.DecimalField(max_digits=22, decimal_places=16, required=True)
    longitude = serializers.DecimalField(max_digits=22, decimal_places=16, required=True)


class TaskSerialzier(serializers.Serializer):
    name = serializers.CharField()
    type = serializers.ChoiceField(TaskType.choices)
    extra_type = serializers.CharField(default=None, required=False)
    date_time = serializers.DateTimeField(source='date_time.date_time', default=None)


class DailyTaskSerializer(serializers.Serializer):
    name = serializers.CharField()
    type = serializers.ChoiceField(choices=DailyTaskType.choices)
    inside = serializers.BooleanField(default=False)
    daily_task_from = serializers.CharField(default=None)
    tasks = TaskSerialzier(many=True, default=[])


class OTQuotaSerializer(serializers.ModelSerializer):
    ot_quota = serializers.CharField(source='project.ot_quota_time')

    class Meta:
        model = EmployeeProject
        fields = ('ot_quota', 'ot_quota_used')
