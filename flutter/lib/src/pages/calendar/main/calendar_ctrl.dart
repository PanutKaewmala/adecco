import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/services/export_services.dart';
import 'package:ahead_adecco/src/widgets/calendar/calendar_model.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class CalendarController extends GetxController with StateMixin {
  BuildContext context;
  CalendarController(this.context);

  final selectDateTime = DateTime.now().obs;
  final ScrollController listViewCtrl = ScrollController();
  late CalendarService calendarService;
  late CheckInService checkInService;
  late LeaveRequestService leaveRequestService;
  late OvertimeService overtimeService;
  final eventToday = Rx<CalendarEvent?>(null);
  final calendarEventList = <CalendarEvent>[].obs;
  final events = <DateTime, List<String>>{}.obs;
  final dailyTaskList = <CheckInTasksModel>[].obs;
  final leaveRequestList = <LeaveRequestModel>[].obs;
  final overTimeList = <OverTimeModel>[];

  @override
  void onInit() {
    calendarService = CalendarService();
    checkInService = CheckInService();
    leaveRequestService = LeaveRequestService();
    overtimeService = OvertimeService();
    callAPICalendar();
    super.onInit();
  }

  void navigatorMenu(int index) async {
    switch (index) {
      case 0:
        Get.toNamed(Routes.createTask);
        break;
      case 1:
        Get.toNamed(Routes.createLeave,
                arguments: {Keys.pageType: PageType.create})!
            .then((value) => onBackRefresh(
                function: () {
                  callAPIWithDate(value["date"]);
                },
                value: value != null ? value["value"] : value));
        break;
      case 2:
        Get.toNamed(Routes.createOT,
                arguments: {Keys.pageType: PageType.create})!
            .then((value) => onBackRefresh(
                function: () {
                  callAPIWithDate(value["date"]);
                },
                value: value != null ? value["value"] : value));
        break;
      default:
    }
  }

  void onClickSelectMonthYear(DateTime dateTime) {
    selectDateTime.value = dateTime;
    callAPICalendar();
  }

  void callAPIWithDate(DateTime? dateTime) {
    if (dateTime != null) {
      selectDateTime.value = value["date"];
    }
    callAPICalendar();
  }

  Future callAPICalendar({DateTime? dateTime}) async {
    try {
      LoadingCustom.showOverlay(context);
      change([], status: RxStatus.loading());

      if (dateTime != null) {
        selectDateTime.value = dateTime;
      }

      String _date = DateTimeService.getStringDateTimeFormat(
          selectDateTime.value,
          format: DateTimeFormatCustom.yyyymmdd);

      var params = {"date": _date, "project": "${UserConfig.getProjectID()}"};
      await calendarService.calendar(params).then((value) async {
        List<CalendarDateModel> _activitiesList = [];
        List<CalendarEvent> _calendarEventList = [];
        for (var item in value) {
          if (item.type.isNotEmpty) {
            if (item.date == _date) {
              eventToday.value =
                  CalendarEvent(date: item.date, status: item.type);
            }
            _activitiesList.add(item);
            _calendarEventList
                .add(CalendarEvent(date: item.date, status: item.type));
          }
        }
        calendarEventList.assignAll(_calendarEventList);
        addEventCalendar();
        await checkEventToDay();
        LoadingCustom.hideOverlay(context);
      });
    } catch (e) {
      LoadingCustom.hideOverlay(context);
      debugPrint("$e");
    }
  }

  void onClickSelectDay(DateTime date) async {
    selectDateTime.value = date;
    update();
    await checkEventToDay();
  }

  Future checkEventToDay() async {
    eventToday.value = null;
    String _date = DateTimeService.getStringDateTimeFormat(selectDateTime.value,
        format: DateTimeFormatCustom.yyyymmdd);
    for (var item in calendarEventList) {
      if (item.date == _date) {
        eventToday.value = CalendarEvent(date: item.date, status: item.status);
      }
    }
    if (eventToday.value != null) {
      // if (eventToday.value!.status == CalendarStatus.workDay.key) {
      //   await callAPIDailyTask();
      // } else if (eventToday.value!.status == CalendarStatus.leave.key) {
      //   await callAPILeaveRequest();
      // }
      change([], status: RxStatus.empty());
    } else {
      clearListEvent();
      change([], status: RxStatus.empty());
    }
  }

  void clearListEvent() {
    dailyTaskList.clear();
    leaveRequestList.clear();
  }

  void addEventCalendar() {
    Map<DateTime, List<String>> _event = {};
    for (var item in calendarEventList) {
      DateTime _dayFormat = DateTimeService.timeServerToDateTimeWithFormat(
          item.date,
          format: DateTimeFormatCustom.yyyymmdd);

      _event.addAll({_dayFormat: item.status});
    }
    events.assignAll(_event);
  }

  Future callAPIDailyTask() async {
    change([], status: RxStatus.loading());
    try {
      String _date = DateTimeService.getStringDateTimeFormat(DateTime.now(),
          format: DateTimeFormatCustom.yyyymmdd);
      var params = {
        "date": _date,
        "project": UserConfig.getProjectID().toString(),
      };
      await checkInService.checkIndailyTask(params).then((value) async {
        List<CheckInTasksModel> _dailyTaskList = [];
        for (var item in value) {
          _dailyTaskList.add(item);
        }
        if (_dailyTaskList.isNotEmpty) {
          dailyTaskList.assignAll(_dailyTaskList);
          change(_dailyTaskList, status: RxStatus.success());
        } else {
          change([], status: RxStatus.empty());
        }
      });
    } catch (e) {
      debugPrint("$e");
      change([], status: RxStatus.error('Error: $e'));
    }
  }

  Future callAPILeaveRequest() async {
    change([], status: RxStatus.loading());
    try {
      String _date = DateTimeService.getStringDateTimeFormat(
          selectDateTime.value,
          format: DateTimeFormatCustom.yyyymmdd);
      await leaveRequestService.leaveRequest(date: _date).then((value) async {
        List<LeaveRequestModel> _leaveRequestList = [];
        if (value.data.isNotEmpty) {
          for (var item in value.data) {
            _leaveRequestList.add(item);
          }
          leaveRequestList.assignAll(_leaveRequestList);
          change([], status: RxStatus.success());
        } else {
          change([], status: RxStatus.empty());
        }
      });
    } catch (e) {
      debugPrint("$e");
      change([], status: RxStatus.error('Error: $e'));
    }
  }

  Future callAPIOvertime() async {
    try {
      await overtimeService
          .getOvertime(status: TabbarType.upcoming.key)
          .then((value) async {
        List<OverTimeModel> _overTimeList = [];
        if (value.data.isNotEmpty) {
          for (var item in value.data) {
            _overTimeList.add(item);
          }
          overTimeList.assignAll(_overTimeList);
          change([], status: RxStatus.success());
        } else {
          change([], status: RxStatus.empty());
        }
      });
    } catch (e) {
      debugPrint("$e");
      change([], status: RxStatus.error('Error: $e'));
    }
  }

  void onClickLeave(LeaveRequestModel leaveRequest) {
    if (leaveRequest.status != LeaveRequest.upcoming.key) {
      Get.toNamed(Routes.createLeave, arguments: {
        Keys.pageType: PageType.edit,
        Keys.leave: leaveRequest
      })!
          .then((value) {
        onBackRefresh(
            function: () {
              callAPIWithDate(value["date"]);
            },
            value: value != null ? value["value"] : value);
      });
    }
  }
}
