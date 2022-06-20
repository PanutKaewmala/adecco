from django.core.management import call_command
from django.core.management.base import BaseCommand
from django.db import transaction

from main.apps.activities.models import Place, DailyTask, LeaveTypeSetting, LeaveType, LeaveQuota
from main.apps.managements.models import Project, WorkPlace, Client
from main.apps.users.models import User, Employee, EmployeeProject


class Command(BaseCommand):
    """Command to initialize data on first run"""
    help = 'Create initial project data'

    def handle(self, *args, **options):  # pylint: disable=unused-argument
        with transaction.atomic():
            self._load_data()

    @staticmethod
    def create_user_to_db(list_staffs: list):
        for staff in list_staffs:
            if not User.objects.filter(username=staff.get('username')).exists():
                user = User.objects.create_user(
                    username=staff.get('username'),
                    email=staff.get('email'),
                    first_name=staff.get('firstname'),
                    last_name=staff.get('lastname'),
                    password=staff.get('password'),
                    role=staff.get('role'),
                    phone_number=staff.get('phone_number')
                )
                Employee(
                    user=user,
                    position=staff.get('position')
                ).save()

    @staticmethod
    def _load_data():
        adecco_staffs = [
            {
                'username': 'adecco',
                'password': 'adecco',
                'firstname': 'adecco',
                'lastname': 'adecco',
                'email': 'admin@adecco.com',
                'role': 'associate'
            },
            {
                'username': 'asapong.nakrachata-amorn',
                'password': 'Superadecco1234!',
                'firstname': 'Asapong',
                'lastname': 'Nakrachata-amorn',
                'email': 'asapong.n@adecco.com',
                'role': 'super_admin'
            },
            {
                'username': 'natkamon.nakaprom',
                'password': 'Adecco123!',
                'firstname': 'Natkamon',
                'lastname': 'Nakaprom',
                'email': 'natkamon.n@adecco.com',
                'role': 'project_manager'
            },
            {
                'username': 'joel.yim',
                'password': 'Adecco123!',
                'firstname': 'Joel',
                'lastname': 'Yim',
                'email': 'joel.y@adecco.com',
                'role': 'associate'
            },
            {
                'username': 'maya.nayak',
                'password': 'Adecco123!',
                'firstname': 'Maya',
                'lastname': 'Nayak',
                'role': 'super_admin'
            }

        ]

        codium_staffs = [
            {
                'username': 'codium',
                'password': 'codium',
                'firstname': 'codium',
                'lastname': 'codium',
                'email': 'admin@codium.co',
                'role': 'project_manager'
            },
            {
                'username': 'supitcha',
                'password': 'Codium123!',
                'firstname': 'Supitcha',
                'lastname': 'Buabang',
                'email': 'supitcha.b@codium.co',
                'role': 'associate',
                'phone_number': '0909629616'
            },
            {
                'username': 'kaeng',
                'password': 'Codium123!',
                'firstname': 'Pattarapong',
                'lastname': 'Tantikovie',
                'email': 'kaeng@codium.co',
                'role': 'associate',
                'phone_number': '0639600314'
            },
            {
                'username': 'k.r',
                'password': 'Codium123!',
                'firstname': 'Klaokamol',
                'lastname': 'Ruangtrakul',
                'email': 'klaokamol.r@codium.co',
                'role': 'associate',
                'phone_number': '0867979591'
            },
            {
                'username': 'atthana',
                'password': 'Codium123!',
                'firstname': 'Atthana',
                'lastname': 'Phiphat',
                'email': 'atthana.p@codium.co',
                'role': 'associate',
                'phone_number': '0851118477'
            },
            {
                'username': 'q',
                'password': 'Codium123!',
                'firstname': 'Q',
                'lastname': 'Phiphat',
                'email': 'q@codium.co',
                'role': 'associate',
                'phone_number': '0851118477'
            },
            {
                'username': 'waleerat.thamsupimol',
                'password': 'Codium123!',
                'firstname': 'Waleerat',
                'lastname': 'Thamsupimol',
                'email': 'waleerat.t@codium.co',
                'role': 'associate',
                'phone_number': '0890043552'
            },

            {
                'username': 'project_manager.test1',
                'password': 'Codium123!',
                'firstname': 'project_manager',
                'lastname': 'test1',
                'email': 'project_manager@example.com',
                'role': 'project_manager',
            },
            {
                'username': 'project_assignee.test1',
                'password': 'Codium123!',
                'firstname': 'project_assignee',
                'lastname': 'test1',
                'email': 'project_assignee@example.com',
                'role': 'project_assignee',
            },
            {
                'username': 'siriwun.sutawong',
                'password': 'Codium123!',
                'firstname': 'Siriwun',
                'lastname': 'Sutawong',
                'email': 'siriwun.s@codium.co',
                'role': 'associate',
                'position': 'QA'
            },
            {
                'username': 'nuttapong.pilasri',
                'password': 'Codium123!',
                'firstname': 'Nuttapong',
                'lastname': 'Pilasri',
                'email': 'nuttapong.p@codium.co',
                'role': 'associate',
                'position': 'QA'
            }
        ]

        # Create superuser
        if not User.objects.exists():
            User.objects.create_superuser(
                username='admin',
                email='admin@example.com',
                first_name='admin',
                last_name='admin',
                password='Codium123!',
                role='super_admin'
            )

        # Create user of CODIUM
        Command.create_user_to_db(codium_staffs)

        # Create user of ADECCO
        Command.create_user_to_db(adecco_staffs)

        if not Client.objects.exists():
            call_command('loaddata', 'clients')
        if not Place.objects.exists():
            call_command('loaddata', 'places')
        if not DailyTask.objects.exists():
            call_command('loaddata', 'daily_tasks')
        if not LeaveTypeSetting.objects.exists():
            call_command('loaddata', 'leave_types_setting')
        if not LeaveType.objects.exists():
            call_command('loaddata', 'leave_types')
        if not Project.objects.exists():
            call_command('loaddata', 'projects')
        if not LeaveQuota.objects.exists():
            call_command('loaddata', 'leave_quotas')
        if not WorkPlace.objects.exists():
            call_command('loaddata', 'workplaces')
        if not EmployeeProject.objects.exists():
            call_command('loaddata', 'employee_projects')
