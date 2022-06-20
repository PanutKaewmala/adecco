import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/services/export_services.dart';
import 'package:ahead_adecco/src/widgets/calendar/calendar_model.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class HistoryController extends GetxController
    with StateMixin<List<CheckInHistoryModel>> {
  BuildContext context;
  HistoryController(this.context);

  final selectDateTime = DateTime.now().obs;
  late AutoScrollController listViewCtrl;
  late CheckInService checkInService;
  final calendarEventList = <CalendarEvent>[].obs;
  final events = <DateTime, List<String>>{}.obs;

  @override
  void onInit() {
    listViewCtrl = AutoScrollController();
    checkInService = CheckInService();
    callAPIHistory();
    super.onInit();
  }

  @override
  void onClose() {
    listViewCtrl.dispose();
    super.onClose();
  }

  void onClickSelectMonthYear(DateTime dateTime) {
    selectDateTime.value = dateTime;
    callAPIHistory();
  }

  void onClickSelectDay(DateTime date) async {
    selectDateTime.value = date;
    jumpToIndex();
    update();
  }

  Future callAPIHistory({DateTime? dateTime}) async {
    LoadingCustom.showOverlay(context);
    change([], status: RxStatus.loading());
    try {
      if (dateTime != null) {
        selectDateTime.value = dateTime;
      }
      selectDateTime.value =
          DateTime(selectDateTime.value.year, selectDateTime.value.month, 1);
      String _date = DateTimeService.getStringDateTimeFormat(
          selectDateTime.value,
          format: DateTimeFormatCustom.yyyymmdd);
      var param = {
        "date": _date,
        "project": UserConfig.getProjectID().toString(),
      };
      await checkInService.history(param).then((value) async {
        List<CheckInHistoryModel> _activitiesList = [];
        List<CalendarEvent> _calendarEventList = [];
        for (var item in value) {
          if (item.status != null) {
            _activitiesList.add(item);
            _calendarEventList.add(
                CalendarEvent(date: item.date_time, status: [item.status!]));
          }
        }
        calendarEventList.assignAll(_calendarEventList);
        addEventCalendar();
        if (_activitiesList.isNotEmpty) {
          change(_activitiesList, status: RxStatus.success());
        } else {
          change([], status: RxStatus.empty());
        }
        LoadingCustom.hideOverlay(context);
      });
    } catch (e) {
      LoadingCustom.hideOverlay(context);
      change([], status: RxStatus.error());
      debugPrint("$e");
    }
  }

  void addEventCalendar() {
    Map<DateTime, List<String>> _event = {};
    for (var item in calendarEventList) {
      DateTime _dayFormat = DateTimeService.timeServerToDateTimeWithFormat(
          item.date,
          format: DateTimeFormatCustom.yyyymmdd);

      _event.addAll({_dayFormat: item.status});
    }
    events(_event);
  }

  void jumpToIndex() async {
    String _date = DateTimeService.getStringDateTimeFormat(selectDateTime.value,
        format: DateTimeFormatCustom.yyyymmdd);
    final index = state!.indexWhere((element) => element.date_time == _date);
    if (index >= 0) {
      await listViewCtrl.scrollToIndex(index,
          preferPosition: AutoScrollPosition.begin,
          duration: const Duration(seconds: 1));
    }
  }
}
