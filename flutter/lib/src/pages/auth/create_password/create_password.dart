import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';
import 'create_password_ctrl.dart';
import 'create_password_widget.dart';

class CreatePasswordPage extends StatefulWidget {
  const CreatePasswordPage({Key? key}) : super(key: key);

  @override
  State<CreatePasswordPage> createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends State<CreatePasswordPage> {
  @override
  Widget build(BuildContext context) {
    final CreatePasswordController controller =
        Get.put(CreatePasswordController(context));

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
              body: listViewCustom(
                children: [
                  textAndLogo(
                    UserConfig.pageForgotPassword == ""
                        ? Texts.firstTimeLogin
                        : Texts.forgotPassword,
                    Texts.plsCreatePassword,
                  ),
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
                        verticalSpace(10),
                        text(
                          Texts.createPassword,
                          color: AppTheme.black,
                          fontSize: AppFontSize.largeL,
                          fontWeight: FontWeight.bold,
                        ),
                        verticalSpace(15),
                        textFieldWithlabel(
                            Texts.password, controller.textController.password,
                            obscureText: controller.obscureText1.value,
                            onChanged: (value) {
                          controller.validatePassword(value);
                        },
                            validate:
                                controller.textController.isValidPassword(),
                            icon: showPasswordIcon(
                                obscure: controller.obscureText1.value,
                                onTap: () {
                                  controller.showPassword(false);
                                })),
                        verticalSpace(15),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: AppTheme.grey,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: AppTheme.mainRed, width: 1)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              text(
                                Texts.passwordRule,
                                color: AppTheme.black,
                                fontSize: AppFontSize.mediumS,
                              ),
                              verticalSpace(2),
                              textWithIcon(
                                validateIcon(
                                    controller.passwordRulesList[0].value),
                                Texts.upperCase,
                                fontSize: AppFontSize.mediumS,
                              ),
                              verticalSpace(2),
                              textWithIcon(
                                validateIcon(
                                    controller.passwordRulesList[1].value),
                                Texts.lowerCase,
                                fontSize: AppFontSize.mediumS,
                              ),
                              verticalSpace(2),
                              textWithIcon(
                                validateIcon(
                                    controller.passwordRulesList[2].value),
                                Texts.numberCase,
                                fontSize: AppFontSize.mediumS,
                              ),
                              verticalSpace(2),
                              textWithIcon(
                                validateIcon(
                                    controller.passwordRulesList[3].value),
                                Texts.minimumCase,
                                fontSize: AppFontSize.mediumS,
                              ),
                              verticalSpace(2),
                              textWithIcon(
                                validateIcon(
                                    controller.passwordRulesList[4].value),
                                Texts.specialCase,
                                fontSize: AppFontSize.mediumS,
                              ),
                              controller.passNotMatch.value == true
                                  ? textWithIcon(
                                      validateIcon(CheckPassword.fail),
                                      Texts.passwordNotMatch,
                                      fontSize: AppFontSize.mediumS,
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                        verticalSpace(15),
                        textFieldWithlabel(
                          Texts.confirmPassword,
                          controller.textController.comfirmPassword,
                          obscureText: controller.obscureText2.value,
                          icon: showPasswordIcon(
                            obscure: controller.obscureText2.value,
                            onTap: () {
                              controller.showPassword(true);
                            },
                          ),
                          validate: controller.textController
                              .isValidConfirmPassword(),
                        ),
                        verticalSpace(25),
                        roundButton(Texts.confirm,
                            fontSize: AppFontSize.mediumM,
                            buttonColor: AppTheme.mainRed, onPressed: () {
                          controller.onClickConfirm();
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
