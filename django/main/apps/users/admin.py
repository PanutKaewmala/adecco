from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin

from main.apps.users import models
from main.apps.users.models import User


class UserAdmin(BaseUserAdmin):
    pass


admin.site.register(User, UserAdmin)


@admin.register(models.EmployeeProject)
class EmployeeProjectAdmin(admin.ModelAdmin):
    pass


@admin.register(models.Employee)
class EmployeeAdmin(admin.ModelAdmin):
    pass
