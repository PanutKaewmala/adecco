EXCLUDE_MODEL_CONTROLLER_FIELDS = ('created_at', 'updated_at', 'created_user', 'updated_user')
EXCLUDE_SOFT_DELETE_FIELD = ('alive',)
EXCLUDE_SOFT_DELETION_MODEL_CONTROLLER_FIELDS = EXCLUDE_MODEL_CONTROLLER_FIELDS + EXCLUDE_SOFT_DELETE_FIELD

EXCLUDE_TIME_STAMP_FIELDS = ('created_at', 'updated_at')
EXCLUDE_COMMON_FIELDS = (*EXCLUDE_TIME_STAMP_FIELDS, 'created_user', 'updated_user', 'alive')

NULL_AND_BLANK = {'null': True, 'blank': True}

DAY_OF_WEEK_LIST = ('sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday')
DAY_OF_WEEK_DICT = {
    'sunday': [],
    'monday': [],
    'tuesday': [],
    'wednesday': [],
    'thursday': [],
    'friday': [],
    'saturday': [],
}

DAY_OF_WEEK_FROM_CALENDAR = ('monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday')
