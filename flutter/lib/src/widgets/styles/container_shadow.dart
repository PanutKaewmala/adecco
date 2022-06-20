import 'package:ahead_adecco/src/config/theme.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

Widget contianerBorderShadow(
    {Widget? child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(15),
    double? height,
    double? width}) {
  return Container(
    padding: padding,
    height: height,
    width: width,
    decoration: BoxDecoration(
      color: AppTheme.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadowStyles.addShadow,
      ],
    ),
    child: child,
  );
}

Widget contianerBorder(
    {Widget? child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(15),
    double? height,
    double? width}) {
  return Container(
    padding: padding,
    height: height,
    width: width,
    decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.greyBorder)),
    child: child,
  );
}
