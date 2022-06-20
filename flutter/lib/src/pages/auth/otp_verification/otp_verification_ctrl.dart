import 'package:ahead_adecco/src/config/export_config.dart';

class OTPVerificationController extends GetxController {
  void submit() async {
    if (UserConfig.pageForgotPassword == Routes.login) {
      Get.toNamed(Routes.createPassword);
    } else {
      await SharedPreferencesService.setPincodeStatus(false);
      Get.toNamed(Routes.pincode);
    }
  }
}
