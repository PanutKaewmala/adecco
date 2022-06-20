import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

Widget dividerHorizontal({double top = 0, double bottom = 0}) {
  return Padding(
    padding: EdgeInsetsDirectional.only(top: top, bottom: bottom),
    child: Container(
      color: AppTheme.greyBorder,
      width: double.maxFinite,
      height: 1,
    ),
  );
}

Widget dividerVertical(double height, {double left = 0, double right = 0}) {
  return Padding(
    padding: EdgeInsetsDirectional.only(start: left, end: right),
    child: Container(
      color: AppTheme.greyBorder,
      width: 1,
      height: height,
    ),
  );
}
