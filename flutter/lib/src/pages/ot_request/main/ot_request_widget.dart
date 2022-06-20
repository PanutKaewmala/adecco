import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import 'ot_request_ctrl.dart';

Widget otRequestRow(OverTimeModel overTimeModel, {void Function()? onPressed}) {
  return elevatedButtonCustom(
    color: AppTheme.background,
    onPressed: onPressed,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        containerGradient(
          height: 50,
          width: 120,
          color1: AppTheme.mainRed,
          color2: AppTheme.peach,
          padding: const EdgeInsets.all(2),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                textAutoSize(
                    DateTimeService.timeServerToStringDDMMMYYYY(
                        overTimeModel.start_date),
                    fontSize: AppFontSize.mediumM,
                    color: AppTheme.mainRed,
                    maxline: 1),
              ],
            ),
          ),
        ),
        horizontalSpace(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            text(overTimeModel.title ?? "OT",
                fontSize: AppFontSize.mediumM, fontWeight: FontWeight.bold),
            verticalSpace(5),
            Row(
              children: [
                text(overTimeModel.ot_total, fontSize: AppFontSize.mediumS)
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

Widget buildOvertimeList(
    OTRequestController controller, List<OverTimeModel> otList) {
  return Expanded(
    child: Column(
      children: [
        verticalSpace(15),
        buildTabTitle(controller.isSelected.value),
        verticalSpace(15),
        Expanded(
          child: ListView.separated(
            controller: controller.listViewCtrl,
            padding: EdgeInsets.zero,
            separatorBuilder: (context, index) =>
                dividerHorizontal(top: 15, bottom: 15),
            itemCount: otList.length,
            itemBuilder: (context, index) =>
                otRequestRow(otList[index], onPressed: () {
              controller.onClickOT(otList[index]);
            }),
          ),
        )
      ],
    ),
  );
}
