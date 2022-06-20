import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

Widget roundButton(String title,
    {Color buttonColor = AppTheme.mainRed,
    required void Function()? onPressed,
    double? fontSize,
    Color textColor = AppTheme.white,
    bool? side = false,
    BorderRadiusGeometry? borderRadius,
    Color? borderColor,
    FontWeight? fontWeight}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          primary: buttonColor,
          shadowColor: Colors.transparent,
          onPrimary: Colors.transparent,
          elevation: 0,
          side: side != false
              ? BorderSide(color: borderColor ?? textColor, width: 1)
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(10.0),
          ),
          minimumSize: const Size(
              double.maxFinite, 45) // put the width and height you want
          ),
      onPressed: onPressed,
      child: text(title,
          color: onPressed == null ? AppTheme.grey : textColor,
          fontSize: fontSize ?? AppFontSize.mediumM,
          fontWeight: fontWeight ?? FontWeight.bold,
          textAlign: TextAlign.center));
}

Widget roundButtonWithWidth(String title,
    {Color buttonColor = AppTheme.mainRed,
    required void Function()? onPressed,
    required double fontSize,
    Color textColor = AppTheme.white,
    bool? side = false,
    BorderRadiusGeometry? borderRadius,
    Color? borderColor,
    FontWeight? fontWeight,
    TextAlign? textAlign}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(15),
          primary: buttonColor,
          shadowColor: Colors.transparent,
          onPrimary: Colors.transparent,
          elevation: 0,
          side: side != false
              ? BorderSide(color: borderColor ?? textColor, width: 1)
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(10.0),
          ),
          minimumSize: const Size(
              double.maxFinite, 45) // put the width and height you want
          ),
      onPressed: onPressed,
      child: SizedBox(
        width: double.maxFinite,
        child: text(title,
            color: onPressed == null ? AppTheme.grey : textColor,
            fontSize: fontSize,
            fontWeight: fontWeight ?? FontWeight.bold,
            textAlign: textAlign ?? TextAlign.center),
      ));
}

Widget roundButtonWithIcon(
  String title, {
  Color buttonColor = AppTheme.mainRed,
  required void Function() onPressed,
  double? fontSize,
  required Icon icon,
  Color textColor = AppTheme.white,
  Color? borderColor,
}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        primary: buttonColor,
        shadowColor: Colors.transparent,
        onPrimary: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        minimumSize: const Size(double.maxFinite, 45),
        side: borderColor != null
            ? BorderSide(color: borderColor, width: 1)
            : null, // put the width and height you want
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          horizontalSpace(5),
          text(title,
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold),
        ],
      ));
}

Widget elevatedButtonCustom(
    {void Function()? onPressed, Widget? child, Color color = AppTheme.white}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          primary: color,
          shadowColor: Colors.transparent,
          onPrimary: Colors.transparent,
          onSurface: Colors.white,
          elevation: 0,
          padding: EdgeInsets.zero),
      onPressed: onPressed,
      child: child);
}

Widget roundElevatedButton(
    {void Function()? onPressed,
    Widget? child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(8.0)}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadowStyles.addShadow,
      ],
    ),
    child: elevatedButtonCustom(
        onPressed: onPressed,
        child: Padding(
          padding: padding,
          child: child,
        )),
  );
}

Widget appBarButton(String title, {required void Function() onPressed}) {
  return SizedBox(
      width: 25.w,
      height: 45,
      child: roundButtonWithIcon(title,
          buttonColor: AppTheme.black2,
          onPressed: onPressed,
          fontSize: AppFontSize.mediumS,
          icon: const Icon(
            Icons.add,
            color: AppTheme.white,
            size: 20,
          )));
}

Widget bottomNavigation(String? title,
    {Widget? child, void Function()? onPressed, Color? color}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(15, 15, 15, 20),
    child: child ??
        roundButton(title ?? Texts.create,
            fontSize: AppFontSize.mediumM,
            buttonColor: color ?? AppTheme.mainRed,
            onPressed: onPressed),
  );
}

Widget bottomNavigationWithEdit(
  PageType pageType,
  bool disable, {
  required void Function()? onPressedCancel,
  required void Function()? onPressedSave,
  required void Function()? onPressedCreate,
}) {
  return bottomNavigation(
    Texts.preview,
    onPressed: () {},
    child: pageType == PageType.edit
        ? Row(
            children: [
              Flexible(
                flex: 1,
                child: cancaelButton(
                    text: Texts.cancelRequest,
                    onPressed: onPressedCancel,
                    disable: disable),
              ),
              horizontalSpace(10),
              Flexible(
                flex: 1,
                child: previewButton(
                    text: Texts.saveChange,
                    onPressed: onPressedSave,
                    disable: disable),
              ),
            ],
          )
        : previewButton(
            text: Texts.create, onPressed: onPressedCreate, disable: disable),
  );
}

Widget previewButton(
    {String? text, void Function()? onPressed, required bool disable}) {
  return roundButton(
    text ?? Texts.preview,
    fontSize: AppFontSize.mediumM,
    buttonColor: disable ? AppTheme.grey : AppTheme.mainRed,
    onPressed: disable ? null : onPressed,
  );
}

Widget cancaelButton(
    {String? text, void Function()? onPressed, required bool disable}) {
  return roundButton(
    text ?? Texts.cancel,
    fontSize: AppFontSize.mediumM,
    side: true,
    textColor: disable ? AppTheme.grey : AppTheme.mainRed,
    buttonColor: AppTheme.white,
    onPressed: disable ? null : onPressed,
  );
}
