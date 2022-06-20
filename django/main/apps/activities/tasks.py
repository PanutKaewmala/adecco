from django.utils import timezone

from main.apps.activities.choices import ActivityType
from main.apps.activities.functions.activity_operator import get_list_user_data_forget_check_out
from main.apps.activities.models import Activity
from main.apps.users.models import User
from main.celery import app


# @app.on_after_finalize.connect
# def setup_periodic_tasks(sender, **kwargs):
#     sender.add_periodic_task(
#         # run every midnight
#         crontab(minute='0', hour='0', day_of_week='*', day_of_month='*', month_of_year='*'),
#         activity_missing_check_out.s()
#     )


@app.task
def activity_missing_check_out():
    date_time = timezone.now() - timezone.timedelta(days=1)
    date_time_check_out = date_time.replace(
        hour=23, minute=59
    )
    list_user_data_forget_check_out = get_list_user_data_forget_check_out(date_time.date())

    activity_check_out_list = []
    for data in list_user_data_forget_check_out:
        user = User.objects.get(id=data['user'])
        activity_check_out_list.append(
            Activity(
                user=user,
                type=ActivityType.CHECK_OUT,
                date_time=date_time_check_out,
                latitude=0,
                longitude=0,
                remark='auto check-out by system',
                in_radius=False,
                project_id=data['project'],
                workplace_id=data['workplace']
            )
        )

    Activity.objects.bulk_create(activity_check_out_list)
