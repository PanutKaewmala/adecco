import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

Widget containerGradient(
    {double? height,
    double? width,
    required Color color1,
    required Color color2,
    EdgeInsetsGeometry? padding,
    Widget? child}) {
  return Container(
    height: height,
    width: width,
    padding: padding,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color1, color2])),
    child: child,
  );
}

Widget containerGradientH(
    {double? height,
    double? width,
    required Color color1,
    required Color color2,
    EdgeInsetsGeometry? padding,
    Widget? child,
    BorderRadiusGeometry? borderRadius}) {
  return Container(
    height: height,
    width: width,
    padding: padding,
    decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [color1, color2])),
    child: child,
  );
}

Widget textWithContainerGradientCustom({double? height, double? width}) {
  return Container(
    height: height,
    width: width ?? 2,
    decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.mainRed, AppTheme.peach])),
  );
}
