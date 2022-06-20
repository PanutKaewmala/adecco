import dropdown
from django.db.models import Q
from rest_framework.exceptions import ValidationError

from main.apps.activities.models import LeaveType, LeaveTypeSetting, AdditionalType
from main.apps.managements.models import Project


@dropdown.register
def leave_setting(query='', **kwargs):  # pylint: disable=unused-argument
    return dropdown.from_model(LeaveTypeSetting, label_field='name')


@dropdown.register
def leave_name(query='', **kwargs):  # pylint: disable=unused-argument
    project = kwargs.get('project')
    client = kwargs.get('client')
    q = Q()

    if project:
        try:
            project = Project.objects.get(id=project)
            client_id = project.client.id
            q &= Q(project_id=project) | Q(client_id=client_id, project_id=None)
        except Project.DoesNotExist:
            raise ValidationError({'detail': 'Project does not exist'})

    if client:
        q &= Q(client_id=client)
    return dropdown.from_model(LeaveType, label_field='name', q_filter=q)


@dropdown.register
def additional_type(query='', **kwargs):  # pylint: disable=unused-argument
    project = kwargs.get('project')
    q = Q()
    if project:
        q &= Q(project_id=project)
    return dropdown.from_model(AdditionalType, label_field='detail', q_filter=q)
