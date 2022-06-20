import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class DialogCustom {
  static showBasicAlert(String message,
      {String? title,
      bool dismissible = false,
      void Function()? onPressed}) async {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          title: text(title ?? Texts.alert,
              fontSize: AppFontSize.mediumL, maxline: 1),
          content: text(message, fontSize: AppFontSize.mediumS, maxline: 4),
          actions: <Widget>[
            Center(
              child: Container(
                height: 45,
                width: 120,
                padding: const EdgeInsets.only(bottom: 10),
                child: roundButton(Texts.ok, fontSize: AppFontSize.mediumM,
                    onPressed: () {
                  Get.back();
                  if (onPressed != null) {
                    onPressed();
                  }
                }),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  static showBasicAlertOkCancel(String message,
      {String? title,
      bool dismissible = false,
      String? textButton,
      void Function()? onPressed}) async {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          title: text(title ?? Texts.alert,
              fontSize: AppFontSize.mediumL, maxline: 1),
          content: text(message, fontSize: AppFontSize.mediumS, maxline: 4),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 45,
                  width: 120,
                  padding: const EdgeInsets.only(bottom: 10),
                  child: roundButton(Texts.cancel,
                      side: true,
                      fontSize: AppFontSize.mediumM,
                      buttonColor: AppTheme.white,
                      textColor: AppTheme.mainRed, onPressed: () {
                    Get.back();
                  }),
                ),
                horizontalSpace(20),
                Container(
                  height: 45,
                  width: 120,
                  padding: const EdgeInsets.only(bottom: 10),
                  child: roundButton(textButton ?? Texts.ok,
                      fontSize: AppFontSize.mediumM,
                      onPressed: onPressed ??
                          () {
                            Get.back();
                          }),
                ),
              ],
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  static showBasicAlertWithTextFeild(
      String title, TextEditingController controller,
      {bool dismissible = false,
      required void Function() onPressed,
      void Function()? onPressedBack,
      String? text1,
      String? text2}) async {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          title: text(title,
              fontSize: AppFontSize.mediumL,
              maxline: 2,
              textAlign: TextAlign.center),
          content: textFieldMutiLine(controller, maxLine: 4),
          actionsPadding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          actions: <Widget>[
            SizedBox(
              width: double.maxFinite,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    child: roundButton(text1 ?? Texts.cancel,
                        side: true,
                        fontSize: AppFontSize.mediumM,
                        buttonColor: AppTheme.white,
                        textColor: AppTheme.mainRed, onPressed: () {
                      controller.clear();
                      Get.back();
                      if (onPressedBack != null) {
                        onPressedBack();
                      }
                    }),
                  ),
                  horizontalSpace(20),
                  Flexible(
                    flex: 1,
                    child: roundButton(text2 ?? Texts.save,
                        fontSize: AppFontSize.mediumM, onPressed: onPressed),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  static showSnackBar({String? title, required String message}) {
    Get.snackbar("", "",
        titleText: text(
          title ?? Texts.alert,
          fontSize: AppFontSize.mediumL,
        ),
        messageText:
            text(message, fontSize: AppFontSize.mediumM, color: AppTheme.red),
        backgroundColor: AppTheme.white);
  }
}

class AlertPopUp {
  static showAlertIncorrectDate() {
    DialogCustom.showSnackBar(
        title: Texts.alert, message: Texts.plsSelectStartEndTime);
  }

  static showAlertIncorrecrtTime() {
    DialogCustom.showSnackBar(title: Texts.alert, message: Texts.incorrectDate);
  }
}
