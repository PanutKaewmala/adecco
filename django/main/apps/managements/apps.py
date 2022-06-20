from django.apps import AppConfig


class ManagementsConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'main.apps.managements'

    def ready(self):
        import main.apps.managements.signals  # pylint: disable=import-outside-toplevel, unused-import
