from main.apps.managements.choices import ProjectFeatureSetting

FEATURE_SETTING = {
    "choices": ProjectFeatureSetting.choices,
    "default": ProjectFeatureSetting.DISABLE,
    "max_length": 17
}

DEFAULT_QUESTIONS = [
    "Name",
    "Address",
    "Branch",
    "Owner",
    "Telephone",
    "E-mail",
    "Open Hours",
]

PIN_POINT_TYPE_TEMPLATE = {
    "project": None,
    "name": None,
    "detail": None,
    "employee_projects": [],
    "questions": [
        {
            "name": "Name",
            "require": True,
            "hide": False,
            "template": True
        },
        {
            "name": "Address",
            "require": True,
            "hide": False,
            "template": True
        },
        {
            "name": "Branch",
            "require": True,
            "hide": False,
            "template": True
        },
        {
            "name": "Owner",
            "require": True,
            "hide": False,
            "template": True
        },
        {
            "name": "Telephone",
            "require": True,
            "hide": False,
            "template": True
        },
        {
            "name": "E-mail",
            "require": True,
            "hide": False,
            "template": True
        },
        {
            "name": "Open Hours",
            "require": True,
            "hide": False,
            "template": True
        }
    ]
}
