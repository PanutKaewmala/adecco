import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/services/roster.dart';
import 'package:ahead_adecco/src/utils/validate_string.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import '../text_controller/roster_text_controller.dart';
import 'create_roster_model.dart';

class CreateRosterController extends GetxController with StateMixin {
  final int? rosterID;
  final PageType pageType;
  BuildContext context;
  CreateRosterController(this.context,
      {required this.rosterID, required this.pageType});
  final startDate = Rx<DateTime?>(null);
  final endDate = Rx<DateTime?>(null);
  final shiftList = <ShiftDataModel>[].obs;
  final ScrollController listViewCtrl = ScrollController();
  late RosterPlanService rosterPlanService;
  final workPlaceList = <PlaceRosterModel>[].obs;
  final workingTimeList = <WorkingHoursModel>[].obs;
  final selectedWorkingHours = Rx<WorkingHoursModel?>(null);
  final validate = Rx<bool?>(null);
  List<MultiSelectItem<PlaceRosterModel>> multiSelectWorkPlaceList = [];
  RosterEditModel? rosterEditModel;
  final disablePreview = true.obs;
  final showDayDetail = false.obs;

  final RosterTextFieldControllers textFieldControllers =
      RosterTextFieldControllers();
  bool? validation;

  int shiftID = 1;

  Map<String, String> _workDayDefualt = {};

  @override
  void onInit() {
    rosterPlanService = RosterPlanService();
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

  Future callAllAPI() async {
    change(null, status: RxStatus.loading());
    try {
      await Future.wait([
        callAPIWorkPlaces(),
        callAPIWorkingHours(),
      ]);
      if (pageType == PageType.edit) {
        await callAPIRosterDetailByID();
        disablePreview.value = enablePreviewButton();
      } else {
        disablePreview.value = false;
      }
      change(null, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error());
    }
  }

  Future callAPIWorkPlaces() async {
    try {
      await rosterPlanService.workPlaces().then((value) async {
        List<PlaceRosterModel> _placeList = [];

        for (var item in value) {
          _placeList.add(item);
        }
        if (_placeList.isNotEmpty) {
          workPlaceList.assignAll(_placeList);
          for (var element in workPlaceList) {
            multiSelectWorkPlaceList
                .add(MultiSelectItem<PlaceRosterModel>(element, element.name));
          }
        }
      });
    } catch (e) {
      rethrow;
    }
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

  Future callAPIRosterDetailByID() async {
    try {
      await rosterPlanService
          .getRosterDetailByID(rosterID!)
          .then((value) async {
        rosterEditModel = value;
        initDataEditRoster(value);
      });
    } catch (e) {
      rethrow;
    }
  }

  void initDataEditRoster(RosterEditModel rosterEditModel) {
    textFieldControllers.title.text = rosterEditModel.name;
    textFieldControllers.description.text = rosterEditModel.description ?? "";
    startDate.value =
        DateTimeService.timeServerToDateTime(rosterEditModel.start_date);
    endDate.value =
        DateTimeService.timeServerToDateTime(rosterEditModel.end_date);
    var _time = workingTimeList.where((workingHours) =>
        workingHours.name == rosterEditModel.working_hours.first);
    onSelectedWorkingHours(_time.first);
    for (var shift in rosterEditModel.shifts) {
      addEditShift(shift);
    }
  }

  void addEditShift(ShiftEditModel shiftEditModel) {
    int maxWorkDay = 0;
    ShiftDataModel _shiftData = ShiftDataModel(id: shiftID);
    _workDayDefualt.forEach((key, value) {
      if (value == Keys.dayOff) {
        maxWorkDay++;
      }
    });
    debugPrint("maxWorkDay $maxWorkDay");
    _shiftData.maxWorkDay = maxWorkDay;
    _shiftData.startDate.value =
        DateTimeService.timeServerToDateTime(shiftEditModel.from_date!);
    _shiftData.endDate.value =
        DateTimeService.timeServerToDateTime(shiftEditModel.to_date!);

    shiftList.add(_shiftData);
    shiftID++;
    checkMaxDay(shiftList.last);
    shiftEditModel.schedules.asMap().forEach((key, value) {
      addScheduleEdit(value, shiftList.last);
    });
  }

  void addScheduleEdit(
      ScheduleEditModel scheduleEditModel, ShiftDataModel shiftDataModel) {
    PlaceShift placeShift = PlaceShift();
    shiftDataModel.placeList.add(placeShift);
    var _workDayDefualt = {
      Keys.sunday: scheduleEditModel.sunday!,
      Keys.monday: scheduleEditModel.monday!,
      Keys.tuesday: scheduleEditModel.tuesday!,
      Keys.wednesday: scheduleEditModel.wednesday!,
      Keys.thursday: scheduleEditModel.thursday!,
      Keys.friday: scheduleEditModel.friday!,
      Keys.saturday: scheduleEditModel.saturday!
    };
    _workDayDefualt.forEach((key, value) {
      if (value == Keys.workDay) {
        if (!shiftDataModel.selectedDay.contains(key)) {
          shiftDataModel.selectedDay.add(key);
        }
      }
    });
    shiftDataModel.workDayType.add(_workDayDefualt);

    List<PlaceRosterModel> _placeList = [];
    for (var element in multiSelectWorkPlaceList) {
      for (var place in scheduleEditModel.workplaces) {
        if (element.value.id == place.id) {
          _placeList.add(element.value);
          debugPrint("name ${place.name}");
        }
      }
    }
    shiftDataModel.placeList.last.placeShift.addAll(_placeList);
  }

  Future setupDataRoster() async {
    try {
      Map<String, Object?> data = {};

      data.addAll({
        "id": rosterID,
        "employee_projects": [UserConfig.getEmployeeProjectID()],
        "name": textFieldControllers.title.text,
        "start_date": DateTimeService.getStringTimeServer(startDate.value!),
        "end_date": DateTimeService.getStringTimeServer(endDate.value!),
      });

      List<ShiftModel> _shiftList = [];

      shiftList.asMap().forEach((i, shift) {
        String fromDate =
            DateTimeService.getStringTimeServer(shift.startDate.value!);
        String toDate =
            DateTimeService.getStringTimeServer(shift.endDate.value!);

        List<ScheduleModel> _scheduleList = [];
        shift.workDayType.asMap().forEach((j, schedule) {
          List<int> _placeList = [];
          for (var place in shift.placeList[j].placeShift) {
            _placeList.add(place.id);
          }
          ScheduleModel _scheduleModel = ScheduleModel(
              id: addScheduleID(i, j),
              monday: schedule[Keys.monday],
              tuesday: schedule[Keys.tuesday],
              wednesday: schedule[Keys.wednesday],
              thursday: schedule[Keys.thursday],
              friday: schedule[Keys.friday],
              saturday: schedule[Keys.saturday],
              sunday: schedule[Keys.sunday],
              workplaces: _placeList,
              shift: addShiftID(i));

          _scheduleList.add(_scheduleModel);
        });
        ShiftModel _shiftModel = ShiftModel(
            id: addShiftID(i),
            from_date: fromDate,
            to_date: toDate,
            working_hour: selectedWorkingHours.value!.id,
            schedules: _scheduleList,
            roster: rosterEditModel?.id);
        _shiftList.add(_shiftModel);
      });

      var _json = _shiftList.map((e) => e.toJson()).toList();

      data.addAll({
        "shifts": _json,
      });
      if (textFieldControllers.description.text.isNotEmptyString()) {
        data.addAll({"description": textFieldControllers.description.text});
      }

      Get.toNamed(Routes.previewRoster, arguments: {
        Keys.data: data,
        Keys.roster: RosterPageType.createRoster,
        Keys.pageType: pageType,
        Keys.date: startDate.value,
        Keys.id: rosterID
      });
      debugPrint("data $data");
    } catch (e) {
      debugPrint("$e");
    }
  }

  int? addShiftID(int i) {
    if (rosterEditModel == null) {
      return null;
    } else if (i >= rosterEditModel!.shifts.length) {
      return null;
    } else {
      return rosterEditModel?.shifts[i].id;
    }
  }

  int? addScheduleID(int i, int j) {
    if (rosterEditModel == null) {
      return null;
    } else if (j >= rosterEditModel!.shifts[i].schedules.length) {
      return null;
    } else {
      return rosterEditModel?.shifts[i].schedules[j].id;
    }
  }

  void setDate(bool isStartDate, DateTime dateTime) {
    debugPrint("date $dateTime");
    Get.focusScope!.unfocus();
    if (isStartDate) {
      endDate.value = null;
      startDate.value = dateTime;
    } else {
      if (dateTime.isBefore(startDate.value!)) {
        DialogCustom.showSnackBar(
            title: Texts.alert, message: Texts.incorrectDate);
      } else {
        if (dateTime.difference(startDate.value!).inMinutes < 15) {
          endDate.value = dateTime.add(const Duration(minutes: 15));
        } else {
          endDate.value = dateTime;
        }
      }
    }
    if (shiftList.isNotEmpty) {
      shiftList.clear();
      shiftID = 1;
    }
  }

  void setDateIndex(int index, bool isStartDate, DateTime dateTime) {
    var _mocky = Map<String, String>.from(_workDayDefualt);
    if (isStartDate) {
      shiftList[index].endDate.value = null;
      shiftList[index].startDate.value = dateTime;
    } else {
      if (dateTime.isBefore(shiftList[index].startDate.value!)) {
        showAlertIncorrecrtTime();
      } else if (endDate.value!.isBefore(dateTime)) {
        showAlertIncorrecrtTime();
      } else {
        shiftList[index].placeList.assign(PlaceShift());
        shiftList[index].selectedDay.clear();
        shiftList[index].endDate.value = dateTime;
        shiftList[index].workDayType.assignAll([_mocky]);
        checkMaxDay(shiftList[index]);
      }
    }
  }

  void onClickPreview() {
    Get.focusScope!.unfocus();
    validation = textFieldControllers.isDataValid();
    if (validation ?? false) {
      validateRoster();
    }
  }

  bool enablePreviewButton() {
    return rosterEditModel == null || rosterEditModel?.status == Keys.approve;
  }

  bool showRejectReason() {
    return pageType == PageType.edit && rosterEditModel?.status == Keys.reject;
  }

  void checkMaxDay(ShiftDataModel shiftDataModel) {
    var _mocky = Map<String, String>.from(_workDayDefualt);
    List<String> _enableDay = [];
    List<String> _disableDay = [];
    DateTime start = shiftDataModel.startDate.value!;
    DateTime end = shiftDataModel.endDate.value!;
    int dayBetween = (end.difference(start).inDays) + 1;

    if (dayBetween < 8) {
      final items = List<DateTime>.generate(dayBetween, (i) {
        DateTime date = start;
        return date.add(Duration(days: i));
      });
      if (dayBetween == 0 && start.day == end.day) {
        _enableDay
            .add(DateTimeService.dateTimeToStringDDDD(start).toLowerCase());
      } else if (dayBetween == 0) {
        _enableDay
            .add(DateTimeService.dateTimeToStringDDDD(start).toLowerCase());
        _enableDay.add(DateTimeService.dateTimeToStringDDDD(end).toLowerCase());
      } else {
        for (var date in items) {
          _enableDay
              .add(DateTimeService.dateTimeToStringDDDD(date).toLowerCase());
        }
      }

      _mocky.forEach((key, value) {
        if (value == Keys.holiday) {
          _enableDay.remove(key);
        }
      });

      _mocky.forEach((key, value) {
        if (value != Keys.holiday) {
          _disableDay.add(key);
        }
      });
      _disableDay.removeWhere((element) => _enableDay.contains(element));

      shiftDataModel.selectedDay.addAll(_disableDay);
    }
  }

  void onClickAddShift() {
    int maxWorkDay = 0;
    var _mocky = Map<String, String>.from(_workDayDefualt);
    if (startDate.value != null &&
        endDate.value != null &&
        selectedWorkingHours.value != null) {
      ShiftDataModel _shiftData = ShiftDataModel(id: shiftID);
      _shiftData.workDayType.add(_mocky);

      for (var item in _shiftData.workDayType) {
        item.forEach((key, value) {
          if (value == Keys.dayOff) {
            maxWorkDay++;
          }
        });
      }

      _shiftData.maxWorkDay = maxWorkDay;

      PlaceShift placeShift = PlaceShift();
      _shiftData.placeList.add(placeShift);

      if (shiftList.isEmpty) {
        _shiftData.startDate.value = startDate.value;
        _shiftData.endDate.value = endDate.value;

        shiftList.add(_shiftData);
        shiftID++;
        checkMaxDay(shiftList.last);
        scrollDown();
      } else if (shiftList.last.endDate.value != null) {
        if (shiftList.last.endDate.value != endDate.value) {
          if (shiftList.isNotEmpty) {
            _shiftData.startDate.value = DateTime(
                shiftList.last.endDate.value!.year,
                shiftList.last.endDate.value!.month,
                shiftList.last.endDate.value!.day + 1);
            _shiftData.endDate.value = endDate.value;
          }

          shiftList.add(_shiftData);
          shiftID++;
          checkMaxDay(shiftList.last);
          scrollDown();
        } else {
          DialogCustom.showSnackBar(
              title: Texts.alert, message: Texts.cantAddShift);
        }
      } else {
        showAlertIncorrectDate();
      }
    } else {
      showAlertIncorrectDate();
    }
  }

  void onClickRemove(int index) {
    shiftList.removeAt(index);
    shiftID--;
  }

  void onClickAddSchedule(int index) {
    var _mocky = Map<String, String>.from(_workDayDefualt);

    bool canAdd = true;

    if (shiftList[index].maxWorkDay == (shiftList[index].selectedDay.length)) {
      canAdd = false;
    } else if (shiftList[index].workDayType.isNotEmpty) {
      bool checkWorkDay = false;
      shiftList[index].workDayType.last.forEach((key, value) {
        if (value == Keys.workDay) {
          checkWorkDay = true;
        }
      });
      canAdd = checkWorkDay;
    }

    if (canAdd) {
      shiftList[index].workDayType.add(_mocky);
      PlaceShift placeShift = PlaceShift();
      shiftList[index].placeList.add(placeShift);
    } else {
      DialogCustom.showSnackBar(
          title: Texts.alert, message: Texts.cantAddSchedule);
    }
  }

  void scrollDown() {
    Future.delayed(const Duration(milliseconds: 300), () {
      listViewCtrl.animateTo(
        listViewCtrl.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  void validateRoster() {
    bool check = false;
    String? message;
    if (selectedWorkingHours.value == null) {
      message = Texts.plsSelectworkingTime;
    } else if (shiftList.isEmpty) {
      message = Texts.plsAddShift;
    } else if (startDate.value != null && endDate.value != null) {
      for (var item in shiftList) {
        if (item.endDate.value != null) {
          if (endDate.value!.difference(item.endDate.value!).inDays == 0 &&
              endDate.value!.day == item.endDate.value!.day) {
            check = true;
          }
        }
        for (var schecdule in item.placeList) {
          if (schecdule.placeShift.isEmpty) {
            message = Texts.plsAddWorkPlace;
            check = false;
            break;
          }
        }
        if (item.selectedDay.isEmpty) {
          check = false;
          message = Texts.plsSelectWorkDay;
        }
      }
    }

    check ? setupDataRoster() : showAlertIncorrectDate(message: message);
  }

  void showAlertIncorrectDate({String? message}) {
    DialogCustom.showSnackBar(
        title: Texts.alert, message: message ?? Texts.plsSelectStartEndTime);
  }

  void showAlertIncorrecrtTime() {
    DialogCustom.showSnackBar(title: Texts.alert, message: Texts.incorrectDate);
  }

  void removeSelectDay(int index, String day, bool isDayOff) {
    if (isDayOff) {
      shiftList[index].selectedDay.remove(day);
    } else {
      shiftList[index].selectedDay.add(day);
    }
  }

  void removeSchedule(int index, int indexShift) {
    shiftList[index].workDayType[indexShift].forEach((key, value) {
      if (value == Keys.workDay) {
        shiftList[index].selectedDay.remove(key);
      }
    });
    shiftList[index].workDayType.removeAt(indexShift);
    shiftList[index].placeList.removeAt(indexShift);
  }

  void onSelectedWorkingHours(WorkingHoursModel workingHoursModel) {
    selectedWorkingHours.value = workingHoursModel;
    _workDayDefualt = {
      Keys.sunday: workingHoursModel.sunday ?? Keys.dayOff,
      Keys.monday: workingHoursModel.monday ?? Keys.dayOff,
      Keys.tuesday: workingHoursModel.tuesday ?? Keys.dayOff,
      Keys.wednesday: workingHoursModel.wednesday ?? Keys.dayOff,
      Keys.thursday: workingHoursModel.thursday ?? Keys.dayOff,
      Keys.friday: workingHoursModel.friday ?? Keys.dayOff,
      Keys.saturday: workingHoursModel.saturday ?? Keys.dayOff
    };
    if (shiftList.isNotEmpty) {
      shiftList.clear();
      shiftID = 1;
    }
  }

  void onClickCancel() async {
    DialogCustom.showBasicAlertOkCancel(Texts.askCancelDayoff,
        onPressed: (() async {
      Get.back();
      await callAPICancelRoster();
    }));
  }

  Future callAPICancelRoster() async {
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
