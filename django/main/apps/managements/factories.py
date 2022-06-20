import factory

from main.apps.managements.models import Client, Project


class ClientFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Client

    name = factory.Faker('name')
    branch = factory.Faker('name')
    contact_person = factory.Faker('name')
    url = factory.Faker('name')


class ProjectFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Project

    name = factory.Faker('name')
    description = factory.Faker('name')
    country = factory.Faker('name')
    city = factory.Faker('name')
