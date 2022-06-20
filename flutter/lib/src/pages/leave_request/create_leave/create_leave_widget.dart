import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';
import 'package:flutter/cupertino.dart' as ios;
import 'package:path/path.dart' as lib_path;

import 'create_leave_ctrl.dart';

Widget buildQuotaTable(bool show,
    {required void Function(bool onTap) onTap,
    required List<LeaveQuotaModel> leaveQuotaList}) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: contianerBorderShadow(
        child: Column(
      children: [
        Column(
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
                    text(Texts.leaveQuota,
                        fontSize: AppFontSize.mediumL,
                        fontWeight: FontWeight.bold),
                  ],
                ),
                Row(
                  children: [
                    Visibility(
                        visible: show,
                        child: text(Texts.hide,
                            fontSize: AppFontSize.mediumS,
                            color: AppTheme.greyText)),
                    horizontalSpace(5),
                    RotatedBox(
                      quarterTurns: show ? 2 : 4,
                      child: GestureDetector(
                        onTap: () {
                          show = !show;
                          onTap(show);
                        },
                        child: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppTheme.greyText,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
        Visibility(
          visible: show,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: text(UserConfig.getProjectDate(),
                    fontSize: AppFontSize.small, color: AppTheme.greyText),
              ),
              dividerHorizontal(top: 5, bottom: 5),
              Row(children: [
                _buildHeadTable(4, Texts.type.toUpperCase(), center: false),
                _buildHeadTable(2, Texts.total.toUpperCase()),
                _buildHeadTable(2, Texts.used.toUpperCase()),
                _buildHeadTable(2, Texts.remain.toUpperCase()),
              ]),
              dividerHorizontal(top: 5, bottom: 5),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(4),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(2),
                },
                children: _buildListTableRow(leaveQuotaList),
              ),
            ],
          ),
        ),
      ],
    )),
  );
}

List<TableRow> _buildListTableRow(List<LeaveQuotaModel> leaveQuotaList) {
  List<TableRow> _list = [];
  for (var item in leaveQuotaList) {
    _list.add(TableRow(children: [
      _buildTextTable(item.type, center: false),
      _buildTextTable("${item.total.toInt()}"),
      _buildTextTable("${item.used.toInt()}"),
      _buildTextTable("${item.remained.toInt()}"),
    ]));
  }
  return _list;
}

Widget buildDetail(CreateLeaveController controller, String? status,
    {required LeaveTypeDetailModel? selected,
    required void Function(LeaveTypeDetailModel? onSelected) onSelected,
    required List<LeaveTypeDetailModel> leaveTypeList,
    required bool showPending}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
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
                      fontSize: AppFontSize.mediumL,
                      fontWeight: FontWeight.bold),
                ],
              ),
              showPending ? buildStatus(status!) : Container(),
            ],
          ),
          verticalSpace(10),
          textFieldWithlabel(Texts.title, controller.textController.title,
              validate: controller.textController.isValidTitle()),
          verticalSpace(10),
          textFieldMutiLineWithlabel(
              Texts.description, controller.textController.description,
              maxLine: 5),
          verticalSpace(10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text(Texts.leaveName,
                  fontSize: AppFontSize.mediumS, color: AppTheme.greyText),
              verticalSpace(10),
              DropDownCustom(
                listItem: leaveTypeList,
                selected: selected,
                border: true,
                height: 45,
                onSelected: (value) {
                  onSelected(value);
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget buildStatus(String status) {
  String title;
  Color color1;
  Color color2;

  if (status == LeaveRequest.pending.key) {
    title = LeaveRequest.pending.title;
    color1 = AppTheme.orange;
    color2 = AppTheme.orangeText;
  } else if (status == LeaveRequest.reject.title) {
    title = LeaveRequest.reject.title;
    color1 = AppTheme.pink2;
    color2 = AppTheme.redText;
  } else {
    title = '';
    color1 = AppTheme.white;
    color2 = AppTheme.white;
  }
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
    decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(10), color: color1),
    child: text(title,
        fontSize: AppFontSize.small,
        fontStyle: FontStyle.italic,
        color: color2),
  );
}

Widget buildDate(BuildContext context, CreateLeaveController controller) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
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
                text(Texts.dateAndTime,
                    fontSize: AppFontSize.mediumL, fontWeight: FontWeight.bold),
              ],
            ),
            Row(
              children: [
                text(Texts.allDay, fontSize: AppFontSize.mediumM),
                horizontalSpace(10),
                ios.CupertinoSwitch(
                  activeColor: AppTheme.peach,
                  onChanged: (value) {
                    controller.onToggleAllDay(value);
                  },
                  value: controller.allDay.value,
                ),
              ],
            )
          ],
        ),
        verticalSpace(10),
        controller.allDay.value
            ? Column(
                children: [
                  textLableWithContainer(
                      Texts.startDate,
                      controller.startDate.value != null
                          ? DateTimeService.getStringDateTimeFormat(
                              controller.startDate.value!,
                              format: DateTimeFormatCustom.ddmmmyyyy)
                          : Texts.hintDate, onTap: () {
                    TimePickerCustom.openDateTimePicker(
                      context,
                      onConfirm: (dateTime) {
                        controller.setDate(true, dateTime);
                      },
                    );
                  }),
                  textLableWithContainer(
                      Texts.endDate,
                      controller.endDate.value != null
                          ? DateTimeService.getStringDateTimeFormat(
                              controller.endDate.value!,
                              format: DateTimeFormatCustom.ddmmmyyyy)
                          : Texts.hintDate,
                      padding: const EdgeInsets.only(right: 5, top: 15),
                      onTap: () {
                    if (controller.startDate.value != null) {
                      TimePickerCustom.openDateTimePicker(
                        context,
                        minTime: controller.startDate.value,
                        onConfirm: (dateTime) {
                          controller.setDate(false, dateTime);
                        },
                      );
                    } else {
                      DialogCustom.showSnackBar(
                          title: Texts.alert,
                          message: Texts.plsSelectStartTime);
                    }
                  }),
                ],
              )
            : Table(
                children: [
                  TableRow(children: [
                    textLableWithContainer(
                        Texts.startDate,
                        controller.startDate.value != null
                            ? DateTimeService.getStringDateTimeFormat(
                                controller.startDate.value!,
                                format: DateTimeFormatCustom.ddmmmyyyy)
                            : Texts.hintDate,
                        padding: const EdgeInsets.only(right: 5), onTap: () {
                      TimePickerCustom.openDateTimePicker(
                        context,
                        onConfirm: (dateTime) {
                          controller.setDate(true, dateTime);
                        },
                      );
                    }),
                    textLableWithContainer(
                        Texts.startTime,
                        controller.startDate.value != null
                            ? DateTimeService.getStringDateTimeFormat(
                                controller.startDate.value!,
                                format: DateTimeFormatCustom.hhmm)
                            : Texts.hintTime,
                        padding: const EdgeInsets.only(left: 5), onTap: () {
                      if (controller.startDate.value != null) {
                        TimePickerCustom.openTimePicker(
                          context,
                          controller.startDate.value!,
                          onChangeDateTime: (dateTime) {
                            controller.setTime(true, dateTime);
                          },
                        );
                      }
                    })
                  ]),
                  TableRow(children: [
                    textLableWithContainer(
                        Texts.endDate,
                        controller.endDate.value != null
                            ? DateTimeService.getStringDateTimeFormat(
                                controller.endDate.value!,
                                format: DateTimeFormatCustom.ddmmmyyyy)
                            : Texts.hintDate,
                        padding: const EdgeInsets.only(right: 5, top: 15),
                        onTap: () {
                      if (controller.startDate.value != null) {
                        TimePickerCustom.openDateTimePicker(
                          context,
                          minTime: controller.startDate.value,
                          onConfirm: (dateTime) {
                            controller.setDate(false, dateTime);
                          },
                        );
                      } else {
                        DialogCustom.showSnackBar(
                            title: Texts.alert,
                            message: Texts.plsSelectStartTime);
                      }
                    }),
                    textLableWithContainer(
                        Texts.endTime,
                        controller.endDate.value != null
                            ? DateTimeService.getStringDateTimeFormat(
                                controller.endDate.value!,
                                format: DateTimeFormatCustom.hhmm)
                            : Texts.hintTime,
                        padding: const EdgeInsets.only(left: 5, top: 15),
                        onTap: () {
                      if (controller.startDate.value != null) {
                        TimePickerCustom.openTimePicker(
                          context,
                          controller.endDate.value!,
                          onChangeDateTime: (dateTime) {
                            controller.setTime(false, dateTime);
                          },
                        );
                      }
                    })
                  ])
                ],
              ),
      ],
    )),
  );
}

Widget buildAttachment(CreateLeaveController controller) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
    child: contianerBorderShadow(
        child: Column(
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
            text(Texts.uploadAttachments,
                fontSize: AppFontSize.mediumL, fontWeight: FontWeight.bold),
          ],
        ),
        GestureDetector(
          onTap: () {
            controller.onClickAddFile();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: DottedBorder(
              color: AppTheme.greyText,
              strokeWidth: 2,
              borderType: BorderType.RRect,
              dashPattern: const [8, 4],
              radius: const Radius.circular(8),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                    color: AppTheme.grey,
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add,
                      color: AppTheme.greyText,
                      size: 20,
                    ),
                    text(
                      Texts.add,
                      fontSize: AppFontSize.mediumM,
                      color: AppTheme.greyText,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: controller.fileList.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return buildFileItem(controller.fileList[index].path, onTap: () {
              controller.removeFile(index);
            });
          },
          separatorBuilder: (context, index) {
            return dividerHorizontal(top: 10, bottom: 10);
          },
        ),
      ],
    )),
  );
}

Widget uplaodAttachmentLst(CreateLeaveController controller) {
  return Visibility(
    visible: controller.uploadAttachmentModelList.isNotEmpty,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
      child: contianerBorderShadow(
        child: Column(
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
                text(Texts.oldAttachments,
                    fontSize: AppFontSize.mediumL, fontWeight: FontWeight.bold),
              ],
            ),
            verticalSpace(10),
            ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: controller.uploadAttachmentModelList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return buildFileItem(
                    controller.uploadAttachmentModelList[index].name,
                    onTap: () {
                  controller.onClickRemoveAttachment(index);
                });
              },
              separatorBuilder: (context, index) {
                return dividerHorizontal(top: 10, bottom: 10);
              },
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildFileItem(String path, {void Function()? onTap}) {
  String basename = lib_path.basename(path);
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(
        flex: 9,
        child: text(basename,
            fontSize: AppFontSize.mediumS, overflow: TextOverflow.ellipsis),
      ),
      Flexible(
        flex: 1,
        child: GestureDetector(
            onTap: onTap,
            child: SvgPicture.asset("assets/images/icons/trash.svg")),
      ),
    ],
  );
}

Widget _buildHeadTable(int flex, String title, {bool center = true}) {
  return Flexible(
    flex: flex,
    child: SizedBox(
        width: double.maxFinite,
        child: text(title,
            fontSize: AppFontSize.small,
            color: AppTheme.greyText,
            fontWeight: FontWeight.bold,
            textAlign: center ? TextAlign.center : TextAlign.left)),
  );
}

Widget _buildTextTable(String title, {bool center = true}) {
  return SizedBox(
      height: 25,
      child: text(title,
          fontSize: AppFontSize.mediumS,
          color: AppTheme.black,
          textAlign: center ? TextAlign.center : TextAlign.left));
}
