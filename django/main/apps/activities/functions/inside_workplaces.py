from main.apps.activities.serializers.track_routes import InsideWorkPlaceSerializer
from main.apps.common.utils import is_inside_radius


def get_inside_workplace_data(validated_data):
    latitude = validated_data.get('latitude')
    longitude = validated_data.get('longitude')
    workplace = validated_data.get('workplace')
    inside = is_inside_radius(
        longitude1=longitude,
        latitude1=latitude,
        longitude2=workplace.longitude,
        latitude2=workplace.latitude,
        radius_meter=workplace.radius_meter
    )

    return InsideWorkPlaceSerializer({
        'inside': inside,
        'workplace': workplace
    }).data
