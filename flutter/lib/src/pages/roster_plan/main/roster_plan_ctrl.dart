import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/pages/roster_plan/main/roster_plan_model.dart';
import 'package:ahead_adecco/src/services/roster.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class RosterPlanController extends GetxController
    with StateMixin<List<RosterPlanData>> {
  BuildContext context;
  RosterPlanController({required this.context}) : super();

  late RosterPlanService rosterPlanService;
  final selectDateTime = DateTime.now().obs;
  final ScrollController listViewCtrl = ScrollController();
  final tabList = [true.obs, false.obs, false.obs];
  final isSelected = 0.obs;
  final rosterPlanDataList = <RosterPlanData>[].obs;
  final events = <DateTime, List<String>>{}.obs;

  @override
  void onInit() {
    rosterPlanService = RosterPlanService();
    callAllAPI();
    super.onInit();
  }

  @override
  void onClose() {
    listViewCtrl.dispose();
    rosterPlanService.close();
    super.onClose();
  }

  void callAllAPI({DateTime? filterMonth}) async {
    LoadingCustom.showOverlay(context);
    await Future.wait([
      callAPIRoster(filterMonth: filterMonth),
      callAPIRosterCalendar(filterMonth: filterMonth)
    ]);
    LoadingCustom.hideOverlay(context);
  }

  void onPressedTab(RosterPlan rosterPlan) {
    isSelected.value = rosterPlan.index;
    for (int i = 0; i < tabList.length; i++) {
      tabList[i].value = i == rosterPlan.index;
    }
    callAllAPI();
  }

  void navigatorMenu(int index) {
    switch (index) {
      case 0:
        Get.toNamed(Routes.createRoster,
                arguments: {Keys.pageType: PageType.create})!
            .then((value) => onBackRefresh(
                function: () {
                  onPressedTab(RosterPlan.pending);
                },
                value: value));
        break;
      case 1:
        Get.toNamed(Routes.createDayOff,
                arguments: {Keys.pageType: PageType.create})!
            .then((value) => onBackRefresh(
                function: () {
                  onPressedTab(RosterPlan.pending);
                },
                value: value));
        break;
      default:
    }
  }

  void onClickEditRoster(int rosterID, String type) {
    if (type == Keys.dayOff) {
      Get.toNamed(Routes.createDayOff,
              arguments: {Keys.pageType: PageType.edit, Keys.id: rosterID})!
          .then((value) => onBackRefresh(
              function: () {
                checkTabEditRoster();
              },
              value: value));
    } else {
      Get.toNamed(Routes.createRoster,
              arguments: {Keys.pageType: PageType.edit, Keys.id: rosterID})!
          .then((value) => onBackRefresh(
              function: () {
                checkTabEditRoster();
              },
              value: value));
    }
  }

  void checkTabEditRoster() {
    if (isSelected.value == 2) {
      onPressedTab(RosterPlan.pending);
    } else {
      callAllAPI();
    }
  }

  void onClickSelectMonthYear(DateTime dateTime) {
    selectDateTime.value = dateTime;
    callAllAPI(filterMonth: dateTime);
  }

  void addEventCalendar(List<RosterDayModel> calendarEventList) {
    Map<DateTime, List<String>> _event = {};
    if (calendarEventList.isNotEmpty) {
      for (var item in calendarEventList) {
        DateTime _dayFormat = DateTimeService.timeServerToDateTimeWithFormat(
            item.date,
            format: DateTimeFormatCustom.yyyymmdd);

        _event.addAll({
          _dayFormat: [item.type]
        });
      }
    }
    events.assignAll(_event);
    update();
  }

  Future callAPIRoster({DateTime? filterMonth}) async {
    change([], status: RxStatus.loading());
    try {
      Map<String, dynamic> param = {
        Keys.project: UserConfig.getProjectID().toString()
      };

      switch (isSelected.value) {
        case 0:
          param.addAll({"status": Keys.approve});
          break;
        case 1:
          param.addAll({"status": Keys.pending});
          break;
        case 2:
          param.addAll({"status": Keys.reject});
          break;
        default:
      }
      if (filterMonth != null) {
        String _filterDateString =
            DateTimeService.getStringTimeServer(filterMonth);
        param.addAll({"date": _filterDateString});
      }
      await rosterPlanService.getRoster(param).then((value) async {
        if (value.isNotEmpty) {
          List<RosterPlanData> _rosterPlanData =
              List<RosterPlanData>.generate(value.length, (int index) {
            return RosterPlanData(rosterModel: value[index]);
          });
          rosterPlanDataList.assignAll(_rosterPlanData);
          change(_rosterPlanData, status: RxStatus.success());
        } else {
          change([], status: RxStatus.empty());
        }
      });
    } catch (e) {
      debugPrint("$e");
      change([], status: RxStatus.error('Error: $e'));
    }
  }

  Future callAPIRosterCalendar({DateTime? filterMonth}) async {
    try {
      Map<String, dynamic> param = {
        Keys.project: UserConfig.getProjectID().toString()
      };
      switch (isSelected.value) {
        case 0:
          param.addAll({"status": Keys.approve});
          break;
        case 1:
          param.addAll({"status": Keys.pending});
          break;
        case 2:
          param.addAll({"status": Keys.reject});
          break;
        default:
      }
      if (filterMonth != null) {
        String _filterDateString =
            DateTimeService.getStringTimeServer(filterMonth);
        param.addAll({"date": _filterDateString});
      }
      await rosterPlanService.getRosterCalendar(param).then((value) async {
        List<RosterDayModel> _rosterDayModelList = [];
        for (var item in value.calendars) {
          _rosterDayModelList.add(item);
        }
        addEventCalendar(_rosterDayModelList);
      });
    } catch (e) {
      addEventCalendar([]);
      debugPrint("$e");
    }
  }

  void onClickAdjust() {
    Get.toNamed(Routes.adjustRequest,
        arguments: {Keys.date: selectDateTime.value});
  }
}
