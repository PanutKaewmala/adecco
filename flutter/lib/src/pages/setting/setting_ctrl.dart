import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class SettingController extends GetxController {
  final language = Language.eng.obs;
  final version = "".obs;
  final deviceAndOSName = "".obs;

  @override
  void onInit() {
    getPackageInfo();
    getDeviceInfo();
    super.onInit();
  }

  void onSelectedLanguage(Language language) {
    this.language.value = language;
    DialogCustom.showBasicAlert(Texts.changeLanguage);
  }

  void getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version.value = packageInfo.version;
  }

  void getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (await IsSimulator.isRealDevice()) {
      var deviceName = "";
      var osVersion = "";
      if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceName = iosInfo.model ?? "";
        osVersion = iosInfo.systemName ?? "";
      } else if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceName = androidInfo.model ?? "";
        osVersion = "Android " + (androidInfo.version.release ?? "");
      }
      deviceAndOSName.value = "($deviceName, $osVersion)";
    }
  }

  void onClickLogout() {
    DialogCustom.showBasicAlertOkCancel(Texts.askLogout,
        textButton: Texts.logout, onPressed: () async {
      await clearAllData();
      Get.offAllNamed(Routes.login);
    });
  }

  Future clearAllData() async {
    UserConfig.clearData();
    await SharedPreferencesService.removeAllData();
  }
}
