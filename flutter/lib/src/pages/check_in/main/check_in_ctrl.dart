import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/pages/check_in/model/check_in_model.dart';
import 'package:ahead_adecco/src/services/check_in.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class CheckInController extends GetxController
    with StateMixin<List<CheckInTasksModel>> {
  BuildContext context;
  CheckInController(this.context);
  late CheckInService checkInService;

  String timeNow = DateTimeService.getStringTimeNowFormat(
      format: DateTimeFormatCustom.yyyymmdd);

  Position? currrentPosition;
  Placemark? address;
  AddressNameModel? positionName;
  final disableCheckin = true.obs;
  bool isCheckIn = true;
  final Rx<LocationModel?> selectedLocation = Rx(null);
  var locationList = <LocationModel>[].obs;
  List<String> locationStringList = [];
  final ScrollController listViewCtrl = ScrollController();
  final workPlaceSize = 0.obs;
  final TextEditingController description = TextEditingController();
  final tabList = [true.obs, false.obs, false.obs];
  final isSelected = 0.obs;
  TabbarTypeCheckIn _tabbarType = TabbarTypeCheckIn.shop;

  @override
  void onInit() {
    checkInService = CheckInService();
    callAllAPI();
    super.onInit();
  }

  @override
  void onClose() {
    listViewCtrl.dispose();
    description.dispose();
    super.onClose();
  }

  Future callAllAPI() async {
    try {
      LoadingCustom.showOverlay(context);
      await getLocation();
      await Future.wait([callAPIDailyTask(), callAPILocations()]);
      LoadingCustom.hideOverlay(context);
      if (currrentPosition == null) {
        DialogCustom.showBasicAlert(Texts.plsEnableLocation);
      }
    } catch (e) {
      debugPrint("currrentPosition $currrentPosition");
      LoadingCustom.hideOverlay(context);
    }
  }

  Future refreshData() async {
    await callAllAPI();
  }

  void onClickSelectLocation() {
    // * Old Popup
    // showCupertinoStringPicker(context, Texts.plsSelectLocation,
    //     stringList: locationStringList,
    //     selected: selectedLocation.value?.workplace.name, onPressed: (index) {
    //   selectedLocation.value = locationList[index];

    //   if (selectedLocation.value!.activity.check_in != null) {
    //     isCheckIn = false;
    //   } else {
    //     isCheckIn = true;
    //   }
    //   if ((selectedLocation.value!.activity.check_in != null &&
    //           selectedLocation.value!.activity.check_out != null) ||
    //       selectedLocation.value!.activity.check_out != null) {
    //     disableCheckin.value = true;
    //   } else {
    //     disableCheckin.value = false;
    //   }
    // });
    Get.toNamed(Routes.checkInLocation,
            arguments: {Keys.data: locationStringList})!
        .then((value) {
      selectedLocation.value = locationList[value];

      if (selectedLocation.value!.activity.check_in != null) {
        isCheckIn = false;
      } else {
        isCheckIn = true;
      }
      if ((selectedLocation.value!.activity.check_in != null &&
              selectedLocation.value!.activity.check_out != null) ||
          selectedLocation.value!.activity.check_out != null) {
        disableCheckin.value = true;
      } else {
        disableCheckin.value = false;
      }
    });
  }

  Future getLocation() async {
    try {
      currrentPosition = await LocationService().determinePosition();
      if (currrentPosition != null) {
        positionName =
            await LocationService().getLocationAddressModel(currrentPosition!);
      }
    } catch (e) {
      debugPrint("map error: $e");
    }
  }

  bool validateSelectLocation() {
    if (selectedLocation.value == null) {
      DialogCustom.showSnackBar(message: Texts.plsSelectLocation);
      return false;
    }
    return true;
  }

  void checkInOtTimeOT(bool isCreatePinPoint) {
    DateTime _now = DateTime.now();
    if (selectedLocation.value?.working_hour != null &&
        selectedLocation.value?.working_hour?.id != null) {
      if (isCheckIn) {
        DateTime _beforeTime = DateTimeService.timeServerHHmmToDateTime(
            selectedLocation.value!.working_hour!.start_time!.before);
        if (_now.isBefore(_beforeTime)) {
          DialogCustom.showBasicAlertWithTextFeild(
              Texts.earlyCheckIn, description, onPressed: () {
            Get.back();
            goToCheckInMap(isCreatePinPoint, isOT: true);
          }, onPressedBack: () {
            goToCheckInMap(isCreatePinPoint);
          }, text1: Texts.no, text2: Texts.yes);
        } else {
          goToCheckInMap(isCreatePinPoint);
        }
      } else {
        DateTime _afterTime = DateTimeService.timeServerHHmmToDateTime(
            selectedLocation.value!.working_hour!.end_time!.after);
        if (_now.isAfter(_afterTime)) {
          DialogCustom.showBasicAlertWithTextFeild(
              Texts.afterCheckOut, description, onPressed: () {
            Get.back();
            goToCheckInMap(isCreatePinPoint, isOT: true);
          }, onPressedBack: () {
            goToCheckInMap(isCreatePinPoint);
          }, text1: Texts.no, text2: Texts.yes);
        } else {
          goToCheckInMap(isCreatePinPoint);
        }
      }
    } else {
      goToCheckInMap(isCreatePinPoint);
    }
  }

  void onClickCheckIn(bool isCreatePinPoint) async {
    if (isCreatePinPoint) {
      goToCheckInMap(isCreatePinPoint);
    } else {
      if (checkOutTime15min() && validateSelectLocation()) {
        checkInOtTimeOT(isCreatePinPoint);
      }
    }
  }

  void goToCheckInMap(bool isCreatePinPoint, {bool isOT = false}) async {
    LoadingCustom.showOverlay(context);
    await getLocation();
    LoadingCustom.hideOverlay(context);
    if (positionName != null) {
      debugPrint(
          "currrentPosition: $currrentPosition positionName: ${positionName!.address}");
      CheckInData checkInData = CheckInData(
          workPlaceID: selectedLocation.value?.workplace.id,
          workingHourID: selectedLocation.value?.working_hour?.id,
          posiotion: currrentPosition!,
          addressNameModel: positionName!,
          checkInTime: checkInTime(),
          isOT: isOT,
          pair_id: selectedLocation.value?.activity.pair_id,
          description: description.text,
          checkInPageType: isCreatePinPoint
              ? CheckInPageType.pinPoint
              : isCheckIn
                  ? CheckInPageType.checkIn
                  : CheckInPageType.checkOut);
      Get.toNamed(Routes.checkInMap, arguments: checkInData)?.then((value) =>
          onBackRefresh(function: () => refreshData(), value: value));
    } else {
      DialogCustom.showBasicAlert(Texts.plsEnableLocation);
    }
  }

  bool checkOutTime15min() {
    if (selectedLocation.value!.activity.check_in != null) {
      var _checkInTime = DateTimeService.timeServerToDateTime(
          selectedLocation.value!.activity.check_in!);
      int _time = DateTime.now().difference(_checkInTime).inSeconds;
      if (_time < 120) {
        DialogCustom.showSnackBar(
            title: Texts.alert, message: Texts.canCheckOutAfter2Min);
        return false;
      }
      return true;
    } else {
      return true;
    }
  }

  void onPressedTab(TabbarTypeCheckIn tabbarType) async {
    // clearPage();
    isSelected.value = tabbarType.index;
    for (int i = 0; i < tabList.length; i++) {
      tabList[i].value = i == tabbarType.index;
    }
    switch (tabbarType) {
      case TabbarTypeCheckIn.shop:
        _tabbarType = TabbarTypeCheckIn.shop;
        break;
      case TabbarTypeCheckIn.workPlace:
        _tabbarType = TabbarTypeCheckIn.workPlace;
        break;

      default:
    }
    LoadingCustom.showOverlay(context);
    await refreshData();
    LoadingCustom.hideOverlay(context);
  }

  String checkInTime() {
    String _time = "";
    if (selectedLocation.value?.activity.check_in != null) {
      _time = selectedLocation.value!.activity.check_in!;
    }
    return _time;
  }

  Future callAPIDailyTask() async {
    try {
      String _date = DateTimeService.getStringDateTimeFormat(DateTime.now(),
          format: DateTimeFormatCustom.yyyymmdd);
      var params = {
        "date": _date,
        "project": UserConfig.getProjectID().toString(),
        "latitude": currrentPosition!.latitude.toString(),
        "longitude": currrentPosition!.longitude.toString()
      };
      await checkInService.checkIndailyTask(params).then((value) async {
        List<CheckInTasksModel> _dailyTaskList = [];
        workPlaceSize.value = value.length;
        for (var item in value) {
          _dailyTaskList.add(item);
        }
        if (_dailyTaskList.isNotEmpty) {
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

  Future callAPILocations() async {
    try {
      String _date = DateTimeService.getStringDateTimeFormat(DateTime.now(),
          format: DateTimeFormatCustom.yyyymmdd);
      var params = {
        "date": _date,
        "project": "${UserConfig.employeeProjectModel!.project.id}"
      };
      await checkInService.location(params).then((value) async {
        locationList.assignAll(value);
        locationStringList = List.generate(
            locationList.length, (index) => locationList[index].workplace.name);
        debugPrint("locationStringList $locationStringList");

        if (selectedLocation.value != null) {
          for (LocationModel item in value) {
            if (item.workplace.id == selectedLocation.value!.workplace.id) {
              selectedLocation.value = item;
            }
          }
        }
      });
    } catch (e) {
      rethrow;
    }
  }
}
