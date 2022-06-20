import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';
import 'login_ctrl.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());
    return KeyboardDismisser(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Obx(
        () => Stack(
          children: [
            background(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(height: 50.h, color: Colors.white),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: SizedBox(
                height: 100.h,
                child: listViewCustom(
                  children: [
                    textAndLogo(Texts.welcom, Texts.plsSign),
                    Container(
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
                          text(Texts.login,
                              color: AppTheme.black,
                              fontSize: AppFontSize.largeL,
                              fontWeight: FontWeight.bold),
                          verticalSpace(15),
                          textFieldWithlabel(Texts.userName,
                              controller.loginTextController.username,
                              validate: controller.loginTextController
                                  .isValidUsername()),
                          verticalSpace(15),
                          textFieldWithlabel(Texts.password,
                              controller.loginTextController.password,
                              obscureText: controller.obscureText.value,
                              icon: showPasswordIcon(
                                  obscure: controller.obscureText.value,
                                  onTap: () {
                                    controller.showPassword();
                                  }),
                              validate: controller.loginTextController
                                  .isValidPassword()),
                          verticalSpace(10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                controller.onClickResetPassword();
                              },
                              child: text(Texts.forgotPasswordQ,
                                  textAlign: TextAlign.end,
                                  color: AppTheme.greyText,
                                  fontSize: AppFontSize.mediumM),
                            ),
                          ),
                          verticalSpace(25),
                          roundButton(Texts.login,
                              fontSize: AppFontSize.mediumL,
                              buttonColor: AppTheme.mainRed, onPressed: () {
                            controller.onClickLogin(context);
                          }),
                          verticalSpace(25),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                color: AppTheme.white,
                padding: const EdgeInsets.only(bottom: 20, right: 20),
                // child: Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     text(Texts.contactAdmin,
                //         fontSize: AppFontSize.mediumS,
                //         color: AppTheme.greyText),
                //     horizontalSpace(5),
                //     text(Keys.contactPhone,
                //         fontSize: AppFontSize.mediumS,
                //         color: AppTheme.blueText),
                //   ],
                // ),
                child: Text.rich(
                  TextSpan(
                    text: Texts.contactAdmin + " ",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppTheme.greyText,
                      fontSize: AppFontSize.mediumS,
                    ),
                    children: const <TextSpan>[
                      TextSpan(
                        text: Keys.contactPhone,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppTheme.blueText,
                          fontSize: AppFontSize.mediumS,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
