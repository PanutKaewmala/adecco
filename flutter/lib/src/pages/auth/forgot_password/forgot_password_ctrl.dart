import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/pages/auth/forgot_password/forgot_password_text_ctrl.dart';
import 'package:ahead_adecco/src/services/export_services.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class ForgotPasswordController extends GetxController {
  BuildContext context;
  ForgotPasswordController(this.context);
  final ForgotPasswordTextController textController =
      ForgotPasswordTextController();
  bool? validation;
  late AuthenticationService authenticationService;

  @override
  void onInit() {
    authenticationService = AuthenticationService();
    super.onInit();
  }

  @override
  void onClose() {
    textController.dispose();
    authenticationService.close();
    UserConfig.pageForgotPassword = "";
    super.onClose();
  }

  void onClickNext() {
    Get.focusScope!.unfocus();
    validation = textController.isDataValid();
    if ((validation ?? false)) {
      callAPICreatePassword();
    }
  }

  void callAPICreatePassword() async {
    LoadingCustom.showOverlay(context);
    var data = {
      "username": textController.username.text,
      "phone_number": textController.phone.text
    };
    try {
      await authenticationService.forgotPassword(data).then((value) async {
        LoadingCustom.hideOverlay(context);
        Get.toNamed(Routes.otpVerification,
            arguments: textController.phone.text);
      });
    } catch (e) {
      LoadingCustom.hideOverlay(context);
      DialogCustom.showBasicAlert("$e");
    }
  }
}
