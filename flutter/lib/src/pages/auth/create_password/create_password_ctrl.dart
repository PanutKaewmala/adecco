import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/pages/auth/create_password/create_password_text_ctrl.dart';
import 'package:ahead_adecco/src/services/export_services.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class CreatePasswordController extends GetxController {
  BuildContext context;
  CreatePasswordController(this.context);
  CreatePasswordTextController textController = CreatePasswordTextController();
  final obscureText1 = true.obs;
  final obscureText2 = true.obs;
  final passNotMatch = false.obs;
  bool? validation;
  List<Rx<CheckPassword>> passwordRulesList = [
    CheckPassword.none.obs,
    CheckPassword.none.obs,
    CheckPassword.none.obs,
    CheckPassword.none.obs,
    CheckPassword.none.obs
  ];
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
    super.onClose();
  }

  void onClickConfirm() {
    Get.focusScope!.unfocus();
    validation = textController.isDataValid();
    if ((validation ?? false)) {
      if (textController.password.text == textController.comfirmPassword.text) {
        passNotMatch.value = false;
        callAPICreatePassword();
      } else {
        passNotMatch.value = true;
      }
    }
  }

  void validatePassword(String value) {
    RegExp regex0 = RegExp(r'^(?=.*?[A-Z])');
    RegExp regex1 = RegExp(r'^(?=.*?[a-z])');
    RegExp regex2 = RegExp(r'^(?=.*?[0-9])');
    RegExp regex3 = RegExp(r'^.{8,}');
    RegExp regex4 = RegExp(r'^(?=.*?[!@#$%^&*(+)_=-])');
    if (value.isEmpty) {
      for (var i = 0; i < passwordRulesList.length; i++) {
        passwordRulesList[i].value = CheckPassword.none;
      }
    } else {
      if (!regex0.hasMatch(value)) {
        passwordRulesList[0].value = CheckPassword.fail;
      } else {
        passwordRulesList[0].value = CheckPassword.pass;
      }
      if (!regex1.hasMatch(value)) {
        passwordRulesList[1].value = CheckPassword.fail;
      } else {
        passwordRulesList[1].value = CheckPassword.pass;
      }
      if (!regex2.hasMatch(value)) {
        passwordRulesList[2].value = CheckPassword.fail;
      } else {
        passwordRulesList[2].value = CheckPassword.pass;
      }
      if (!regex3.hasMatch(value)) {
        passwordRulesList[3].value = CheckPassword.fail;
      } else {
        passwordRulesList[3].value = CheckPassword.pass;
      }
      if (!regex4.hasMatch(value)) {
        passwordRulesList[4].value = CheckPassword.fail;
      } else {
        passwordRulesList[4].value = CheckPassword.pass;
      }
    }
  }

  void showPassword(bool isConfirm) {
    if (isConfirm) {
      obscureText2.value = !obscureText2.value;
    } else {
      obscureText1.value = !obscureText1.value;
    }
  }

  void callAPICreatePassword() async {
    LoadingCustom.showOverlay(context);
    var data = {
      "new_password": textController.password.text,
      "confirm_password": textController.comfirmPassword.text
    };
    try {
      await authenticationService.createPassword(data).then((value) async {
        await setFirstTimeLogin();
        LoadingCustom.hideOverlay(context);
        if (UserConfig.session == null) {
          Get.offAllNamed(Routes.login);
        } else {
          Get.toNamed(Routes.pincode);
        }
      });
    } catch (e) {
      LoadingCustom.hideOverlay(context);
      DialogCustom.showBasicAlert("$e");
    }
  }

  Future setFirstTimeLogin() async {
    await SharedPreferencesService.setIsCreatePassword(true);
  }
}
