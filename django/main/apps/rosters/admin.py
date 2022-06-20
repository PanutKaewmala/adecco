from django.contrib import admin

from main.apps.rosters import models


@admin.register(models.Roster)
class RosterAdmin(admin.ModelAdmin):
    pass


@admin.register(models.AdjustRequest)
class AdjustRequestAdmin(admin.ModelAdmin):
    pass
