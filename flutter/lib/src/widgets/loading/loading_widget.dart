import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class LoadingCustom {
  static void showOverlay(BuildContext context) {
    return context.loaderOverlay.show();
  }

  static void hideOverlay(BuildContext context) {
    return context.loaderOverlay.hide();
  }

  static Widget loadingWidget({double size = 30}) {
    return SpinKitThreeBounce(
      color: AppTheme.mainRed,
      size: size,
    );
  }

  static Widget loadingOverlayWidget({double size = 30}) {
    return SpinKitThreeBounce(
      color: AppTheme.white,
      size: size,
    );
  }

  static Future disableTouch() async {
    Get.dialog(
        WillPopScope(
          onWillPop: () async => false,
          child: Container(),
        ),
        barrierDismissible: false,
        barrierColor: Colors.transparent);
  }
}
