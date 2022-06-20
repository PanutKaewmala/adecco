from django.contrib import admin

from main.apps.managements import models


@admin.register(models.Project)
class ProjectAdmin(admin.ModelAdmin):
    pass


@admin.register(models.Client)
class ClientAdmin(admin.ModelAdmin):
    pass


@admin.register(models.WorkPlace)
class WorkPlaceAdmin(admin.ModelAdmin):
    pass


@admin.register(models.PinPointType)
class PinPointTypeAdmin(admin.ModelAdmin):
    pass


@admin.register(models.PinPointQuestion)
class PinPointQuestionAdmin(admin.ModelAdmin):
    pass
