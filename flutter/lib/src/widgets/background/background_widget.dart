import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

Widget background() {
  return SizedBox(
    width: double.maxFinite,
    child: Image.asset(
      Assets.pinCodeBG,
      fit: BoxFit.fitWidth,
    ),
  );
}
