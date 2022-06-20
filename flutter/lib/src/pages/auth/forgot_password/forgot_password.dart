import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';
import 'forgot_password_ctrl.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ForgotPasswordController controller =
        Get.put(ForgotPasswordController(context));

    return KeyboardDismisser(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            background(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(height: 50.h, color: Colors.white),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              extendBodyBehindAppBar: true,
              appBar: appBarWithIcon(),
              body: listViewCustom(
                children: [
                  textAndLogo(
                      UserConfig.pageForgotPassword == Routes.login
                          ? Texts.forgotPassword
                          : Texts.forgotPinCode,
                      Texts.plsEnterUserNamePassword),
                  Obx(
                    () => Container(
                      decoration: const BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          verticalSpace(15),
                          text(Texts.selfVerification,
                              color: AppTheme.black,
                              fontSize: AppFontSize.largeL,
                              fontWeight: FontWeight.bold),
                          verticalSpace(15),
                          textFieldWithlabel(Texts.userName,
                              controller.textController.username,
                              validate:
                                  controller.textController.isValidUsername()),
                          verticalSpace(15),
                          textFieldWithlabel(
                              Texts.phone, controller.textController.phone,
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              validate:
                                  controller.textController.isValidPhone()),
                          verticalSpace(20),
                          roundButton(Texts.next,
                              fontSize: AppFontSize.mediumM,
                              buttonColor: AppTheme.mainRed, onPressed: () {
                            controller.onClickNext();
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
