from django.db.models import QuerySet, Q
from rest_framework.exceptions import ValidationError

from main.apps.managements.models import Project


def filter_project_and_client(queryset, name, value) -> QuerySet:
    if value:
        try:
            project = Project.objects.get(id=value)
        except Project.DoesNotExist:
            raise ValidationError({'detail': 'Project does not exist'})
        q = Q(client=project.client) | Q(project=value)
        queryset = queryset.filter(q)
    return queryset
