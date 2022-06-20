from django.contrib import admin

from main.apps.activities import models


@admin.register(models.DailyTask)
class DailyTaskAdmin(admin.ModelAdmin):
    pass


@admin.register(models.Place)
class PlaceAdmin(admin.ModelAdmin):
    pass


@admin.register(models.Activity)
class ActivityAdmin(admin.ModelAdmin):
    pass


@admin.register(models.LeaveRequest)
class LeaveRequestAdmin(admin.ModelAdmin):
    pass


@admin.register(models.LeaveQuota)
class LeaveQuotaAdmin(admin.ModelAdmin):
    pass


@admin.register(models.UploadAttachment)
class UploadAttachmentAdmin(admin.ModelAdmin):
    pass


@admin.register(models.LeaveType)
class LeaveAdmin(admin.ModelAdmin):
    pass


@admin.register(models.LeaveTypeSetting)
class LeaveTypeSettingAdmin(admin.ModelAdmin):
    pass


@admin.register(models.OTRequest)
class OTRequestAdmin(admin.ModelAdmin):
    pass


@admin.register(models.PinPoint)
class PinPointAdmin(admin.ModelAdmin):
    pass


@admin.register(models.PinPointAnswer)
class PinPointAnswerAdmin(admin.ModelAdmin):
    pass


@admin.register(models.AdditionalType)
class AdditionalTypeAdmin(admin.ModelAdmin):
    pass
