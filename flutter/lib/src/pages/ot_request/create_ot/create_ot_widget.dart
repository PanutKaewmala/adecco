import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';
import 'create_ot_ctrl.dart';

Widget buildQuotaOTTable(bool show, OverTimeQuotaModel? overTimeQuotaModel,
    {required void Function(bool onTap) onTap}) {
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
                    text(Texts.otQuota,
                        fontSize: AppFontSize.mediumL,
                        fontWeight: FontWeight.bold),
                  ],
                ),
                Row(
                  children: [
                    Visibility(
                        visible: show,
                        child: text("Hide",
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
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(4),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1)
                },
                children: _buildListTableRow(overTimeQuotaModel),
              ),
            ],
          ),
        ),
      ],
    )),
  );
}

List<TableRow> _buildListTableRow(OverTimeQuotaModel? overTimeQuotaModel) {
  List<TableRow> _list = [];
  _list.add(TableRow(children: [
    _buildTextTable(Texts.quota, center: false),
    _buildTextTable("${overTimeQuotaModel?.ot_quota ?? "-"}"),
    _buildTextTable(Texts.hrs),
  ]));
  _list.add(TableRow(children: [
    _buildTextTable(Texts.used, center: false),
    _buildTextTable("${overTimeQuotaModel?.ot_quota_used ?? "-"}"),
    _buildTextTable(Texts.hrs),
  ]));

  return _list;
}

Widget _buildTextTable(String title, {bool center = true}) {
  return SizedBox(
      height: 25,
      child: text(title,
          fontSize: AppFontSize.mediumS,
          color: center ? AppTheme.black : AppTheme.greyText,
          textAlign: center ? TextAlign.center : TextAlign.left));
}

Widget buildOTDetail(CreateOTController controller, String? status,
    {required bool showStatus}) {
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
              showStatus ? textStatus(status!) : Container(),
            ],
          ),
          verticalSpace(10),
          textFieldWithlabel(Texts.title, controller.textController.title,
              validate: controller.textController.isValidTitle()),
          verticalSpace(10),
          textFieldMutiLineWithlabel(
              Texts.description, controller.textController.description,
              maxLine: 5),
        ],
      ),
    ),
  );
}

Widget buildOTDateTime(BuildContext context, CreateOTController controller) {
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
            text(Texts.dateAndTime,
                fontSize: AppFontSize.mediumL, fontWeight: FontWeight.bold),
          ],
        ),
        verticalSpace(10),
        textLableWithContainer(
            Texts.date,
            controller.startDate.value != null
                ? DateTimeService.getStringDateTimeFormat(
                    controller.startDate.value!,
                    format: DateTimeFormatCustom.ddmmmyyyy)
                : Texts.hintDate, onTap: () {
          TimePickerCustom.openDateTimePicker(
            context,
            onConfirm: (dateTime) {
              controller.startDate.value = DateTimeService.setDate(
                  true,
                  dateTime,
                  controller.startDate.value,
                  controller.endDate.value);
            },
          );
        },
            textColor:
                controller.startDate.value == null ? AppTheme.greyText : null),
        verticalSpace(15),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: textLableWithContainer(
                  Texts.startTime,
                  controller.startDate.value != null
                      ? DateTimeService.getStringDateTimeFormat(
                          controller.startDate.value!,
                          format: DateTimeFormatCustom.hhmm)
                      : Texts.hintTime, onTap: () {
                if (controller.startDate.value != null) {
                  TimePickerCustom.openTimePicker(
                    context,
                    controller.startDate.value!,
                    onChangeDateTime: (dateTime) {
                      controller.startDate.value = DateTimeService.setDate(
                          true,
                          dateTime,
                          controller.startDate.value,
                          controller.endDate.value);
                    },
                  );
                }
              },
                  textColor: controller.startDate.value == null
                      ? AppTheme.greyText
                      : null),
            ),
            horizontalSpace(15),
            Flexible(
              flex: 1,
              child: textLableWithContainer(
                  Texts.endTime,
                  controller.endDate.value != null
                      ? DateTimeService.getStringDateTimeFormat(
                          controller.endDate.value!,
                          format: DateTimeFormatCustom.hhmm)
                      : Texts.hintTime, onTap: () {
                if (controller.startDate.value != null) {
                  TimePickerCustom.openTimePicker(
                    context,
                    controller.endDate.value ?? controller.startDate.value!,
                    onChangeDateTime: (dateTime) {
                      controller.endDate.value = DateTimeService.setDate(
                          false,
                          dateTime,
                          controller.startDate.value,
                          controller.endDate.value);
                      debugPrint(
                          "controller.endDate.value ${controller.endDate.value}");
                    },
                  );
                }
              },
                  textColor: controller.startDate.value == null
                      ? AppTheme.greyText
                      : null),
            ),
          ],
        )
      ],
    )),
  );
}

Widget buildSelectWorkPlace(String? workPlace, {void Function()? onTap}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
    child: contianerBorderShadow(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWithContainerGradient(Texts.workPlace),
          verticalSpace(15),
          textLableWithContainer(
            Texts.location + "*",
            workPlace ?? Texts.select,
            onTap: onTap,
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
          ),
        ],
      ),
    ),
  );
}
