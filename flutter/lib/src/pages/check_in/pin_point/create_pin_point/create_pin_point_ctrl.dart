import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/services/export_services.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import '../../check_in_map/check_in_map_ctrl.dart';
import 'create_pin_point_text_ctrl.dart';

class CreatePinPointController extends GetxController with StateMixin {
  final int id;
  BuildContext context;
  CreatePinPointController(this.context, {required this.id});
  late CheckInService checkInService;
  late PinPointModel pinPointModel;
  CreatePinPointTextController? textController;
  bool? validation;
  final CheckInMapContoller _checkInController = Get.find();

  @override
  void onInit() {
    checkInService = CheckInService();
    callAPIPinPointType();
    super.onInit();
  }

  @override
  void onClose() {
    if (textController != null) {
      textController!.dispose();
    }

    super.onClose();
  }

  Future callAPIPinPointType() async {
    try {
      change(null, status: RxStatus.loading());
      pinPointModel = await checkInService.pinPoint(id);
      List<int> notRequiredList = [];
      pinPointModel.questions.asMap().forEach((key, value) {
        if (!value.require) {
          notRequiredList.add(key);
        }
      });
      textController = CreatePinPointTextController(
          length: pinPointModel.questions.length,
          notRequiredList: notRequiredList);
      change(null, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error());
    }
  }

  void onCLickConfirm() {
    Get.focusScope!.unfocus();
    validation = textController!.isDataValid();
    if ((validation ?? false)) {
      callAPICheckIn();
    }
  }

  Future callAPICheckIn() async {
    try {
      bool hasPhoto =
          await _checkInController.goToTakePhoto(isCreatePinPoint: true);
      if (hasPhoto) {
        LoadingCustom.showOverlay(context);
        int? checkInID =
            await _checkInController.callAPICheckInOut(isCreatePinPoint: true);
        debugPrint("checkInID $checkInID");
        await callAPICreatePinPoint(checkInID!);
        LoadingCustom.hideOverlay(context);
        DialogCustom.showBasicAlert(Texts.saveSuccess, onPressed: (() {
          Get.back();
          Get.back(result: true);
        }));
      }
    } catch (e) {
      LoadingCustom.hideOverlay(context);
      DialogCustom.showBasicAlert("$e");
    }
  }

  Future callAPICreatePinPoint(int checkInID) async {
    try {
      List<PinPointAnswerQuestionModel> pinPointAnswerList = [];
      pinPointModel.questions.asMap().forEach((key, value) {
        pinPointAnswerList.add(PinPointAnswerQuestionModel(
          question: value.id,
          question_name: value.name,
          pin_point: null,
          answer: textController!.textControllerList[key].text,
        ));
      });

      PinPointAnswerModel pinPointAnswerModel = PinPointAnswerModel(
          activity: checkInID, type: id, answers: pinPointAnswerList);
      var jsonObj = pinPointAnswerModel.toJson();
      await checkInService.createpinPoint(jsonObj);
    } catch (e) {
      rethrow;
    }
  }
}
