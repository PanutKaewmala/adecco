from django.urls import path
from rest_framework.routers import DefaultRouter
from rest_framework_simplejwt.views import TokenRefreshView

from main.apps.activities.views import DailyTasksViewSet, ActivityViewSet, LeaveRequestViewSet, LeaveQuotaViewSet, \
    UploadAttachmentViewSet, LeaveTypeSettingViewSet, LeaveTypeViewSet, PinPointViewSet, TrackRouteViewSet, \
    OTRequestViewSet, CalendarViewSet, AdditionalTypeViewSet
from main.apps.authentication.views import MyTokenObtainPairView, ChangeFirstTimePasswordView, CreatePinCodeView, \
    LoginPinCodeView, ChangePasswordView
from main.apps.common.views import CustomDropdownView
from main.apps.managements.views import ProjectViewSet, ClientViewSet, WorkPlaceViewSet, PintPointTypeViwSet, \
    ClientLeaveTypeSettingViewSet, WorkingHourViewSet, OTRuleViewSet, BusinessCalendarViewSet
from main.apps.merchandizers.views import MerchandizerSettingViewSet, ShopViewSet, ProductViewSet, MerchandizerViewSet, \
    PriceTrackingViewSet
from main.apps.rosters.views import RosterViewSet, ShiftViewSet, EditShiftViewSet, AdjustRequestViewSet
from main.apps.users.views import UserViewSet, EmployeeViewSet, ManagerViewSet, EmployeeProjectViewSet

router = DefaultRouter()
app_name = 'api_urls'

# Register your API router here. It should be sorted by alphabet.
router.register('activities', ActivityViewSet, basename='activities')
router.register('additional-types', AdditionalTypeViewSet, basename='additional-types')
router.register('client-leave-type-settings', ClientLeaveTypeSettingViewSet, basename='client-leave-type-settings')
router.register('calendars', CalendarViewSet, basename='calendars')
router.register('daily-tasks', DailyTasksViewSet, basename='daily-tasks')
router.register('employee-projects', EmployeeProjectViewSet, basename='employee-projects')

router.register('leave-requests', LeaveRequestViewSet, basename='leave-requests')
router.register('leave-quotas', LeaveQuotaViewSet, basename='leave-quotas')
router.register('leave-types', LeaveTypeViewSet, basename='leave-types')
router.register('leave-type-settings', LeaveTypeSettingViewSet, basename='leave-type-settings')

router.register('ot-requests', OTRequestViewSet, basename='ot-requests')

router.register('upload-attachments', UploadAttachmentViewSet, basename='upload-attachments')
router.register('users', UserViewSet, basename='users')
router.register('projects', ProjectViewSet, basename='projects')
router.register('clients', ClientViewSet, basename='clients')
router.register('workplaces', WorkPlaceViewSet, basename='workplaces')
router.register('working-hours', WorkingHourViewSet, basename='working-hours')
router.register('employees', EmployeeViewSet, basename='employees')
router.register('managers', ManagerViewSet, basename='managers')
router.register('rosters', RosterViewSet, basename='rosters')
router.register('shifts', ShiftViewSet, basename='shifts')
router.register('edit-shifts', EditShiftViewSet, basename='edit-shifts')
router.register('adjust-requests', AdjustRequestViewSet, basename='adjust-requests')
router.register('pin-point-types', PintPointTypeViwSet, basename='pin-point-types')
router.register('pin-points', PinPointViewSet, basename='pin-points')
router.register('track-routes', TrackRouteViewSet, basename='track-routes')
router.register('ot-rules', OTRuleViewSet, basename='ot-rules')
router.register('business-calendars', BusinessCalendarViewSet, basename='business-calendars')

router.register('merchandizer-settings', MerchandizerSettingViewSet, basename='merchandizer-settings')
router.register('shops', ShopViewSet, basename='shops')
router.register('products', ProductViewSet, basename='products')
router.register('merchandizers', MerchandizerViewSet, basename='merchandizers')
router.register('price-tracking', PriceTrackingViewSet, basename='price-tracking')

urlpatterns = [
    path('token-auth/', MyTokenObtainPairView.as_view(), name='token-auth'),
    path('token-refresh/', TokenRefreshView.as_view(), name='token-refresh'),
    path('change-first-time-password/', ChangeFirstTimePasswordView.as_view(), name='change-first-time-password'),
    path('change-password/', ChangePasswordView.as_view(), name='change-password'),
    path('create-pincode/', CreatePinCodeView.as_view(), name='create-pincode'),
    path('login-pincode/', LoginPinCodeView.as_view(), name='login-pincode'),

    path('dropdown/', CustomDropdownView.as_view(), name='dropdown'),
]

urlpatterns += router.urls
