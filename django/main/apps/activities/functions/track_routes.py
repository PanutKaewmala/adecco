from main.apps.activities.choices import ActivityType
from main.apps.activities.models import Activity


def get_check_in_check_out_detail(check_in: Activity):
    check_out = check_in.check_out
    return {
        'id': check_in.id,
        'type': ActivityType.CHECK_OUT if check_out else ActivityType.CHECK_IN,
        'location_name': check_in.location_name,
        'location_address': check_in.location_address,
        'check_in': check_in.date_time,
        'check_out': check_out.date_time if check_out else '-'
    }


def get_track_route_detail(track_route: Activity):
    return {
        'id': track_route.id,
        'activity': track_route,
        'type': track_route.type,
        'location_name': track_route.location_name,
        'location_address': track_route.location_address,
        'time_tracking': track_route.date_time,
        'remark': track_route.remark,
        'picture': track_route.picture,
        'latitude': track_route.latitude,
        'longitude': track_route.longitude,
        'pin_point_id': track_route.pin_point.id if track_route.type == ActivityType.PIN_POINT else None
    }
