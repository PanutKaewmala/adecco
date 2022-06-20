from django.db.models.signals import post_save
from django.dispatch import receiver

from main.apps.managements.models import Project


@receiver(post_save, sender=Project)
def init_setting_from_client(sender, instance: Project, created, **kwargs):
    if created:
        instance.ot_quota = instance.client.ot_quota
        instance.lead_time_in_before = instance.client.lead_time_in_before
        instance.lead_time_in_after = instance.client.lead_time_in_after
        instance.lead_time_out_before = instance.client.lead_time_out_before
        instance.lead_time_out_after = instance.client.lead_time_out_after
        instance.business_calendar_type = instance.client.business_calendar_type
        instance.save(update_fields=['ot_quota', 'lead_time_in_before', 'lead_time_in_after',
                                     'lead_time_out_before', 'lead_time_out_after',
                                     'business_calendar_type'])
