import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import '../../constants/export_constants.dart';

Widget text(String text,
    {Color color = AppTheme.black,
    double? fontSize,
    FontWeight fontWeight = FontWeight.w500,
    TextDecoration decoration = TextDecoration.none,
    TextAlign textAlign = TextAlign.left,
    int? maxline,
    TextOverflow? overflow,
    FontStyle? fontStyle,
    String? fontFamily}) {
  return Text(text,
      textAlign: textAlign,
      maxLines: maxline,
      overflow: overflow,
      style: TextStyle(
          fontFamily: fontFamily,
          decoration: decoration,
          color: color,
          fontSize: fontSize ?? AppFontSize.mediumM,
          fontWeight: fontWeight,
          fontStyle: fontStyle));
}

Widget textAutoSize(String text,
    {Color color = AppTheme.black,
    required double fontSize,
    FontWeight fontWeight = FontWeight.w500,
    TextDecoration decoration = TextDecoration.none,
    TextAlign textAlign = TextAlign.left,
    int? maxline}) {
  return FittedBox(
    child: Text(text,
        textAlign: textAlign,
        maxLines: maxline,
        style: TextStyle(
            decoration: decoration,
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight)),
  );
}

Widget textAutoSizeII(String text,
    {Color color = AppTheme.black,
    required double fontSize,
    FontWeight fontWeight = FontWeight.w500,
    TextDecoration decoration = TextDecoration.none,
    TextAlign textAlign = TextAlign.left,
    int? maxline}) {
  return AutoSizeText(text,
      textAlign: textAlign,
      maxLines: maxline,
      style: TextStyle(
          decoration: decoration,
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight));
}

Widget textWithIcon(Icon icon, String text,
    {Color color = AppTheme.black,
    required double fontSize,
    FontWeight fontWeight = FontWeight.w500,
    TextDecoration decoration = TextDecoration.none,
    TextAlign textAlign = TextAlign.left,
    double iconSize = 14}) {
  return Row(
    children: [
      icon,
      horizontalSpace(5),
      Text(text,
          textAlign: textAlign,
          style: TextStyle(
              decoration: decoration,
              color: color,
              fontSize: fontSize,
              fontWeight: fontWeight)),
    ],
  );
}

Widget textHeaderAndDesc(String header, String desc) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text(header,
              color: AppTheme.white,
              fontSize: AppFontSize.largeXL,
              fontWeight: FontWeight.bold),
          text(desc, color: AppTheme.white, fontSize: AppFontSize.largeS),
        ],
      ),
    ),
  );
}

Widget textLableWithContainer(String title, String subText,
    {EdgeInsetsGeometry? padding,
    void Function()? onTap,
    Widget? icon,
    Color? textColor}) {
  return Container(
    padding: padding,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text(title, color: AppTheme.greyText, fontSize: AppFontSize.mediumS),
        verticalSpace(10),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 45,
            width: 100.w,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.greyBorder, width: 1)),
            child: icon != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          flex: 8,
                          child: text(subText,
                              fontSize: AppFontSize.mediumS,
                              color: textColor ?? AppTheme.black)),
                      Flexible(
                          flex: 2,
                          child: SizedBox(width: 20, height: 20, child: icon))
                    ],
                  )
                : text(subText,
                    fontSize: AppFontSize.mediumS,
                    color: textColor ?? AppTheme.black),
          ),
        ),
      ],
    ),
  );
}

Widget textPickerWithContainer(String? subText,
    {String? title,
    EdgeInsetsGeometry? padding,
    void Function()? onTap,
    Widget? icon,
    Color? textColor}) {
  return Container(
    padding: padding,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title != null
            ? Column(
                children: [
                  text(title,
                      color: AppTheme.greyText, fontSize: AppFontSize.mediumS),
                  verticalSpace(10),
                ],
              )
            : Container(),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 45,
            width: 100.w,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.greyBorder, width: 1)),
            child: icon != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          flex: 8,
                          child: text(subText ?? Texts.select,
                              fontSize: AppFontSize.mediumS,
                              color: textColor ??
                                  (subText != null
                                      ? AppTheme.black
                                      : AppTheme.greyText))),
                      Flexible(
                          flex: 2,
                          child: SizedBox(width: 20, height: 20, child: icon))
                    ],
                  )
                : text(subText ?? Texts.select,
                    fontSize: AppFontSize.mediumS,
                    color: textColor ??
                        (subText != null ? AppTheme.black : AppTheme.greyText)),
          ),
        ),
      ],
    ),
  );
}

Widget textLableWithContainer2(String title) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      text(title, color: AppTheme.greyText, fontSize: AppFontSize.mediumS),
      verticalSpace(10),
    ],
  );
}

Widget textWithContainerGradient(String title) {
  return Row(
    children: [
      Container(
        height: 15,
        width: 4,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppTheme.mainRed, AppTheme.peach])),
      ),
      horizontalSpace(5),
      text(title, fontSize: AppFontSize.mediumL, fontWeight: FontWeight.bold),
    ],
  );
}

Widget textStatusCustom(String title, Color color, Color colorText) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
    decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(10), color: color),
    child: text(title,
        fontSize: AppFontSize.small,
        fontStyle: FontStyle.italic,
        color: colorText),
  );
}

Widget textStatus(String status) {
  Color color = AppTheme.greyBorder;
  Color colorText = AppTheme.greyText;
  switch (status) {
    case Keys.pending:
      color = AppTheme.orange;
      colorText = AppTheme.orangeText;
      break;
    case Keys.reject:
      color = AppTheme.pink2;
      colorText = AppTheme.redText;
      break;
    default:
  }
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
    decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(10), color: color),
    child: text(status,
        fontSize: AppFontSize.small,
        fontStyle: FontStyle.italic,
        color: colorText),
  );
}

Widget textWithIconContainer(String title, Icon icon, {Color? textColor}) {
  return Container(
    height: 45,
    width: 100.w,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    alignment: Alignment.centerLeft,
    decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.greyBorder, width: 1)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            flex: 8,
            child: text(title,
                fontSize: AppFontSize.mediumS,
                color: textColor ?? AppTheme.black)),
        Flexible(flex: 2, child: SizedBox(width: 20, height: 20, child: icon))
      ],
    ),
  );
}

Widget shiftDay(String day, String place, String time,
    {void Function()? onTap}) {
  return Column(
    children: [
      Row(
        children: [
          Container(
              height: 40,
              width: 3,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppTheme.mainRed, AppTheme.peach]))),
          horizontalSpace(10),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      text(day,
                          fontSize: AppFontSize.mediumM,
                          fontWeight: FontWeight.bold),
                      const Spacer(),
                      text(place, fontSize: AppFontSize.mediumM)
                    ],
                  ),
                  text(time,
                      fontSize: AppFontSize.mediumM, color: AppTheme.greyText),
                ],
              ),
            ),
          )
        ],
      ),
      dividerHorizontal(top: 10, bottom: 10),
    ],
  );
}

Widget textNotFound({double? vertical}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: vertical ?? 0),
    child: text(Texts.dataNotFound,
        fontSize: AppFontSize.mediumS, color: AppTheme.greyText),
  );
}

Widget textError({String? error, double? vertical}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: vertical ?? 0),
    child: text(error ?? Texts.unkownError,
        fontSize: AppFontSize.mediumS, color: AppTheme.greyText),
  );
}

Widget textErrorAndIcon() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(
        Icons.error_outline_rounded,
        color: AppTheme.greyText,
        size: 40,
      ),
      verticalSpace(10),
      textError(),
    ],
  );
}

Widget textNotFoundAndIcon() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(
        Icons.format_list_bulleted_sharp,
        color: AppTheme.greyText,
        size: 40,
      ),
      verticalSpace(10),
      textNotFound(),
    ],
  );
}

Widget textPickerWithLabel(String title, String? value,
    {void Function()? onTap}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      text(title, color: AppTheme.greyText, fontSize: AppFontSize.mediumS),
      verticalSpace(10),
      textPickerWithContainer(
        value ?? Texts.select,
        onTap: onTap,
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
      ),
    ],
  );
}
