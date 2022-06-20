import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/models/export_models.dart';

class UserConfig {
  static bool hasPincode = false;
  static bool isCreatePassword = false;
  static String pageForgotPassword = "";
  static TokenAuthModel? session;
  static DeviceType? deviceType;
  static EmployeeProjectModel? employeeProjectModel;

  static String getFullName() {
    return session!.user.first_name + " " + session!.user.last_name;
  }

  static void clearData() {
    hasPincode = false;
    isCreatePassword = false;
    pageForgotPassword = "";
    session = null;
    employeeProjectModel = null;
  }

  static String getProjectname() {
    return employeeProjectModel!.project.name;
  }

  static int getProjectID() {
    return employeeProjectModel!.project.id;
  }

  static int getEmployeeProjectID() {
    return employeeProjectModel!.id;
  }

  static String getProjectDate() {
    String startDate = DateTimeService.timeServerToStringDDMMMYYYY(
        employeeProjectModel!.project.start_date);
    String endDate = DateTimeService.timeServerToStringDDMMMYYYY(
        employeeProjectModel!.project.end_date);
    return startDate + " to " + endDate;
  }
}
