import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/services/roster.dart';
import 'package:ahead_adecco/src/utils/validate_string.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import '../../../constants/export_constants.dart';
import '../../../models/export_models.dart';
import '../text_controller/roster_text_controller.dart';

class CreateDayOffController extends GetxController with StateMixin {
  final PageType pageType;
  final int? rosterID;
  BuildContext context;
  CreateDayOffController(this.context, this.pageType, this.rosterID);

  final RosterTextFieldControllers textFieldControllers =
      RosterTextFieldControllers();

  final startDate = Rx<DateTime?>(null);
  final endDate = Rx<DateTime?>(null);
  final selectDateTime = DateTime.now().obs;

  final ScrollController listViewCtrl = ScrollController();
  late RosterPlanService rosterPlanService;
  final workingTimeList = <WorkingHoursModel>[].obs;
  final selectedWorkingHours = Rx<WorkingHoursModel?>(null);
  List<String> selectDayList = [];
  List<String> disableDay = [];
  Map<int, List<DateTime>> weekDay = {};
  Set<DateTime> setSelectDayList = {};
  RosterDayOffEditModel? rosterDayOffEditModel;
  final disablePreview = true.obs;

  bool? validation;

  @override
  void onInit() {
    rosterPlanService = RosterPlanService();
    callAllAPI();
    super.onInit();
  }

  @override
  void onClose() {
    textFieldControllers.dispose();
    listViewCtrl.dispose();
    super.onClose();
  }

  void setDate(bool isStartDate, DateTime dateTime) {
    Get.focusScope!.unfocus();
    if (isStartDate) {
      endDate.value = null;
      startDate.value = dateTime;
    } else {
      if (dateTime.isBefore(startDate.value!)) {
        DialogCustom.showSnackBar(
            title: Texts.alert, message: Texts.incorrectDate);
      } else {
        endDate.value = dateTime;
        selectDateTime.value = startDate.value!;
        setSelectDayList = {};
        weekDay = {};
        update();
      }
    }
  }

  Future callAllAPI() async {
    try {
      change(null, status: RxStatus.loading());

      await callAPIWorkingHours();
      if (pageType == PageType.edit) {
        await callAPIEditRosterDetail();
        disablePreview.value = enablePreviewButton();
      } else {
        disablePreview.value = false;
      }
      change(null, status: RxStatus.success());
    } catch (e) {
      debugPrint("e $e");
      change(null, status: RxStatus.error());
    }
  }

  void onClickPreview() {
    validatePreview();
  }

  bool enablePreviewButton() {
    return rosterDayOffEditModel == null ||
        rosterDayOffEditModel?.status == Keys.approve;
  }

  bool showRejectReason() {
    return pageType == PageType.edit &&
        rosterDayOffEditModel?.status == Keys.reject;
  }

  void validatePreview() {
    bool check = false;
    String? message;
    Get.focusScope!.unfocus();
    validation = textFieldControllers.isDataValid();
    if ((validation ?? false)) {
      if (selectedWorkingHours.value == null) {
        message = Texts.plsSelectworkingTime;
      } else if (selectDayList.isEmpty) {
        message = Texts.plsSelectDayOff;
      } else {
        check = true;
      }
    }
    check
        ? setupDataRoster()
        : message != null
            ? DialogCustom.showSnackBar(title: Texts.alert, message: message)
            : null;
  }

  Future callAPIWorkingHours() async {
    try {
      await rosterPlanService.workHours().then((value) async {
        List<WorkingHoursModel> _workTimeList = [];

        for (var item in value) {
          _workTimeList.add(item);
        }
        if (_workTimeList.isNotEmpty) {
          workingTimeList.assignAll(_workTimeList);
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Future callAPIEditRosterDetail() async {
    try {
      rosterDayOffEditModel =
          await rosterPlanService.getRosterDayOffDetail(rosterID!);
      setUpEditDayOff();
    } catch (e) {
      rethrow;
    }
  }

  void setUpEditDayOff() {
    textFieldControllers.title.text = rosterDayOffEditModel!.name;
    textFieldControllers.description.text =
        rosterDayOffEditModel!.description ?? "";
    startDate.value =
        DateTimeService.timeServerToDateTime(rosterDayOffEditModel!.start_date);
    endDate.value =
        DateTimeService.timeServerToDateTime(rosterDayOffEditModel!.end_date);
    selectDateTime.value = startDate.value!;
    for (var workTime in workingTimeList) {
      if (workTime.id == rosterDayOffEditModel!.day_off.working_hour) {
        selectedWorkingHours.value = workTime;
        onSelectedWorkingHours(selectedWorkingHours.value!);
      }
    }
    selectDayList.assignAll(rosterDayOffEditModel!.day_off.detail_list);
    for (var day in rosterDayOffEditModel!.day_off.detail_list) {
      DateTime _date = DateTimeService.timeServerToDateTime(day);
      DateTime _dateTimeZ =
          DateTimeService.dateTimeToDateTimeWithFormatUtc(_date);
      addDaySelected(_dateTimeZ);
    }
  }

  void onSelectedWorkingHours(WorkingHoursModel workingHoursModel) {
    selectedWorkingHours.value = workingHoursModel;
    disableDay.clear();
    if (workingHoursModel.sunday == Keys.holiday) {
      disableDay.add(Keys.sunday);
    }
    if (workingHoursModel.monday == Keys.holiday) {
      disableDay.add(Keys.monday);
    }
    if (workingHoursModel.tuesday == Keys.holiday) {
      disableDay.add(Keys.tuesday);
    }
    if (workingHoursModel.wednesday == Keys.holiday) {
      disableDay.add(Keys.wednesday);
    }
    if (workingHoursModel.thursday == Keys.holiday) {
      disableDay.add(Keys.thursday);
    }
    if (workingHoursModel.friday == Keys.holiday) {
      disableDay.add(Keys.friday);
    }
    if (workingHoursModel.saturday == Keys.holiday) {
      disableDay.add(Keys.saturday);
    }
    setSelectDayList = {};
    weekDay = {};
    update();
  }

  Future setupDataRoster() async {
    try {
      Map<String, Object?> data = {};
      RosterDayOffModel _rosterDayOff = RosterDayOffModel(
          working_hour: selectedWorkingHours.value!.id,
          detail_list: selectDayList);

      data.addAll({
        "employee_projects": [UserConfig.getEmployeeProjectID()],
        "name": textFieldControllers.title.text,
        "start_date": DateTimeService.getStringTimeServer(startDate.value!),
        "end_date": DateTimeService.getStringTimeServer(endDate.value!),
      });
      if (pageType == PageType.edit) {
        data.addAll({
          "id": rosterID!,
        });
        _rosterDayOff.id = rosterDayOffEditModel!.day_off.id;
      }

      var _json = _rosterDayOff.toJson();
      data.addAll({
        "day_off": _json,
      });
      if (textFieldControllers.description.text.isNotEmptyString()) {
        data.addAll({"description": textFieldControllers.description.text});
      }
      debugPrint("data $data");
      Get.toNamed(Routes.previewRoster, arguments: {
        Keys.data: data,
        Keys.roster: RosterPageType.createDayOff,
        Keys.pageType: pageType,
        Keys.date: startDate.value
      });
    } catch (e) {
      debugPrint("$e");
    }
  }

  void addDaySelected(DateTime selectedDay) {
    int _week =
        Jiffy([selectedDay.year, selectedDay.month, selectedDay.day]).week;
    if (weekDay[_week] == null) {
      weekDay.addAll({_week: []});
    }
    weekDay[_week]!.add(selectedDay);
    setSelectDayList.add(selectedDay);
  }

  void onClickCancel() async {
    DialogCustom.showBasicAlertOkCancel(Texts.askCancelDayoff,
        onPressed: (() async {
      Get.back();
      await callAPICancelDayOff();
    }));
  }

  Future callAPICancelDayOff() async {
    LoadingCustom.showOverlay(context);
    try {
      await rosterPlanService.cancelRoster(rosterID!).then((value) async {
        LoadingCustom.hideOverlay(context);
      });
      DialogCustom.showBasicAlert(Texts.removeSucces,
          onPressed: () => Get.back());
    } catch (e) {
      LoadingCustom.hideOverlay(context);
      DialogCustom.showBasicAlert("$e");
    }
  }
}
