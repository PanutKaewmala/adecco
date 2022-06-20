from django.db.models import Q

import dropdown
from main.apps.users.models import User, Employee, Manager, EmployeeProject


@dropdown.register
def user(query='', **kwargs):
    q = Q()
    role = kwargs.get('role', None)
    if query:
        q &= Q(first_name__icontains=query) | Q(last_name__icontains=query)
    if role:
        q &= Q(role=role)
    return dropdown.from_model(User, q_filter=q, context_fields=['full_name'])


@dropdown.register
def employee(query='', **kwargs):
    q = Q()
    project_id = kwargs.get('project', None)
    if query:
        q &= Q(user__first_name__icontains=query) | Q(user__last_name__icontains=query)
    if project_id:
        q &= Q(employee_projects__project_id=project_id)
    return dropdown.from_model(Employee, q_filter=q, context_fields=['user.full_name', 'user.id'])


@dropdown.register
def employee_project(query='', **kwargs):
    q = Q()
    project_id = kwargs.get('project', None)
    if query:
        q &= Q(employee__user__first_name__icontains=query) | Q(employee__user__last_name__icontains=query)
    if project_id:
        q &= Q(project_id=project_id)
    return dropdown.from_model(EmployeeProject, q_filter=q, context_fields=['employee.user.full_name'])


@dropdown.register
def manager(query='', **kwargs):
    q = Q()
    project_id = kwargs.get('project', None)
    if query:
        q &= Q(user__first_name__icontains=query) | Q(user__last_name__icontains=query)
    if project_id:
        q &= Q(projects__project_id=project_id)
    return dropdown.from_model(Manager, q_filter=q, context_fields=['user.full_name', 'user.id'])
