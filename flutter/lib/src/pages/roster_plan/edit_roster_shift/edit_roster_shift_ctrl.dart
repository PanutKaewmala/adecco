import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/pages/roster_plan/create_roster/create_roster_model.dart';
import 'package:ahead_adecco/src/utils/validate_string.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import '../../../constants/export_constants.dart';
import '../../../services/roster.dart';

class EditRosterShiftController extends GetxController with StateMixin {
  final int shiftID;
  final int rosterID;
  BuildContext context;
  EditRosterShiftController(
      {required this.context, required this.shiftID, required this.rosterID})
      : super();
  final TextEditingController remark = TextEditingController();
  final ScrollController listViewCtrl = ScrollController();
  final workPlaceList = <PlaceRosterModel>[].obs;
  final workingTimeList = <WorkingHoursModel>[].obs;
  late ShiftDataModel shiftDataModel;
  final startDate = Rx<DateTime?>(null);
  final endDate = Rx<DateTime?>(null);
  final selectedWorkingHours = Rx<WorkingHoursModel?>(null);
  List<MultiSelectItem<PlaceRosterModel>> multiSelectWorkPlaceList = [];
  Map<String, String> _workDayDefualt = {};
  final RosterPlanService rosterPlanService = RosterPlanService();
  final showDayDetail = false.obs;

  @override
  void onInit() {
    callAllAPI();
    super.onInit();
  }

  @override
  void dispose() {
    listViewCtrl.dispose();
    rosterPlanService.close();
    super.dispose();
  }

  void initData(ShiftDetailEditModel shiftDetailEditModel) {
    try {
      remark.text = shiftDetailEditModel.remark ?? '';

      DateTime _formDate =
          DateTimeService.timeServerToDateTime(shiftDetailEditModel.from_date!);
      DateTime _toDate =
          DateTimeService.timeServerToDateTime(shiftDetailEditModel.to_date!);
      startDate.value = _formDate;
      endDate.value = _toDate;
      shiftDataModel = ShiftDataModel(id: 1);

      for (var element in workingTimeList) {
        if (element.id == shiftDetailEditModel.working_hour) {
          selectedWorkingHours.value = element;
        }
      }
      onSelectedWorkingHours(selectedWorkingHours.value!, false);

      shiftDataModel.startDate.value = startDate.value;
      shiftDataModel.endDate.value = endDate.value;
      checkMaxDay(shiftDataModel);
      shiftDetailEditModel.schedules.asMap().forEach((key, value) {
        addScheduleEdit(value, shiftDataModel);
      });
    } catch (e) {
      rethrow;
    }
  }

  Future callAllAPI() async {
    change(null, status: RxStatus.loading());
    try {
      await Future.wait([
        callAPIWorkPlaces(),
        callAPIWorkingHours(),
      ]);
      await callAPIRosterEditShiftDetailByID();
      change(null, status: RxStatus.success());
    } catch (e) {
      debugPrint("$e");
      change(null, status: RxStatus.error());
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

  Future callAPIRosterEditShiftDetailByID() async {
    try {
      await rosterPlanService
          .getRosterEditShiftDetailByID(shiftID)
          .then((value) async {
        initData(value);
      });
    } catch (e) {
      rethrow;
    }
  }

  Future callAPIPostRosterShift() async {
    LoadingCustom.showOverlay(context);
    try {
      List<ScheduleModel> _scheduleList = [];
      shiftDataModel.workDayType.asMap().forEach((key, value) {
        List<int> _placeList = [];
        for (var place in shiftDataModel.placeList[key].placeShift) {
          _placeList.add(place.id);
        }
        ScheduleModel _scheduleModel = ScheduleModel(
            monday: value[Keys.monday],
            tuesday: value[Keys.tuesday],
            wednesday: value[Keys.wednesday],
            thursday: value[Keys.thursday],
            friday: value[Keys.friday],
            saturday: value[Keys.saturday],
            sunday: value[Keys.sunday],
            workplaces: _placeList);
        _scheduleList.add(_scheduleModel);
      });
      var _json = _scheduleList.map((e) => e.toJson()).toList();
      var data = {
        "from_shift": shiftID,
        "working_hour": selectedWorkingHours.value!.id,
        "schedules": _json
      };
      if (remark.text.isNotEmptyString()) {
        data.addAll({"remark": remark.text});
      }
      await rosterPlanService.postRosterEditShiftDetail(rosterID, data);
      LoadingCustom.hideOverlay(context);
      DialogCustom.showBasicAlert(Texts.saveSuccess,
          onPressed: () => Get.back(result: true));
    } catch (e) {
      LoadingCustom.hideOverlay(context);
      DialogCustom.showBasicAlert("$e");
      rethrow;
    }
  }

  void removeSelectDay(int index, String day, bool isDayOff) {
    if (isDayOff) {
      shiftDataModel.selectedDay.remove(day);
    } else {
      shiftDataModel.selectedDay.add(day);
    }
  }

  void removeSchedule(int indexShift) {
    shiftDataModel.workDayType[indexShift].forEach((key, value) {
      if (value == Keys.workDay) {
        shiftDataModel.selectedDay.remove(key);
      }
    });
    shiftDataModel.workDayType.removeAt(indexShift);
    shiftDataModel.placeList.removeAt(indexShift);
  }

  void addScheduleEdit(
      ShiftScheduleEditModel scheduleEditModel, ShiftDataModel shiftDataModel) {
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
        if (element.value.id == place) {
          _placeList.add(element.value);
        }
      }
    }
    shiftDataModel.placeList.last.placeShift.addAll(_placeList);
  }

  void onClickAddSchedule() {
    var _mocky = Map<String, String>.from(_workDayDefualt);

    bool canAdd = true;

    if (shiftDataModel.maxWorkDay == (shiftDataModel.selectedDay.length)) {
      canAdd = false;
    } else if (shiftDataModel.workDayType.isNotEmpty) {
      bool checkWorkDay = false;
      shiftDataModel.workDayType.last.forEach((key, value) {
        if (value == Keys.workDay) {
          checkWorkDay = true;
        }
      });
      canAdd = checkWorkDay;
    }

    if (canAdd) {
      shiftDataModel.workDayType.add(_mocky);
      PlaceShift placeShift = PlaceShift();
      shiftDataModel.placeList.add(placeShift);
    } else {
      DialogCustom.showSnackBar(
          title: Texts.alert, message: Texts.cantAddSchedule);
    }
    scrollDown();
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

  void onClickSave() {
    DialogCustom.showBasicAlertOkCancel(Texts.askCreateShift,
        textButton: Texts.save, onPressed: () async {
      Get.back();
      await callAPIPostRosterShift();
    });
  }

  void onSelectedWorkingHours(
      WorkingHoursModel workingHoursModel, bool isOnSelect) {
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
    int maxWorkDay = 0;
    _workDayDefualt.forEach((key, value) {
      if (value == Keys.dayOff) {
        maxWorkDay++;
      }
    });

    shiftDataModel.maxWorkDay = maxWorkDay;
    if (isOnSelect) {
      shiftDataModel.workDayType.clear();
      shiftDataModel.placeList.clear();
      shiftDataModel.selectedDay.clear();
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
}
