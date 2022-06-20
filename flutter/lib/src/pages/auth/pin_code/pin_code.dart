import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/pages/auth/pin_code/pin_code_widget.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';
import 'pin_code_ctrl.dart';

class PincodePage extends StatelessWidget {
  const PincodePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PincodeController controller = Get.put(PincodeController(context));
    List<Widget> _buildDotList() {
      var dotList = <Widget>[];
      for (int i = 0; i < 6; i++) {
        dotList.add(Container(
          margin: const EdgeInsets.all(5),
          alignment: Alignment.center,
          child: PincodeDot(
              filled: i <
                  (controller.status.value == Passcode.confirm
                      ? controller.confirmPincode.value.length
                      : controller.inputPincode.value.length)),
        ));
      }
      return dotList;
    }

    Widget _buildPasscodeDotWidget() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildDotList(),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Image.asset(
              Assets.pinCodeBG,
              fit: BoxFit.fitWidth,
            ),
          ),
          GetX<PincodeController>(initState: (state) {
            controller.upDateStatus();
          }, builder: (context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                verticalSpace(25.h),
                text(controller.status.value.title,
                    fontSize: AppFontSize.mediumL,
                    color: AppTheme.white,
                    fontWeight: FontWeight.bold),
                verticalSpace(5.h),
                _buildPasscodeDotWidget(),
                const Spacer(),
                Visibility(
                  visible: controller.status.value == Passcode.enter,
                  child: GestureDetector(
                    onTap: () {
                      controller.goToPage();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        text(Texts.forgotPinCode,
                            fontSize: AppFontSize.mediumS,
                            color: AppTheme.white),
                        horizontalSpace(10),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: AppTheme.white,
                          size: 15,
                        )
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: controller.passNotMatch.value,
                  child: text(Texts.pinNotMatch,
                      fontSize: AppFontSize.mediumS, color: AppTheme.white),
                ),
                verticalSpace(5.h),
                Center(
                  child: NumpadPinCode(
                    onNumpadTap: (Numpad num) {
                      debugPrint("num $num");
                      controller.onNumpadTap(num);
                    },
                  ),
                ),
                verticalSpace(5.h),
              ],
            );
          }),
        ],
      ),
    );
  }
}
