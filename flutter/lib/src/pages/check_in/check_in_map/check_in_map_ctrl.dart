import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/pages/check_in/model/check_in_model.dart';
import 'package:ahead_adecco/src/services/export_services.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class CheckInMapContoller extends GetxController {
  final CheckInData checkInData;
  BuildContext context;
  CheckInMapContoller(this.context, {required this.checkInData});

  late CheckInService checkInService;
  final TextEditingController remark = TextEditingController();
  final TextEditingController workPlaceName = TextEditingController();

  final checkInTime = DateTime.now().obs;
  final checkOutTime = DateTime.now().obs;
  final isAdjustTime = false.obs;
  final isCheckIn = true.obs;
  final showMapDelay = false.obs;
  Rx<bool?> isInRadius = Rx(null);
  File? file;

  late LatLng latLng;
  final locationAddress = "".obs;

  @override
  void onInit() {
    latLng =
        LatLng(checkInData.posiotion.latitude, checkInData.posiotion.longitude);
    locationAddress.value = checkInData.addressNameModel.address;

    checkInService = CheckInService();
    callAPICheckRadius();
    isCheckIn.value = checkInData.checkInPageType == CheckInPageType.checkIn;

    if (checkInData.checkInPageType == CheckInPageType.checkOut &&
        checkInData.checkInTime.isNotEmpty) {
      checkInTime.value =
          DateTimeService.timeServerToDateTime(checkInData.checkInTime);
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      showMapDelay.value = true;
    });
    workPlaceName.text = checkInData.addressNameModel.name;
    super.onInit();
  }

  @override
  void onClose() {
    remark.dispose();
    checkInService.close();
    super.onClose();
  }

  void onClickCheckIn() {
    if (isInRadius.value!) {
      checkAdjustTime();
    } else {
      DialogCustom.showBasicAlertOkCancel(Texts.outOfRadius, onPressed: () {
        Get.back();
        checkAdjustTime();
      });
    }
  }

  void checkAdjustTime() {
    if (isAdjustTime.value) {
      showDiaLogAdjustingTime();
    } else {
      showDiaLogRemark();
    }
  }

  Future<bool> goToTakePhoto({bool isCreatePinPoint = false}) async {
    LoadingCustom.showOverlay(context);
    var isNotEmu = await IsSimulator.isRealDevice();
    if (isNotEmu) {
      final List<CameraDescription> cameras = await availableCameras();
      LoadingCustom.hideOverlay(context);
      debugPrint("checkInData.checkInPageType ${checkInData.checkInPageType}");
      file = await Get.to(() => CameraScreen(
            cameras: cameras,
            showRearCamera:
                checkInData.checkInPageType == CheckInPageType.pinPoint,
          ));
      if (file != null) {
        !isCreatePinPoint ? callAPICheckInOut() : null;
        return true;
      }
      return false;
    } else {
      LoadingCustom.hideOverlay(context);
      return false;
    }
  }

  void adjustingTime(DateTime time) {
    if (isCheckIn.value) {
      debugPrint("time ${checkInTime.value} $time");
      checkInTime.value = time;
      isAdjustTime.value = true;
    } else {
      checkOutTime.value = time;
      isAdjustTime.value = true;
    }
  }

  void showDiaLogAdjustingTime() {
    DialogCustom.showBasicAlertWithTextFeild(Texts.plsAddReason, remark,
        onPressed: () {
      if (remark.text.isEmpty) {
        DialogCustom.showSnackBar(
            title: Texts.alert, message: Texts.plsEnterReason);
      } else {
        Get.back();
        goToTakePhoto();
      }
    });
  }

  void showDiaLogRemark() {
    DialogCustom.showBasicAlertWithTextFeild(Texts.remarks, remark,
        onPressed: () {
      Get.back();
      goToTakePhoto();
    });
  }

  bool isPinPointOrTrackRoute() {
    return checkInData.checkInPageType == CheckInPageType.pinPoint ||
        checkInData.checkInPageType == CheckInPageType.trackRoute;
  }

  bool isCheckInOrCheckOut() {
    return checkInData.checkInPageType == CheckInPageType.checkIn ||
        checkInData.checkInPageType == CheckInPageType.checkOut;
  }

  Future<int?> callAPICheckInOut({bool isCreatePinPoint = false}) async {
    debugPrint("isCreatePinPoint $isCreatePinPoint");
    !isCreatePinPoint ? LoadingCustom.showOverlay(context) : null;
    try {
      bool isCheckIn = checkInData.checkInPageType == CheckInPageType.checkIn;
      String time = DateTimeService.getStringDateTimeFormat(
          isCheckIn ? checkInTime.value : checkOutTime.value,
          format: DateTimeFormatCustom.yyyymmddThhmm);
      Map<String, String> data = {
        "type": pageType(),
        "date_time": time,
        "location_address": checkInData.addressNameModel.name +
            " " +
            checkInData.addressNameModel.address,
        "latitude": "${checkInData.posiotion.latitude}",
        "longitude": "${checkInData.posiotion.longitude}",
        "project": UserConfig.getProjectID().toString(),
      };

      if (checkInData.description.isNotEmpty) {
        data.addAll({"description": checkInData.description});
      }
      if (isAdjustTime.value) {
        data.addAll({"reason_for_adjust_time": remark.text});
      } else if (remark.text.isNotEmpty) {
        data.addAll({"remark": remark.text});
      }
      if (isPinPointOrTrackRoute()) {
        data.addAll({"location_name": workPlaceName.text});
      }
      if (isCheckInOrCheckOut() && checkInData.workPlaceID != null) {
        data.addAll({
          "workplace": "${checkInData.workPlaceID}",
        });
      }
      if (isCheckInOrCheckOut() && checkInData.workingHourID != null) {
        data.addAll({
          "workplace": "${checkInData.workPlaceID}",
          "working_hour": "${checkInData.workingHourID}"
        });
      }

      if (checkInData.isOT) {
        data.addAll(
            {"extra_type": "ot", "description": checkInData.description});
      }

      if (isCheckInOrCheckOut() && !isCheckIn) {
        data.addAll({
          "pair_id": "${checkInData.pair_id}",
        });
      }

      debugPrint("data $data");
      var checkInID = await checkInService.checkInOut(data, file);
      if (isCreatePinPoint) {
        return checkInID;
      } else {
        LoadingCustom.hideOverlay(context);
        DialogCustom.showBasicAlert(Texts.saveSuccess,
            onPressed: (() => Get.back(result: true)));
      }
    } catch (e) {
      if (isCreatePinPoint) {
        rethrow;
      } else {
        LoadingCustom.hideOverlay(context);
        DialogCustom.showBasicAlert("$e");
      }
    }
    return null;
  }

  void callAPICheckRadius() async {
    try {
      Map<String, Object> data = {
        "workplace": checkInData.workPlaceID!,
        "latitude": "${checkInData.posiotion.latitude}",
        "longitude": "${checkInData.posiotion.longitude}",
      };
      isInRadius.value = await checkInService.checkRadius(data);
    } catch (e) {
      debugPrint("e $e");
      isInRadius.value = null;
    }
  }

  Future callAPIPinPointDropDown() async {
    LoadingCustom.showOverlay(context);
    try {
      Map<String, String> param = {
        "type": Keys.pinPointType,
        "employee_project": UserConfig.getEmployeeProjectID().toString()
      };
      List<DropDownModel> dropDown =
          await checkInService.pinPointTypeDropDown(param);
      List<String> _pinPointTpeList =
          List.generate(dropDown.length, (index) => dropDown[index].label);
      LoadingCustom.hideOverlay(context);
      context.showBottomSheetCustom(
          onTap: (index) {
            checkInData.checkInPageType = CheckInPageType.pinPoint;
            Get.toNamed(Routes.createPinPoint,
                arguments: {Keys.id: dropDown[index].value});
          },
          item: _pinPointTpeList,
          title: Texts.plsSelectAct);
    } catch (e) {
      LoadingCustom.hideOverlay(context);
      rethrow;
    }
  }

  void onClickCreatePinPoint() async {
    LatLng _currentLatLng =
        LatLng(checkInData.posiotion.latitude, checkInData.posiotion.longitude);
    bool checkRadius =
        LocationService().checkRadiusBetween(latLng, _currentLatLng, 200);
    try {
      checkRadius
          ? await callAPIPinPointDropDown()
          : DialogCustom.showBasicAlert(Texts.outOfRadiusPinPoint);
    } catch (e) {
      DialogCustom.showBasicAlert(e.toString());
    }
  }

  void onClickCreateTrackRoute() {
    checkInData.checkInPageType = CheckInPageType.trackRoute;
    DialogCustom.showBasicAlertWithTextFeild(Texts.remarks, remark,
        onPressed: () {
      Get.back();
      callAPICheckInOut();
    });
  }

  void onTapMap(LatLng latLng) async {
    this.latLng = latLng;
    AddressNameModel? addressNameModel =
        await LocationService().getLocationAddressModelLatLng(latLng);
    locationAddress.value = addressNameModel?.address ?? '';
    workPlaceName.text = addressNameModel?.name ?? '';
  }

  String pageType() {
    switch (checkInData.checkInPageType) {
      case CheckInPageType.checkIn:
        return Keys.checkIn;
      case CheckInPageType.checkOut:
        return Keys.checkOut;
      case CheckInPageType.pinPoint:
        return Keys.pinPoint;
      case CheckInPageType.trackRoute:
        return Keys.trackRoute;
      default:
        return Keys.checkIn;
    }
  }
}
