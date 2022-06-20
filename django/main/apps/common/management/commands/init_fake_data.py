from django.core.management.base import BaseCommand
from django.db import transaction

from main.apps.activities.choices import LeaveStatus, ActivityType
from main.apps.activities.models import LeaveType, LeaveQuota, LeaveRequest, Activity
from main.apps.managements.models import Project, Client, WorkPlace, WorkingHour
from main.apps.users.models import User


class Command(BaseCommand):
    """Command to initialize data on first run"""
    help = 'Create initial project data'

    def handle(self, *args, **options):  # pylint: disable=unused-argument
        with transaction.atomic():
            self._load_data()

    @staticmethod
    def _load_data():
        project_manager = User.objects.get(username='Natkamon.nakaprom')
        project_assignee = User.objects.get(username='Waleerat.thamsupimol')

        leave_type, _ = LeaveType.objects.get_or_create(name='Annual Leave')

        client, _ = Client.objects.get_or_create(
            name='Codium',
            branch='Main',
            contact_person='Olivia Dean',
            contact_number='192.168.1.2',
            project_manager=project_manager,
            project_assignee=project_assignee,
            url=''
        )

        project, _ = Project.objects.get_or_create(
            name='Adecco',
            description='Developer',
            start_date='2022-02-17',
            end_date='2022-06-25',
            country='Thailand',
            city='Krung Thep Maha Nakhon',
            project_manager=project_manager,
            client=client
        )

        workplace = [
            WorkPlace(
                name='Codium 01',
                address='codium 01',
                latitude=0,
                longitude=0,
                project=project
            ),
            WorkPlace(
                name='Codium 02',
                address='codium 02',
                latitude=0,
                longitude=0,
                project=project
            ),
        ]

        WorkPlace.objects.bulk_create(workplace)

        working_hours = [
            WorkingHour(
                project=project,
                start_time='09:30:00',
                end_time='18:30:00',
                saturday=True,
                sunday=True
            ),
            WorkingHour(
                project=project,
                start_time='12:30:00',
                end_time='20:00:00',
                sunday=True,
                monday=True
            )
        ]

        WorkingHour.objects.bulk_create(working_hours)

        LeaveQuota.objects.get_or_create(
            user=project_assignee,
            type=leave_type,
            total=10,
            used=0,
            remained=10,
            project=project,
        )

        LeaveRequest.objects.get_or_create(
            user=project_assignee,
            type=leave_type,
            start_date='2022-02-17',
            end_date='2022-02-18',
            start_time=None,
            end_time=None,
            all_day=True,
            title='Leave Krub',
            description='Pai Laew',
            status=LeaveStatus.PENDING,
        )

        Activity.objects.get_or_create(
            user=project_assignee,
            type=ActivityType.CHECK_IN,
            date_time='2022-02-17T09:30:00.000000',
            location_name='Codium',
            latitude='20',
            longitude='20',
            picture='',
            reason_for_adjust_time='',
            remark='',
        )

        Activity.objects.get_or_create(
            user=project_assignee,
            type=ActivityType.CHECK_OUT,
            date_time='2022-02-17T18:30:00.000000',
            location_name='Codium',
            latitude='20',
            longitude='20',
            picture='',
            reason_for_adjust_time='',
            remark='',
        )

        Activity.objects.get_or_create(
            user=project_assignee,
            type=ActivityType.CHECK_IN,
            date_time='2022-02-19T09:30:00.000000',
            location_name='Codium',
            latitude='20',
            longitude='20',
            picture='',
            reason_for_adjust_time='',
            remark='',
        )
