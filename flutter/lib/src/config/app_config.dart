enum Environment { dev, prod }

final baseUrl = Environments.server;

class Environments {
  static late Map<String, dynamic> _config;

  static void setEnvironment(Environment env) {
    switch (env) {
      case Environment.dev:
        _config = _Config.devConstants;
        break;
      case Environment.prod:
        _config = _Config.prodConstants;
        break;
    }
  }

  static get server {
    return _config[_Config.server];
  }

  static get name {
    return _config[_Config.name];
  }
}

class _Config {
  static const server = 'SERVER';
  static const name = 'NAME';

  static Map<String, dynamic> devConstants = {
    server: 'adecco.c0d1um.io',
    name: 'dev'
  };

  static Map<String, dynamic> prodConstants = {
    server: 'adecco.c0d1um.io',
    name: 'prod'
  };
}

const String sentryUrl =
    "https://50e7ced878314c3caea54f965cf34a08@o20495.ingest.sentry.io/6230092";

class ApiUrl {
  // Config
  static const String backendMocki = "/mocki/backend/api/";
  static const String backend = "/backend/api/";
  static const String bulk = "bulk/";
  static const String project = "projects/";
  static const String details = "details/";

  // Auth
  static const String tokenAuth = 'token-auth/';
  static const String tokenRefresh = 'token-refresh/';
  static const String createPassword = 'change-first-time-password/';
  static const String createPincode = 'create-pincode/';
  static const String forgotPassword = 'forget-password/';
  static const String changePassword = 'change-password/';
  static const String employeeProject = 'employee-projects/me/';

  // Check-in
  static const String dailyTask = 'daily-tasks/';
  static const String checkInDailyTask = 'employees/daily-tasks/';
  static const String activities = 'activities/';
  static const String attendanceHistories = "activities/attendance-histories/";
  static const String locations = 'employees/locations/';
  static const String insideWorkPlace = 'activities/inside-workplace/';
  static const String pinPointType = 'pin-point-types/';
  static const String pinPoints = 'pin-points/';

  // Leave Request
  static const String leaveQuota = 'leave-quotas/';
  static const String leaveRequest = 'leave-requests/';
  static const String uploadAttachment = 'upload-attachments/';

  // Calendar
  static const String calendar = "calendars/";

  // Roster
  static const String workingHours = "working-hours/";
  static const String rosters = "rosters/";
  static const String workplaces = "workplaces/";
  static const String rosterPreview = "rosters/preview/";
  static const String rosterDayOff = "rosters/day-off/";
  static const String rosterCalendars = "rosters/calendars/";
  static const String editShift = "edit-shift/";
  static const String shifts = "shifts/";
  static const String dayOffRetrieve = "day-off-retrieve/";
  static const String adjustRequest = "adjust-requests/";

  // Overtime
  static const String otRequest = "ot-requests/";
  static const String otQuota = "employees/ot-quotas/";

  // Merchandising
  static const String priceTracking = "price-tracking/";
  static const String shopList = "merchandizers/me/";
  static const String findProduct = "merchandizer-settings/merchandizer/";
  static const String productList = "products/merchandizer/";

  // Other
  static const String dropDown = 'dropdown/';
}
