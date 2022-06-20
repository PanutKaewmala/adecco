import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';
import 'otp_verification_ctrl.dart';

class OTPVerificationPage extends StatelessWidget {
  OTPVerificationPage({Key? key}) : super(key: key);
  final String _phoneNumber = Get.arguments ?? "";
  @override
  Widget build(BuildContext context) {
    Get.put(OTPVerificationController());

    final OTPVerificationController controller =
        Get.put(OTPVerificationController());
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
                      Texts.otpVerification,
                      Texts.otpSent +
                          (_phoneNumber.isNotEmpty
                              ? _phoneNumber.replaceRange(6, 10, "****")
                              : "")),
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        verticalSpace(6.h),
                        SizedBox(
                          width: 60.w,
                          child: PinCodeTextField(
                            appContext: context,
                            length: 4,
                            obscureText: false,
                            keyboardType: TextInputType.number,
                            animationType: AnimationType.fade,
                            pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(8),
                                fieldHeight: 45,
                                fieldWidth: 45,
                                activeColor: AppTheme.mainRed,
                                selectedColor: AppTheme.mainRed,
                                inactiveFillColor: AppTheme.grey,
                                inactiveColor: AppTheme.greyBorder,
                                activeFillColor: Colors.white,
                                selectedFillColor: Colors.white),
                            animationDuration:
                                const Duration(milliseconds: 300),
                            enableActiveFill: true,
                            // errorAnimationController: errorController,
                            // controller: textEditingController,
                            onCompleted: (v) {
                              debugPrint("Completed");
                              controller.submit();
                            },
                            onChanged: (value) {
                              debugPrint(value);
                              // setState(() {
                              //   currentText = value;
                              // });
                            },
                            beforeTextPaste: (text) {
                              debugPrint("Allowing to paste $text");
                              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                              //but you can show anything you want here, like your pop up saying wrong paste format or etc
                              return true;
                            },
                          ),
                        ),
                        verticalSpace(2.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            text(
                              Texts.otpResend,
                              color: AppTheme.greyText,
                              fontSize: AppFontSize.mediumM,
                            ),
                            horizontalSpace(1.h),
                            text(
                              Texts.resend,
                              color: AppTheme.mainRed,
                              fontSize: AppFontSize.mediumM,
                            )
                          ],
                        ),
                      ],
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
