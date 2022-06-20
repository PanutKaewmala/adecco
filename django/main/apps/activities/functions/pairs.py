import typing

from rest_framework.exceptions import ValidationError

from main.apps.activities.choices import ActivityType
from main.apps.activities.models import CheckInOutPair, Activity


def init_check_in_out_pair(check_in: Activity):
    CheckInOutPair(
        check_in=check_in
    ).save()


def set_check_out_to_pair(instance: Activity, request) -> typing.NoReturn:
    pair_id = request.data.get('pair_id')
    if instance.type == ActivityType.CHECK_OUT:
        try:
            pair = CheckInOutPair.objects.get(id=pair_id)
        except CheckInOutPair.DoesNotExist:
            raise ValidationError({'detail': 'pair id not found'})

        pair.check_out = instance
        pair.save(update_fields=['check_out'])
