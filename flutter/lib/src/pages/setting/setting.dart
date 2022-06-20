import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/pages/setting/setting_ctrl.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SettingController controller = Get.put(SettingController());
    final _fullName = UserConfig.getFullName();

    return Scaffold(
      appBar: appbarBackground(_fullName),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Obx(
          () => Column(
            children: [
              contianerBorderShadow(
                  child: Column(
                children: [
                  textWithContainerGradient(Texts.language),
                  dividerHorizontal(top: 10, bottom: 10),
                  Row(
                    children: [
                      Radio<Language>(
                          value: Language.eng,
                          activeColor: AppTheme.mainRed,
                          groupValue: controller.language.value,
                          onChanged: (language) {
                            controller.onSelectedLanguage(language!);
                          }),
                      text(Language.eng.title, fontSize: AppFontSize.mediumM)
                    ],
                  ),
                  Row(
                    children: [
                      Radio<Language>(
                          value: Language.th,
                          activeColor: AppTheme.mainRed,
                          groupValue: controller.language.value,
                          onChanged: (language) {
                            controller.onSelectedLanguage(language!);
                          }),
                      text(Language.th.title, fontSize: AppFontSize.mediumM)
                    ],
                  ),
                ],
              )),
              verticalSpace(15),
              text("Version ${controller.version}",
                  fontSize: AppFontSize.mediumS, color: AppTheme.greyText),
              text(controller.deviceAndOSName.value,
                  fontSize: AppFontSize.mediumS, color: AppTheme.greyText),
              const Spacer(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigation(Texts.logout, onPressed: () {
        controller.onClickLogout();
      }),
    );
  }
}
