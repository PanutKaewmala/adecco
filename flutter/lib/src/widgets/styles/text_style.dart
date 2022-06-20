import 'package:ahead_adecco/src/config/font_size.dart';
import 'package:ahead_adecco/src/config/theme.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

TextStyle textStyle({Color? color}) {
  return TextStyle(
      fontWeight: fontWeightNormal(), color: color ?? AppTheme.black);
}

FontWeight fontWeightNormal() {
  return FontWeight.w500;
}

TextStyle textStyleWithFont({Color? color}) {
  return TextStyle(
      fontWeight: fontWeightNormal(),
      color: color ?? AppTheme.black,
      fontFamily: houschkaHead);
}
