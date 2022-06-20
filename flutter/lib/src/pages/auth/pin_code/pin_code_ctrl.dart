import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class PincodeController extends GetxController {
  String? pincode;
  final int maxPass = 6;
  var inputPincode = "".obs;
  var confirmPincode = "".obs;
  var status = Passcode.enter.obs;
  var passNotMatch = false.obs;
  BuildContext context;
  PincodeController(this.context) : super();

  void upDateStatus() async {
    if (!UserConfig.hasPincode) {
      status.value = Passcode.create;
    } else {
      await getPincode();
    }
  }

  void goToPage() {
    inputPincode.value = "";
    UserConfig.pageForgotPassword = Routes.pincode;
    Get.toNamed(Routes.forgotPassword);
  }

  void onNumpadTap(Numpad numpad) {
    if (numpad == Numpad.delete) {
      deletePasscode();
    } else {
      insertPasscode("${numpad.index}");
    }
  }

  void deletePasscode() {
    switch (status.value) {
      case Passcode.create:
        if (inputPincode.value.isNotEmpty) {
          inputPincode.value =
              inputPincode.substring(0, inputPincode.value.length - 1);
        }
        break;
      case Passcode.confirm:
        if (confirmPincode.value.isNotEmpty) {
          confirmPincode.value =
              confirmPincode.substring(0, confirmPincode.value.length - 1);
        }
        break;
      default:
        if (inputPincode.value.isNotEmpty) {
          inputPincode.value =
              inputPincode.substring(0, inputPincode.value.length - 1);
        }
    }
  }

  void insertPasscode(String inputNumber) {
    switch (status.value) {
      case Passcode.create:
        if (inputPincode.value.length < maxPass) {
          inputPincode.value += inputNumber;
        }
        if (inputPincode.value.length == maxPass) verifyPasscode();
        break;
      case Passcode.confirm:
        if (confirmPincode.value.length < maxPass) {
          confirmPincode.value += inputNumber;
        }
        if (confirmPincode.value.length == maxPass) verifyPasscode();
        break;
      default:
        if (inputPincode.value.length < maxPass) {
          inputPincode.value += inputNumber;
        }
        if (inputPincode.value.length == maxPass) verifyPasscode();
    }
  }

  void verifyPasscode() {
    switch (status.value) {
      case Passcode.create:
        status.value = Passcode.confirm;
        break;
      case Passcode.confirm:
        if (inputPincode.value == confirmPincode.value) {
          createPincode();
        } else {
          passNotMatch.value = true;
          confirmPincode.value = "";
        }
        break;
      default:
        if (inputPincode.value == pincode) {
          Get.offAllNamed(Routes.home);
        } else {
          inputPincode.value = "";
          DialogCustom.showBasicAlert(Texts.incorrectPinCode);
        }
    }
  }

  // * API Pincode
  // void callAPICreatePincode() async {
  //   await LoadingCustom().show();
  //   AuthenticationService authenticationService =
  //       AuthenticationService(context);
  //   var body = {
  //     "new_pincode": inputPincode.value,
  //     "confirm_pincode": confirmPincode.value
  //   };
  //   try {
  //     await authenticationService.createPassword(body).then((value) async {
  //       await LoadingCustom().hide();
  //       await setFirstTimePincode();
  //       Get.offAllNamed(Routes.home);
  //     });
  //   } catch (e) {
  //     await LoadingCustom().hide();
  //     DialogCustom().showBasicAlert('Info', "$e");
  //   }
  // }

  Future createPincode() async {
    await SharedPreferencesService.setEncryptedPassword(inputPincode.value);
    await setFirstTimePincode();
    Get.offAllNamed(Routes.home);
  }

  Future getPincode() async {
    pincode = await SharedPreferencesService.getEncryptedPassword();
  }

  Future setFirstTimePincode() async {
    await SharedPreferencesService.setPincodeStatus(true);
  }
}
