import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import '../../../models/export_models.dart';
import 'create_day_off_ctrl.dart';

Widget buildReasonReject(String reason, String rejectedBy) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
    child: contianerBorderShadow(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
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
                text(Texts.reasonReject,
                    fontSize: AppFontSize.mediumL, fontWeight: FontWeight.bold),
              ],
            ),
          ],
        ),
        verticalSpace(10),
        text(reason, fontSize: AppFontSize.mediumM, maxline: 5),
        verticalSpace(10),
        Row(
          children: [
            text(Texts.rejectedBy, fontSize: AppFontSize.mediumM),
            text(rejectedBy, fontSize: AppFontSize.mediumM),
          ],
        ),
      ],
    )),
  );
}

Widget buildCreateDayOffInfo(TextEditingController title,
    TextEditingController description, CreateDayOffController controller) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: contianerBorderShadow(
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
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
                text(Texts.details,
                    fontSize: AppFontSize.mediumL, fontWeight: FontWeight.bold),
              ],
            ),
            controller.rosterDayOffEditModel?.status == Keys.pending ||
                    controller.rosterDayOffEditModel?.status == Keys.reject
                ? textStatus(controller.rosterDayOffEditModel!.status!)
                : Container(),
          ],
        ),
        verticalSpace(10),
        textFieldWithlabel(Texts.rosterName, title,
            validate: controller.textFieldControllers.isValidTitle()),
        verticalSpace(10),
        textFieldMutiLineWithlabel(
          Texts.description,
          description,
          maxLine: 5,
        )
      ],
    )),
  );
}

Widget buildDurationDayOff(
  BuildContext context,
  CreateDayOffController controller, {
  required WorkingHoursModel? selected,
  required List<WorkingHoursModel> leaveTypeList,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: contianerBorderShadow(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
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
                text(Texts.duration,
                    fontSize: AppFontSize.mediumL, fontWeight: FontWeight.bold),
              ],
            ),
          ],
        ),
        verticalSpace(20),
        dateSelectWithLabel(
            context, controller.startDate.value, controller.endDate.value,
            onPressStartDate: (date) {
          controller.setDate(true, date);
        }, onPressEndDate: (date) {
          controller.setDate(false, date);
        }, minTime: controller.startDate.value),
        verticalSpace(10),
        text(Texts.workingHours,
            fontSize: AppFontSize.mediumS, color: AppTheme.greyText),
        verticalSpace(10),
        leaveTypeList.isNotEmpty
            ? DropDownCustomWorkingHours(
                listItem: leaveTypeList,
                selected: selected,
                border: true,
                height: 45,
                onSelected: (value) {
                  controller.onSelectedWorkingHours(value);
                },
              )
            : SizedBox(
                height: 45,
                child: LoadingCustom.loadingWidget(size: 15),
              )
      ],
    )),
  );
}
