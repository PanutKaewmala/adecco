import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

Widget textFieldMutiLine(TextEditingController controller,
    {bool obscureText = false,
    Function(String)? onChanged,
    TextInputType? keyboardType,
    Widget? icon,
    int maxLine = 1}) {
  return TextField(
    controller: controller,
    keyboardType: keyboardType,
    onChanged: onChanged,
    obscureText: obscureText,
    maxLines: maxLine,
    style: TextStyle(fontWeight: fontWeightNormal()),
    decoration: InputDecoration(
      fillColor: AppTheme.grey,
      filled: true,
      errorStyle: const TextStyle(height: 0),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: AppTheme.greyBorder, width: 1.0),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: AppTheme.greyBorder, width: 1.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: AppTheme.red, width: 1.0),
      ),
      suffixIcon: icon,
    ),
  );
}

Widget showPasswordIcon({void Function()? onTap, required bool obscure}) {
  return Padding(
    padding: const EdgeInsets.all(15),
    child: GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        obscure ? Assets.hidePassword : Assets.showPassword,
        fit: BoxFit.fitWidth,
      ),
    ),
  );
}

Widget textFieldWithlabel(String title, TextEditingController controller,
    {bool obscureText = false,
    Function(String)? onChanged,
    Widget? textWidget,
    TextInputType? keyboardType,
    Widget? icon,
    int? maxLength,
    bool? validate,
    bool addPadding = false}) {
  return Padding(
    padding: EdgeInsets.only(top: addPadding ? 15 : 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidget ??
            text(title,
                color: AppTheme.greyText, fontSize: AppFontSize.mediumS),
        verticalSpace(10),
        SizedBox(
          height: 45,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            onChanged: onChanged,
            obscureText: obscureText,
            maxLength: maxLength,
            style: TextStyle(fontWeight: fontWeightNormal()),
            decoration: InputDecoration(
              fillColor: AppTheme.grey,
              filled: true,
              counterText: "",
              errorText: validate != null
                  ? validate
                      ? null
                      : ""
                  : null,
              errorStyle: const TextStyle(height: 0),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide:
                    const BorderSide(color: AppTheme.greyBorder, width: 1.0),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide:
                    const BorderSide(color: AppTheme.greyBorder, width: 1.0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: AppTheme.red, width: 1.0),
              ),
              suffixIcon: icon,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget textFieldMutiLineWithlabel(
    String title, TextEditingController controller,
    {bool obscureText = false,
    Function(String)? onChanged,
    TextInputType? keyboardType,
    Widget? icon,
    int maxLine = 1,
    bool? validate,
    bool addPadding = false}) {
  return Padding(
    padding: EdgeInsets.only(top: addPadding ? 15 : 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text(title, color: AppTheme.greyText, fontSize: AppFontSize.mediumM),
        verticalSpace(10),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          obscureText: obscureText,
          maxLines: maxLine,
          style: TextStyle(fontWeight: fontWeightNormal()),
          decoration: InputDecoration(
            fillColor: AppTheme.grey,
            filled: true,
            errorStyle: const TextStyle(height: 0),
            errorText: validate != null
                ? validate
                    ? null
                    : ""
                : null,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide:
                  const BorderSide(color: AppTheme.greyBorder, width: 1.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide:
                  const BorderSide(color: AppTheme.greyBorder, width: 1.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: AppTheme.red, width: 1.0),
            ),
            suffixIcon: icon,
          ),
        ),
      ],
    ),
  );
}

Widget textFieldNoLabel(TextEditingController controller,
    {bool obscureText = false,
    Function(String)? onChanged,
    TextInputType? keyboardType,
    Widget? icon,
    int? maxLength,
    bool? validate,
    bool addPadding = false,
    bool? enabled}) {
  return Padding(
    padding: EdgeInsets.only(top: addPadding ? 15 : 0),
    child: SizedBox(
      height: 45,
      width: 50,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        obscureText: obscureText,
        maxLength: maxLength,
        enabled: enabled,
        style: TextStyle(fontWeight: fontWeightNormal()),
        decoration: InputDecoration(
          fillColor: AppTheme.grey,
          filled: true,
          counterText: "",
          errorText: validate != null
              ? validate
                  ? null
                  : ""
              : null,
          errorStyle: const TextStyle(height: 0),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                const BorderSide(color: AppTheme.greyBorder, width: 1.0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                const BorderSide(color: AppTheme.greyBorder, width: 1.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: AppTheme.red, width: 1.0),
          ),
          suffixIcon: icon,
        ),
      ),
    ),
  );
}

Widget textFieldNoLabelTransparent(TextEditingController? controller,
    {bool obscureText = false,
    void Function(String)? onChanged,
    TextInputType? keyboardType,
    Widget? icon,
    int? maxLength,
    bool? validate,
    bool addPadding = false,
    bool autofocus = false}) {
  return Padding(
    padding: EdgeInsets.only(top: addPadding ? 15 : 0),
    child: SizedBox(
      height: 45,
      width: 50,
      child: TextField(
        autofocus: autofocus,
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        obscureText: obscureText,
        maxLength: maxLength,
        style: TextStyle(fontWeight: fontWeightNormal(), color: AppTheme.white),
        decoration: InputDecoration(
          hintText: Texts.search,
          hintStyle: const TextStyle(color: AppTheme.white),
          counterText: "",
          errorText: validate != null
              ? validate
                  ? null
                  : ""
              : null,
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppTheme.white)),
          errorStyle: const TextStyle(height: 0),
          suffixIcon: icon,
        ),
      ),
    ),
  );
}

Widget textFieldWithlabelMoneyFormat(
    String title, TextEditingController controller,
    {bool obscureText = false,
    Function(String)? onChanged,
    Widget? textWidget,
    Widget? icon,
    int? maxLength,
    bool? validate,
    bool addPadding = false}) {
  return Padding(
    padding: EdgeInsets.only(top: addPadding ? 15 : 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidget ??
            text(title,
                color: AppTheme.greyText, fontSize: AppFontSize.mediumS),
        verticalSpace(10),
        SizedBox(
          height: 45,
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            obscureText: obscureText,
            maxLength: maxLength,
            style: TextStyle(fontWeight: fontWeightNormal()),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [MoneyInputFormatter()],
            decoration: InputDecoration(
              fillColor: AppTheme.grey,
              filled: true,
              counterText: "",
              errorText: validate != null
                  ? validate
                      ? null
                      : ""
                  : null,
              errorStyle: const TextStyle(height: 0),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide:
                    const BorderSide(color: AppTheme.greyBorder, width: 1.0),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide:
                    const BorderSide(color: AppTheme.greyBorder, width: 1.0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: AppTheme.red, width: 1.0),
              ),
              suffixIcon: icon,
            ),
          ),
        ),
      ],
    ),
  );
}
