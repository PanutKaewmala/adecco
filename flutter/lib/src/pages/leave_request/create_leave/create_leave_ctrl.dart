import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/pages/leave_request/create_leave/create_leave_text_ctrl.dart';
import 'package:ahead_adecco/src/services/export_services.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class CreateLeaveController extends GetxController with StateMixin {
  final PageType? pageType;
  final int? id;
  BuildContext context;
  CreateLeaveController(this.context,
      {required this.pageType, required this.id});

  final showQuota = false.obs;

  final leaveType = Rx<LeaveTypeDetailModel?>(null);
  final allDay = false.obs;
  final ScrollController listViewCtrl = ScrollController();
  final fileList = <File>[].obs;
  final uploadAttachmentModelList = <UploadAttachmentModel>[].obs;
  final startDate = Rx<DateTime?>(null);
  final endDate = Rx<DateTime?>(null);
  final leaveQuotaDetailList = <LeaveQuotaModel>[].obs;
  final leaveTypeList = <LeaveTypeDetailModel>[].obs;
  bool? validation;
  final CreateLeaveTextController textController = CreateLeaveTextController();

  late LeaveRequestService leaveRequestService;
  LeaveRequestDetailModel? leaveRequestDetailModel;
  final disableButton = true.obs;

  @override
  void onInit() {
    leaveRequestService = LeaveRequestService();
    callAllAPI();
    super.onInit();
  }

  @override
  void onClose() {
    textController.dispose();
    listViewCtrl.dispose();
    leaveRequestService.close();
    super.onClose();
  }

  Future callAllAPI() async {
    change(null, status: RxStatus.loading());
    try {
      await Future.wait([callAPILeaveQuota(), callAPILeaveType()]);

      if (pageType == PageType.edit) {
        await callAPILeaveRequestDetail();
        disableButton.value = enableButton();
      } else {
        disableButton.value = false;
      }
      change(null, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error());
    }
  }

  void setDate(bool isStartDate, DateTime dateTime) {
    Get.focusScope!.unfocus();
    DateTime _now = DateTime.now();
    if (isStartDate) {
      endDate.value = null;
      startDate.value = DateTime(
          dateTime.year, dateTime.month, dateTime.day, _now.hour, _now.minute);
    } else {
      if (dateTime.difference(startDate.value!).inDays < 0) {
        DialogCustom.showSnackBar(
            title: Texts.alert, message: Texts.incorrectDate);
      } else {
        endDate.value = DateTime(dateTime.year, dateTime.month, dateTime.day,
            startDate.value!.hour, startDate.value!.minute);
        if (dateTime.difference(startDate.value!).inMinutes < 15) {
          endDate.value = endDate.value!.add(const Duration(minutes: 15));
        }
      }
    }
  }

  void onToggleAllDay(bool value) {
    allDay.value = value;
    startDate.value = null;
    endDate.value = null;
  }

  void setTime(bool isStartTime, DateTime selectDate) {
    if (isStartTime) {
      startDate.value = selectDate;
    } else {
      DateTime adjust = selectDate.add(const Duration(minutes: -14));
      if (startDate.value!.isBefore(adjust)) {
        endDate.value = selectDate;
      } else {
        DialogCustom.showSnackBar(
            title: Texts.alert, message: Texts.incorrectTime);
      }
    }
  }

  void addFile(File file) {
    fileList.add(file);
  }

  void onClickAddFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'pdf', 'doc', 'docx', 'png', 'xls'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      addFile(file);
    } else {}
  }

  void removeFile(int index) {
    fileList.removeAt(index);
  }

  void onClickCreate() {
    Get.focusScope!.unfocus();
    validation = textController.isDataValid();
    if ((validation ?? false)) {
      checkValidate();
    }
  }

  Future callAPILeaveQuota() async {
    try {
      await leaveRequestService.leaveQuotaDetail().then((value) async {
        if (value.isNotEmpty) {
          leaveQuotaDetailList.assignAll(value);
        }
      });
    } catch (e) {
      debugPrint("$e");
    }
  }

  Future callAPILeaveType() async {
    try {
      await leaveRequestService.leaveType().then((value) async {
        if (value.isNotEmpty) {
          leaveTypeList.assignAll(value);
        }
      });
    } catch (e) {
      debugPrint("$e");
    }
  }

  Future callAPILeaveRequestDetail() async {
    try {
      await leaveRequestService.leaveRequestById(id!).then((value) {
        leaveRequestDetailModel = value;
      });
      await setUpEditData();
    } catch (e) {
      debugPrint("$e");
    }
  }

  Future setUpEditData() async {
    try {
      textController.title.text = leaveRequestDetailModel?.title ?? "";
      textController.description.text =
          leaveRequestDetailModel?.description ?? "";

      leaveType.value = leaveTypeList
          .where((item) => item.label == leaveRequestDetailModel!.type)
          .first;

      allDay.value = leaveRequestDetailModel!.all_day;
      String _startTime = leaveRequestDetailModel?.start_time ?? "00:00";
      String _endTime = leaveRequestDetailModel?.end_time ?? "00:00";
      startDate.value = DateTimeService.timeServerToDateTimeWithFormat(
          leaveRequestDetailModel!.start_date + " " + _startTime,
          format: DateTimeFormatCustom.ddmmmyyyyhhmm);
      endDate.value = DateTimeService.timeServerToDateTimeWithFormat(
          leaveRequestDetailModel!.end_date + " " + _endTime,
          format: DateTimeFormatCustom.ddmmmyyyyhhmm);

      uploadAttachmentModelList
          .addAll(leaveRequestDetailModel!.upload_attachments);
    } catch (e) {
      rethrow;
    }
  }

  void callAPICreateLeave() async {
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
        "all_day": "${allDay.value}",
        "title": textController.title.text,
        "description": textController.description.text,
        "type": "${leaveType.value!.value}",
        "project": UserConfig.getProjectID()
      };
      if (pageType == PageType.create) {
        int _id = await leaveRequestService.createLeave(data, fileList);
        await callAPIUploadAttachment(_id);
      } else {
        await leaveRequestService.patchLeave(data, fileList, id!);
        await callAPIUploadAttachment(id!);
      }
      LoadingCustom.hideOverlay(context);
      DialogCustom.showBasicAlert(Texts.saveSuccess,
          onPressed: () =>
              Get.back(result: {"date": startDate.value, "value": true}));
    } catch (e) {
      LoadingCustom.hideOverlay(context);
      DialogCustom.showBasicAlert("$e");
    }
  }

  void checkValidate() {
    String message = "";
    if (startDate.value == null || endDate.value == null) {
      message = Texts.plsSelectStartEndTime;
    }
    if (leaveType.value == null) {
      message = Texts.plsSelectLeaveType;
    }

    if (message.isEmpty) {
      callAPICreateLeave();
    } else {
      DialogCustom.showSnackBar(title: Texts.alert, message: message);
    }
  }

  Future callAPIUploadAttachment(int id) async {
    if (fileList.isNotEmpty) {
      try {
        var data = {"leave_request": "$id"};
        await leaveRequestService.fileUploadAttachment(data, fileList);
      } catch (e) {
        debugPrint("$e");
        rethrow;
      }
    }
  }

  Future callAPIRefreshUploadAttachment() async {
    try {
      await leaveRequestService.refreshFileUploadAttachment(id!).then((value) {
        uploadAttachmentModelList.assignAll(value);
      });
    } catch (e) {
      rethrow;
    }
  }

  Future callAPIRemoveUploadAttachment(int index) async {
    LoadingCustom.showOverlay(context);
    try {
      await leaveRequestService
          .deleteUploadAttachment(uploadAttachmentModelList[index].id)
          .then((value) async {
        await callAPIRefreshUploadAttachment();
        LoadingCustom.hideOverlay(context);
      });
    } catch (e) {
      LoadingCustom.hideOverlay(context);
      DialogCustom.showBasicAlert("$e");
    }
  }

  Future callAPICancelLeaveRequest() async {
    LoadingCustom.showOverlay(context);
    try {
      await leaveRequestService.cancelLeaveRequest(id!).then((value) async {
        LoadingCustom.hideOverlay(context);
      });
      DialogCustom.showBasicAlert(Texts.saveSuccess,
          onPressed: () => Get.back(result: true));
    } catch (e) {
      LoadingCustom.hideOverlay(context);
      DialogCustom.showBasicAlert("$e");
    }
  }

  void onClickRemoveAttachment(int index) {
    DialogCustom.showBasicAlertOkCancel(Texts.confirmRemove,
        textButton: Texts.confirm, onPressed: () async {
      Get.back();
      await callAPIRemoveUploadAttachment(index);
    });
  }

  void onClickCancel() async {
    DialogCustom.showBasicAlertOkCancel(Texts.askCancelRequest,
        onPressed: (() async {
      Get.back();
      await callAPICancelLeaveRequest();
    }));
  }

  void onClickSaveAttachment() async {
    DialogCustom.showBasicAlertOkCancel(Texts.askCancelRequest,
        onPressed: (() async {
      Get.back();
      LoadingCustom.showOverlay(context);
      try {
        await callAPIUploadAttachment(id!).then((value) async {
          LoadingCustom.hideOverlay(context);
        });
        DialogCustom.showBasicAlert(Texts.saveSuccess,
            onPressed: () => Get.back(result: true));
      } catch (e) {
        LoadingCustom.hideOverlay(context);
        DialogCustom.showBasicAlert("$e");
      }
    }));
  }

  bool enableButton() {
    return leaveRequestDetailModel == null ||
        leaveRequestDetailModel?.status == Keys.approve;
  }
}
