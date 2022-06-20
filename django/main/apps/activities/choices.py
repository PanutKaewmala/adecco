from django.db import models


class ActivityType(models.TextChoices):
    CHECK_IN = 'check_in', 'Check in'
    CHECK_OUT = 'check_out', 'Check out'
    PIN_POINT = 'pin_point', 'Pin Point'
    TRACK_ROUTE = 'track_route', 'Track Route'


class ActivityExtraType(models.TextChoices):
    ABSENT = 'absent', 'Absent'
    LATE = 'late', 'Late'
    PERSONAL_LEAVE = 'personal_leave', 'Personal Leave'
    SICK_LEAVE = 'sick_leave', 'Sick Leave'
    OT = 'ot', 'OT'
    EARLY_LEAVE = 'early_leave', 'Early Leave'


class LeaveStatus(models.TextChoices):
    PENDING = 'pending', 'Pending'
    UPCOMING = 'upcoming', 'Upcoming'
    HISTORY = 'history', 'History'
    APPROVE = 'approve', 'Approve'
    PARTIAL_APPROVE = 'partial_approve', 'Partial-Approve'
    REJECT = 'reject', 'Reject'


class OTRequestStatus(models.TextChoices):
    PENDING = 'pending', 'Pending'
    APPROVE = 'approve', 'Approve'
    PARTIAL_APPROVE = 'partial_approve', 'Partial-Approve'
    REJECT = 'reject', 'Reject'


class OTRequestType(models.TextChoices):
    USER_REQUEST = 'user_request', 'User request'
    ASSIGN_OT = 'assign_ot', 'Assign OT'
