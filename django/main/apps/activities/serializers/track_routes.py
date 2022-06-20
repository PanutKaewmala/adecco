from django.db.models import Q
from rest_framework import serializers
from rest_framework.exceptions import ValidationError

from main.apps.activities.choices import ActivityType
from main.apps.activities.functions.track_routes import get_check_in_check_out_detail, get_track_route_detail
from main.apps.activities.models import Activity
from main.apps.common.utils import convert_string_to_date
from main.apps.managements.models import WorkPlace
from main.apps.users.models import EmployeeProject
from main.apps.users.serializers.users import UserCommonDetailSerializer


class RouteSerializer(serializers.Serializer):
    location_name = serializers.CharField()
    type = serializers.CharField()


class CheckInCheckOutDetailSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    type = serializers.CharField()
    location_name = serializers.CharField()
    location_address = serializers.CharField()
    check_in = serializers.DateTimeField(required=False)
    check_out = serializers.DateTimeField(required=False)


class TrackRouteDetailSerializer(CheckInCheckOutDetailSerializer):
    id = serializers.IntegerField()
    pin_point_id = serializers.IntegerField()
    time_tracking = serializers.DateTimeField()
    picture = serializers.ImageField()
    remark = serializers.CharField()
    latitude = serializers.CharField()
    longitude = serializers.CharField()


class TrackRouteRetrieveSerializer(serializers.ModelSerializer):
    user = UserCommonDetailSerializer()
    supervisor = serializers.SerializerMethodField()
    routes = serializers.SerializerMethodField()
    workplaces = serializers.SerializerMethodField()
    roster = serializers.SerializerMethodField()

    class Meta:
        model = Activity
        fields = ('id', 'user', 'supervisor', 'workplaces', 'routes', 'roster')

    def __init__(self, instance=None, **kwargs):
        super().__init__(instance, **kwargs)
        self.request = self.context.get('request')
        if self.request:
            date = self.request.query_params.get('date')
            if isinstance(instance, list):
                self.date = convert_string_to_date(date) if date else None
            else:
                self.date = instance.date_time
            date_range_gte = self.request.query_params.get('start_date')
            date_range_lte = self.request.query_params.get('end_date')
            self.date_range_gte = convert_string_to_date(date_range_gte) if date_range_gte else None
            self.date_range_lte = convert_string_to_date(date_range_lte) if date_range_lte else None
            self.filter_date_range = Q(date_time__date__gte=self.date_range_gte, date_time__date__lte=self.date_range_lte)

    def get_workplaces(self, instance: Activity):
        activities = Activity.objects.filter(type=ActivityType.CHECK_IN, user=instance.user, project=instance.project)
        if self.date:
            activities = activities.filter(date_time__date=self.date)
        else:
            activities = activities.filter(self.filter_date_range)
        return activities.values_list('workplace__name', flat=True)

    def get_routes(self, instance: Activity):
        activities = Activity.objects.exclude(type=ActivityType.CHECK_OUT) \
            .filter(user=instance.user, project=instance.project)
        if self.date:
            activities = activities.filter(date_time__date=self.date)
        else:
            activities = activities.filter(self.filter_date_range)
        data = []
        for activity in activities.order_by('id'):
            if activity.type == ActivityType.CHECK_IN:
                data.append(
                    CheckInCheckOutDetailSerializer(get_check_in_check_out_detail(activity)).data
                )
            else:
                data.append(
                    TrackRouteDetailSerializer(get_track_route_detail(activity), context=self.context).data
                )
        return data

    def get_roster(self, instance: Activity):
        check_in = Activity.objects.filter(type=ActivityType.CHECK_IN, user=instance.user,
                                           project=instance.project, working_hour__isnull=False)
        if self.date:
            check_in = check_in.filter(date_time__date=self.date).first()
        else:
            check_in = check_in.filter(self.filter_date_range).first()
        return check_in.working_hour.name if check_in else '-'

    def get_supervisor(self, instance: Activity):
        try:
            employee_project = instance.user.employee.employee_projects.get(project=instance.project)
        except EmployeeProject.DoesNotExist:
            raise ValidationError({'detail': 'Employee project not found'})
        if employee_project:
            return UserCommonDetailSerializer(
                instance=employee_project.supervisor
            ).data
        return {}


class TrackRouteSerializer(TrackRouteRetrieveSerializer):
    roster = serializers.SerializerMethodField()

    class Meta(TrackRouteRetrieveSerializer.Meta):
        fields = ('id', 'user', 'date_time', 'roster', 'routes')

    def get_routes(self, instance: Activity):
        activities = Activity.objects.exclude(type=ActivityType.CHECK_OUT) \
            .filter(user=instance.user, project=instance.project)
        if self.date:
            activities = activities.filter(date_time__date=self.date)
        else:
            activities = activities.filter(self.filter_date_range)
        return RouteSerializer(activities.order_by('id').values('location_name', 'type'), many=True).data


class InsideWorkPlaceParameterSerializer(serializers.Serializer):
    latitude = serializers.DecimalField(max_digits=22, decimal_places=16, required=True)
    longitude = serializers.DecimalField(max_digits=22, decimal_places=16, required=True)
    workplace = serializers.PrimaryKeyRelatedField(queryset=WorkPlace.objects.all(), required=True)


class InsideWorkPlaceSerializer(serializers.Serializer):
    inside = serializers.BooleanField()
    workplace = serializers.CharField(source='workplace.name')
