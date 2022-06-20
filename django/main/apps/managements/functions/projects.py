from rest_framework.exceptions import ValidationError

from main.apps.users.models import User, EmployeeProject, Employee


def get_employee_project_from_user(user: User, project_id):
    try:
        return user.employee.employee_projects.get(project=project_id)
    except EmployeeProject.DoesNotExist:
        raise ValidationError(
            {
                'detail': f'Associate not found project {project_id}'
            }
        )
    except Employee.DoesNotExist:
        raise ValidationError(
            {
                'detail': f'User not found associate data in project {project_id}'
            }
        )


def get_holiday_of_working_hour(day_field: bool) -> str:
    return 'day_off' if day_field else 'holiday'
