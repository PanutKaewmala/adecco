import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/services/export_services.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';
import 'create_ot_text_ctrl.dart';

class CreateOTController extends GetxController with StateMixin {
  final PageType? pageType;
  final int? id;
  BuildContext context;
  CreateOTController(this.context, {this.pageType, this.id});

  final ScrollController listViewCtrl = ScrollController();
  late OvertimeService overtimeService;
  final showQuota = false.obs;
  bool? validation;
  final CreateOTTextController textController = CreateOTTextController();
  final startDate = Rx<DateTime?>(null);
  final endDate = Rx<DateTime?>(null);
  final Rx<DropDownModel?> selectedWorkPlace = Rx(null);
  var workPlaceList = <DropDownModel>[].obs;
  List<String> locationStringList = [];
  final overTimeQuotaModel = Rx<OverTimeQuotaModel?>(null);
  OvertimeEditModel? overTimeEditModel;
  final disableButton = true.obs;

  @override
  void onInit() {
    overtimeService = OvertimeService();
    callAllAPI();
    super.onInit();
  }

  @override
  void onClose() {
    listViewCtrl.dispose();
    textController.dispose();
    super.onClose();
  }

  Future callAllAPI() async {
    change(null, status: RxStatus.loading());
    try {
      await callAPILocations();
      if (pageType == PageType.edit) {
        await callAPIOvertimeEdit();
        disableButton.value = enableButton();
      } else {
        disableButton.value = false;
      }
      change(null, status: RxStatus.success());
    } catch (e) {
      debugPrint("--- $e");
      change(null, status: RxStatus.error());
    }
  }

  void onClickCreate() {
    Get.focusScope!.unfocus();
    validation = textController.isDataValid();
    if ((validation ?? false)) {
      checkValidate();
    }
  }

  void checkValidate() {
    String message = "";

    if (selectedWorkPlace.value == null) {
      message = Texts.plsSelectLocation;
    }
    if (startDate.value == null || endDate.value == null) {
      message = Texts.plsSelectStartEndTime;
    }

    debugPrint("message ${selectedWorkPlace.value}");

    if (message.isEmpty) {
      callAPICreateOverTime();
    } else {
      DialogCustom.showSnackBar(title: Texts.alert, message: message);
    }
  }

  void onClickSelectWorkPlace() {
    showCupertinoStringPicker(context, Texts.plsSelectLocation,
        stringList: locationStringList,
        selected: selectedWorkPlace.value?.label, onPressed: (index) {
      selectedWorkPlace.value = workPlaceList[index];
    });
  }

  bool enableButton() {
    return overTimeEditModel == null ||
        overTimeEditModel?.status == Keys.approve;
  }

  Future callAPIOvertimeQuota() async {
    try {
      await overtimeService.getOvertimeQuota().then((value) async {
        overTimeQuotaModel.value = value;
      });
    } catch (e) {
      debugPrint("$e");
    }
  }

  Future setUpEditData() async {
    try {
      textController.title.text = overTimeEditModel?.title ?? "";
      textController.description.text = overTimeEditModel?.description ?? "";

      selectedWorkPlace.value = workPlaceList
          .where((item) => item.label == overTimeEditModel!.workplace.name)
          .first;

      String _startTime = overTimeEditModel!.start_time;
      String _endTime = overTimeEditModel!.end_time;
      startDate.value = DateTimeService.timeServerToDateTimeWithFormat(
          overTimeEditModel!.start_date + " " + _startTime,
          format: DateTimeFormatCustom.ddmmmyyyyhhmmss);
      endDate.value = DateTimeService.timeServerToDateTimeWithFormat(
          overTimeEditModel!.end_date + " " + _endTime,
          format: DateTimeFormatCustom.ddmmmyyyyhhmmss);
    } catch (e) {
      rethrow;
    }
  }

  Future callAPICreateOverTime() async {
    LoadingCustom.showOverlay(context);
    try {
      var data = {
        "id": "${UserConfig.session!.user.id}",
        "start_date": DateTimeService.getStringTimeServer(startDate.value!),
        "end_date": DateTimeService.getStringTimeServer(endDate.value!),
        "start_time": DateTimeService.getStringDateTimeFormat(startDate.value!,
            format: DateTimeFormatCustom.hhmm),
        "end_time": DateTimeService.getStringDateTimeFormat(endDate.value!,
            format: DateTimeFormatCustom.hhmm),
        "description": textController.description.text,
        "workplace": selectedWorkPlace.value!.value,
        "title": textController.title.text,
        "project": UserConfig.getProjectID()
      };

      if (pageType == PageType.create) {
        await overtimeService.postOvertimeRequest(data);
      } else {
        await overtimeService.patchOvertime(data, id!);
      }

      LoadingCustom.hideOverlay(context);
      DialogCustom.showBasicAlert(Texts.saveSuccess,
          onPressed: () => Get.back(result: true));
    } catch (e) {
      LoadingCustom.hideOverlay(context);
      DialogCustom.showBasicAlert("$e");
    }
  }

  Future callAPILocations() async {
    try {
      await overtimeService.getWorkPlace().then((value) async {
        workPlaceList.assignAll(value);
        locationStringList = List.generate(
            workPlaceList.length, (index) => workPlaceList[index].label);
        debugPrint("locationStringList $locationStringList");

        if (selectedWorkPlace.value != null) {
          for (DropDownModel item in value) {
            if (item.value == selectedWorkPlace.value!.value) {
              selectedWorkPlace.value = item;
            }
          }
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Future callAPIOvertimeEdit() async {
    try {
      await overtimeService.getOvertimeEdit(id!).then((value) async {
        overTimeEditModel = value;
      });
      await setUpEditData();
    } catch (e) {
      rethrow;
    }
  }

  void onClickCancel() async {
    DialogCustom.showBasicAlertOkCancel(Texts.askOTRequest,
        onPressed: (() async {
      Get.back();
      await callAPICancelOvertimeRequest();
    }));
  }

  Future callAPICancelOvertimeRequest() async {
    LoadingCustom.showOverlay(context);
    try {
      await overtimeService.cancelOvertime(id!).then((value) async {
        LoadingCustom.hideOverlay(context);
      });
      DialogCustom.showBasicAlert(Texts.saveSuccess,
          onPressed: () => Get.back(result: true));
    } catch (e) {
      LoadingCustom.hideOverlay(context);
      DialogCustom.showBasicAlert("$e");
    }
  }
}
