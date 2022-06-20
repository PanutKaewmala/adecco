import dropdown
from django.db.models import Q

from main.apps.managements.models import Client, Project, WorkPlace, PinPointType


@dropdown.register
def client(query='', **kwargs):  # pylint: disable=unused-argument
    q = Q()
    if query:
        q &= Q(name__icontains=query)
    return dropdown.from_model(Client, label_field='name', q_filter=q)


@dropdown.register
def project(query='', **kwargs):
    user = kwargs['request'].user
    client_id = kwargs.get('client', None)
    employee = getattr(user, 'employee', None)
    q = Q()
    if query:
        q &= Q(name__icontains=query)
    if client_id:
        q &= Q(client=client_id)
    if employee:
        q &= Q(employee_projects__employee_id=employee.id)
    return dropdown.from_model(Project, label_field='name', q_filter=q)


@dropdown.register
def workplace(query='', **kwargs):
    project_id = kwargs.get('project', None)
    employee_project_id = kwargs.get('employee_project', None)
    q = Q()
    if query:
        q &= Q(name__icontains=query)
    if project_id:
        q &= Q(project=project_id)
    if employee_project_id:
        q &= Q(employee_projects__id=employee_project_id)
    return dropdown.from_model(WorkPlace, label_field='name', q_filter=q)


@dropdown.register
def pin_point_type(query='', **kwargs):
    employee_project_id = kwargs.get('employee_project', None)
    q = Q()
    if query:
        q &= Q(name__icontains=query)
    if employee_project_id:
        q &= Q(employee_projects__id=employee_project_id)
    return dropdown.from_model(PinPointType, label_field='name', q_filter=q)
