import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

Widget buildTabTitle(int index) {
  switch (index) {
    case 0:
      return textWithContainerGradient(Texts.upcoming);
    case 1:
      return textWithContainerGradient(Texts.pending);
    case 2:
      return textWithContainerGradient(Texts.history);

    default:
      return Container();
  }
}

Widget buildTapbar(String title, bool onSelected,
    {required void Function() onPressed, double? width}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      width: width ?? 80,
      height: 50,
      color: AppTheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          text(title,
              fontSize: AppFontSize.mediumS,
              fontWeight: onSelected ? FontWeight.bold : fontWeightNormal()),
          verticalSpace(5),
          onSelected
              ? containerGradientH(
                  height: 5,
                  width: width ?? 80,
                  color1: AppTheme.mainRed,
                  color2: AppTheme.peach)
              : SizedBox(
                  height: 5,
                  width: width ?? 80,
                )
        ],
      ),
    ),
  );
}

Widget buildDetailQuota(String title, double? number,
    {Color? color, required int flex}) {
  return Flexible(
    flex: flex,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            color != null
                ? Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: color,
                        ),
                        height: 2,
                        width: 6,
                      ),
                      horizontalSpace(5),
                    ],
                  )
                : Container(),
            text(title, fontSize: AppFontSize.mediumS, color: AppTheme.greyText)
          ],
        ),
        verticalSpace(5),
        text("${number != null && number > 0 ? number.toInt() : "-"}",
            fontSize: AppFontSize.mediumL, color: AppTheme.black)
      ],
    ),
  );
}
