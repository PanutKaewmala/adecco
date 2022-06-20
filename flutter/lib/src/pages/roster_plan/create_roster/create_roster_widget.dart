import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/pages/roster_plan/create_roster/create_roster_ctrl.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import '../../../constants/export_constants.dart';
import '../../../models/export_models.dart';

Widget buildCreateRosterInfo(TextEditingController title,
    TextEditingController description, CreateRosterController controller) {
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
            controller.rosterEditModel?.status == Keys.pending ||
                    controller.rosterEditModel?.status == Keys.reject
                ? textStatus(controller.rosterEditModel!.status!)
                : Container(),
          ],
        ),
        verticalSpace(10),
        textFieldWithlabel(Texts.rosterName, title,
            validate: controller.textFieldControllers.isValidTitle()),
        verticalSpace(10),
        textFieldMutiLineWithlabel(Texts.description, description, maxLine: 5)
      ],
    )),
  );
}

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

Widget buildDuration(
  BuildContext context,
  CreateRosterController controller, {
  required WorkingHoursModel? selected,
  required List<WorkingHoursModel> leaveTypeList,
}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
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
              ),
        controller.selectedWorkingHours.value != null
            ? buildDayWorkingHours(controller.showDayDetail.value,
                controller.selectedWorkingHours.value, onTap: (v) {
                controller.showDayDetail.value = v;
              })
            : Container()
      ],
    )),
  );
}

class BottomSheetWorkPlace extends StatefulWidget {
  final String title;
  final Function(dynamic) onSelected;
  final Function(DateTime) onPressStartDate;
  final Function(DateTime) onPressEndDate;
  final List<DropDownModel> items;

  const BottomSheetWorkPlace({
    Key? key,
    required this.title,
    required this.onSelected,
    required this.onPressStartDate,
    required this.onPressEndDate,
    required this.items,
  }) : super(key: key);

  @override
  State<BottomSheetWorkPlace> createState() => _BottomSheetWorkPlaceState();
}

class _BottomSheetWorkPlaceState extends State<BottomSheetWorkPlace> {
  DropDownModel? selectedPlace;
  DateTime? startTime;
  DateTime? endTime;

  void setTime(bool isStartTime, DateTime selectDate) {
    if (isStartTime) {
      if (endTime != null) {
        endTime = null;
      }
      startTime = selectDate;
      widget.onPressStartDate(selectDate);
    } else {
      DateTime adjust = selectDate.add(const Duration(minutes: -14));
      if (startTime!.isBefore(adjust)) {
        endTime = selectDate;
        widget.onPressEndDate(selectDate);
      } else {
        DialogCustom.showSnackBar(
            title: Texts.alert, message: Texts.incorrectTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("list ${widget.items}");
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SafeArea(
        bottom: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            text(widget.title,
                fontSize: AppFontSize.mediumM,
                fontWeight: FontWeight.bold,
                fontFamily: houschkaHead),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                      color: AppTheme.grey,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.greyBorder, width: 1)),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<DropDownModel>(
                      dropdownMaxHeight: 150,
                      dropdownDecoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(8)),
                      items: widget.items
                          .map((item) => DropdownMenuItem<DropDownModel>(
                                value: item,
                                child: text(item.label,
                                    fontSize: AppFontSize.mediumS),
                              ))
                          .toList(),
                      value: selectedPlace,
                      onChanged: (value) {
                        setState(() {
                          selectedPlace = value;
                          widget.onSelected(value);
                        });
                      },
                      icon: widget.items.isNotEmpty
                          ? const Icon(
                              Icons.keyboard_arrow_down,
                              color: AppTheme.greyText,
                            )
                          : LoadingCustom.loadingWidget(size: 15),
                      buttonHeight: 30,
                      buttonWidth: 90.w,
                      itemHeight: 45,
                    ),
                  ),
                )),
            timeSelectWithLabel(context, startTime, endTime,
                lableStart: "Start", lableEnd: "End", onPressStartDate: (date) {
              setState(() {
                setTime(true, date);
              });
            }, onPressEndDate: (date) {
              setState(() {
                setTime(false, date);
              });
            }),
            verticalSpace(15),
            roundButton(Texts.save,
                fontSize: AppFontSize.mediumM,
                buttonColor: AppTheme.mainRed,
                onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
