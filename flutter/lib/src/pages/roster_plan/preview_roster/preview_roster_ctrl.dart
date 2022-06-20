import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import '../../../models/export_models.dart';
import '../../../services/roster.dart';

class PreviewRosterController extends GetxController
    with StateMixin<RosterDetailModel> {
  BuildContext context;
  final Map<String, Object?> data;
  PageType pageType;
  final int? rosterID;
  PreviewRosterController(this.context,
      {required this.data,
      required this.rosterType,
      required this.pageType,
      required this.rosterID})
      : super();

  late RosterPlanService rosterPlanService;
  final selectDateTime = DateTime.now().obs;
  final ScrollController listViewCtrl = ScrollController();
  final tabList = [true.obs, false.obs, false.obs];
  final isSelected = 0.obs;
  final events = <DateTime, List<String>>{}.obs;
  late DateTime firstDate;
  late DateTime lastDate;
  late String monthDuration;

  RosterPageType rosterType = RosterPageType.createRoster;

  @override
  void onInit() {
    rosterPlanService = RosterPlanService();
    callAPIPreviewRoster();

    super.onInit();
  }

  @override
  void onClose() {
    listViewCtrl.dispose();
    super.onClose();
  }

  void setDateFromData(String firstDate, String lastDate) {
    this.firstDate = DateTimeService.timeServerToDateTime(firstDate);
    this.lastDate = DateTimeService.timeServerToDateTime(lastDate);
    if (this.firstDate.month == this.lastDate.month) {
      monthDuration = DateTimeService.timeServerToStringMMMM(firstDate);
    } else {
      monthDuration = DateTimeService.timeServerToStringMMMM(firstDate) +
          " - " +
          DateTimeService.timeServerToStringMMMM(lastDate);
    }
  }

  void onPressedTab(RosterPlan rosterPlan) {
    isSelected.value = rosterPlan.index;
    for (int i = 0; i < tabList.length; i++) {
      tabList[i].value = i == rosterPlan.index;
    }
  }

  Future callAPIPreviewRoster() async {
    change(null, status: RxStatus.loading());
    try {
      await rosterPlanService.previewRoster(data).then((value) {
        List<RosterDayModel> _rosterDayModelList = [];
        _rosterDayModelList = value.calendar!.calendars;
        addEventCalendar(_rosterDayModelList);
        setDateFromData(
            data[Keys.startDate].toString(), data[Keys.endDate].toString());
        change(value, status: RxStatus.success());
      });
    } catch (e) {
      debugPrint("e $e");
      change(null, status: RxStatus.error());
    }
  }

  Future callAPICreateRosterPlan() async {
    LoadingCustom.showOverlay(context);
    try {
      rosterType == RosterPageType.createRoster
          ? await rosterPlanService.createRoster(data)
          : await rosterPlanService.createDayOff(data);
      LoadingCustom.hideOverlay(context);
      DialogCustom.showBasicAlert(
        Texts.saveSuccess,
        onPressed: () {
          Get.back();
          Get.back(result: true);
        },
      );
    } catch (e) {
      debugPrint("$e");
      LoadingCustom.hideOverlay(context);
      DialogCustom.showBasicAlert("$e");
    }
  }

  Future callAPIEditRosterPlan(int? rosterID) async {
    LoadingCustom.showOverlay(context);
    try {
      rosterType == RosterPageType.createRoster
          ? await rosterPlanService.editRoster(data, rosterID!)
          : await rosterPlanService.editDayOff(data);
      LoadingCustom.hideOverlay(context);
      DialogCustom.showBasicAlert(
        Texts.saveSuccess,
        onPressed: () {
          Get.back();
          Get.back(result: true);
        },
      );
    } catch (e) {
      debugPrint("$e");
      LoadingCustom.hideOverlay(context);
      DialogCustom.showBasicAlert("$e");
    }
  }

  void onClickSave() {
    DialogCustom.showBasicAlertOkCancel(Texts.askCreateRoster,
        textButton: Texts.save, onPressed: () async {
      Get.back();
      pageType == PageType.create
          ? await callAPICreateRosterPlan()
          : await callAPIEditRosterPlan(rosterID);
    });
  }

  void addEventCalendar(List<RosterDayModel> calendarEventList) {
    Map<DateTime, List<String>> _event = {};
    for (var item in calendarEventList) {
      DateTime _dayFormat = DateTimeService.timeServerToDateTimeWithFormat(
          item.date,
          format: DateTimeFormatCustom.yyyymmdd);

      _event.addAll({
        _dayFormat: [item.type]
      });
    }
    events.assignAll(_event);
    debugPrint("events $events");
    update();
  }
}
