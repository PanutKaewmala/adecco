import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/asset_strings.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

Widget backButton({void Function()? onPressed}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: AppTheme.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 0,
          padding: EdgeInsets.zero,
          shadowColor: Colors.transparent,
          minimumSize: const Size(45, 45) // put the width and height you want
          ),
      onPressed: onPressed ??
          () {
            Get.back();
          },
      child: const Icon(
        Icons.arrow_back,
        color: AppTheme.mainRed,
      ));
}

PreferredSizeWidget appbarBackground(String title,
    {String? subTitle, Widget? action, void Function()? onPressedBack}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(80),
    child: Stack(
      children: [
        Container(
          color: AppTheme.mainRed,
          width: double.maxFinite,
          height: double.maxFinite,
          child: Image.asset(
            Assets.appbar,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          left: 15,
          bottom: 15,
          child: SizedBox(
            height: 45,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                backButton(onPressed: onPressedBack),
                horizontalSpace(15),
                Container(
                  width: 50.w,
                  height: 45,
                  alignment: Alignment.centerLeft,
                  child: subTitle == null
                      ? Container(
                          alignment: Alignment.centerLeft,
                          child: text(title,
                              fontSize: AppFontSize.mediumL,
                              color: AppTheme.white,
                              fontWeight: FontWeight.bold,
                              maxline: 1),
                        )
                      : FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              text(subTitle,
                                  fontSize: AppFontSize.mediumM,
                                  color: AppTheme.white),
                              text(title,
                                  fontSize: AppFontSize.mediumL,
                                  color: AppTheme.white,
                                  fontWeight: FontWeight.bold,
                                  maxline: 1),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
            right: 15,
            bottom: 15,
            child: SizedBox(height: 45, child: action ?? Container())),
      ],
    ),
  );
}

PreferredSizeWidget appbarBackgroundWithSearch(String title,
    {String? subTitle,
    Widget? action,
    void Function()? onPressedBack,
    bool showSearch = false,
    TextEditingController? textEditingController,
    void Function(String)? onChanged}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(80),
    child: Stack(
      children: [
        Container(
          color: AppTheme.mainRed,
          width: double.maxFinite,
          height: double.maxFinite,
          child: Image.asset(
            Assets.appbar,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          left: 15,
          bottom: 15,
          child: SizedBox(
            height: 45,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                backButton(onPressed: onPressedBack),
                horizontalSpace(15),
                showSearch
                    ? SizedBox(
                        width: 65.w,
                        height: 45,
                        child: textFieldNoLabelTransparent(
                            textEditingController,
                            onChanged: onChanged,
                            autofocus: true))
                    : Container(
                        width: 50.w,
                        height: 45,
                        alignment: Alignment.centerLeft,
                        child: subTitle == null
                            ? Container(
                                alignment: Alignment.centerLeft,
                                child: text(title,
                                    fontSize: AppFontSize.mediumL,
                                    color: AppTheme.white,
                                    fontWeight: FontWeight.bold,
                                    maxline: 1),
                              )
                            : FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    text(
                                      subTitle,
                                      fontSize: AppFontSize.mediumL,
                                      color: AppTheme.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    text(
                                      title,
                                      fontSize: AppFontSize.mediumM,
                                      color: AppTheme.white,
                                      maxline: 1,
                                    ),
                                  ],
                                ),
                              ),
                      ),
              ],
            ),
          ),
        ),
        Positioned(
            right: 15,
            bottom: 15,
            child: SizedBox(height: 45, child: action ?? Container())),
      ],
    ),
  );
}

PreferredSizeWidget appbarBackgroundWithAction(String title,
    {String? subTitle,
    bool oneLineTitle = true,
    Widget? action,
    bool background = true}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(80),
    child: Stack(
      children: [
        background
            ? Container(
                color: AppTheme.mainRed,
                width: double.maxFinite,
                height: double.maxFinite,
                child: Image.asset(
                  Assets.appbar,
                  fit: BoxFit.cover,
                ),
              )
            : Container(),
        Positioned(
          left: 15,
          bottom: 15,
          child: SizedBox(
            height: 45,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                backButton(),
                horizontalSpace(15),
                SizedBox(
                  width: 50.w,
                  height: 45,
                  child: subTitle == null
                      ? Container(
                          alignment: Alignment.centerLeft,
                          child: text(title,
                              fontSize: AppFontSize.mediumL,
                              color: AppTheme.white,
                              fontWeight: FontWeight.bold,
                              maxline: 1),
                        )
                      : FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              text(subTitle,
                                  fontSize: AppFontSize.mediumM,
                                  color: AppTheme.white),
                              text(title,
                                  fontSize: AppFontSize.mediumL,
                                  color: AppTheme.white,
                                  fontWeight: FontWeight.bold,
                                  maxline: 1)
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
            right: 15,
            bottom: 15,
            child: SizedBox(height: 45, child: action ?? Container())),
      ],
    ),
  );
}

PreferredSizeWidget appbarNoBackground({Color? color, Widget? iconButton}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(80),
    child: Container(
      color: color ?? Colors.transparent,
      child: Stack(
        children: [
          Positioned(
            left: 15,
            bottom: 15,
            child: SizedBox(
              height: 45,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [backButton()],
              ),
            ),
          ),
          Positioned(
            right: 15,
            bottom: 15,
            child: SizedBox(height: 45, child: iconButton ?? Container()),
          ),
        ],
      ),
    ),
  );
}
