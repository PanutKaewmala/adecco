from django.db.models import QuerySet

from main.apps.managements.models import WorkPlace, WorkingHour


def replace_empty_list_to_none(dict_data):
    return {
        k: v if bool(v) else None
        for k, v in dict_data.items()
    }


def schedule_map_data_to_dict(date_type: str,
                              workplaces: QuerySet[WorkPlace] or list,
                              working_hour: WorkingHour or None):
    return {
        'type': date_type,
        'workplaces': workplaces,
        'working_hour': working_hour,
    }
