from django.urls import reverse
from rest_framework.test import APITestCase

from main.apps.managements.factories import ClientFactory, ProjectFactory
from main.apps.users.choices import Role
from main.apps.users.factories import UserFactory, EmployeeFactory
from main.apps.users.models import Employee


class ManagementTest(APITestCase):
    def setUp(self) -> None:
        self.user_admin = UserFactory(role=Role.SUPER_ADMIN)
        self.client.force_login(self.user_admin)
        self.client_url = reverse('api:clients-list')

        self.project_manager = EmployeeFactory()  # type: Employee

    def test_create_client(self):
        data = {
            'name': 'Test',
            'branch': 'Test branch name',
            'contact_person': 'Name',
            'contact_person_email': 'test@example.com',
            'contact_number': '0631234567',
            'project_manager': self.project_manager.user.id,
            'url': 'Test',
            'name_th': 'test',
        }
        response = self.client.post(
            path=self.client_url,
            data=data,
            format='json',
        )
        response_json = response.json()
        self.assertEqual(response.status_code, 201)
        self.assertEqual(response_json['name'], 'Test')

    def test_patch_client(self):
        client = ClientFactory()
        url = reverse('api:clients-detail', args=[client.id])
        data = {
            'name': 'Test Patch'
        }
        response = self.client.patch(url, data=data)
        response_json = response.json()
        self.assertEqual(response_json['name'], 'Test Patch')

    def test_create_project(self):
        pass

    def test_patch_project(self):
        pass

class ClientTest(APITestCase):
    def setUp(self) -> None:
        self.user_admin = ProjectFactory (role=Role.SUPER_ADMIN)
        self.client.force_login(self.user_admin)
        self.client_url = reverse('api:clients-list')
