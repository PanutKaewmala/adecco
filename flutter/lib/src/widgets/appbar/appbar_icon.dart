import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

AppBar appBarWithIcon({bool showLeading = false}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: Visibility(
      visible: true,
      child: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: AppTheme.white,
          )),
    ),
  );
}
