import factory
from main.apps.users.models import User, Employee


class UserFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = User
        django_get_or_create = ('username',)

    first_name = factory.Faker('first_name')
    last_name = factory.Faker('last_name')
    username = factory.Faker('user_name')
    email = factory.Faker('email', domain='codium.co')


class EmployeeFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Employee

    user = factory.SubFactory(UserFactory)

