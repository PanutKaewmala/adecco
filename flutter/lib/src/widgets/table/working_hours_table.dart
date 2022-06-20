import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

Widget buildDayWorkingHours(bool show, WorkingHoursModel? workingHoursModel,
    {required void Function(bool onTap) onTap}) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            text(Texts.workingHoursDetail,
                fontSize: AppFontSize.mediumS, color: AppTheme.greyText),
            const Spacer(),
            SizedBox(
              width: 60,
              height: 20,
              child: roundButton(show ? Texts.hide : Texts.show,
                  fontSize: AppFontSize.small, onPressed: () {
                show = !show;
                onTap(show);
              }),
            ),
          ],
        ),
      ),
      Visibility(
        visible: show,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            dividerHorizontal(top: 5, bottom: 5),
            Row(children: [
              _buildHeadTable(4, Texts.day.toUpperCase(), center: false),
              _buildHeadTable(2, Texts.startTime.toUpperCase()),
              _buildHeadTable(2, Texts.endTime.toUpperCase()),
            ]),
            dividerHorizontal(top: 5, bottom: 5),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(4),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
              },
              children: workingHoursModel != null
                  ? _buildListTableRow(workingHoursModel)
                  : [],
            ),
          ],
        ),
      ),
    ],
  );
}

List<TableRow> _buildListTableRow(WorkingHoursModel leaveQuotaList) {
  List<TableRow> _list = [];
  if (leaveQuotaList.sunday_start_time != null) {
    _list.add(TableRow(children: [
      _buildTextTable(Texts.sunday, center: false),
      _buildTextTable(leaveQuotaList.sunday_start_time?.substring(0, 5) ?? "-"),
      _buildTextTable(leaveQuotaList.sunday_end_time?.substring(0, 5) ?? "-"),
    ]));
  }
  if (leaveQuotaList.monday_start_time != null) {
    _list.add(TableRow(children: [
      _buildTextTable(Texts.monday, center: false),
      _buildTextTable(leaveQuotaList.monday_start_time?.substring(0, 5) ?? "-"),
      _buildTextTable(leaveQuotaList.monday_end_time?.substring(0, 5) ?? "-"),
    ]));
  }
  if (leaveQuotaList.tuesday_start_time != null) {
    _list.add(TableRow(children: [
      _buildTextTable(Texts.tuesday, center: false),
      _buildTextTable(
          leaveQuotaList.tuesday_start_time?.substring(0, 5) ?? "-"),
      _buildTextTable(leaveQuotaList.tuesday_end_time?.substring(0, 5) ?? "-"),
    ]));
  }
  if (leaveQuotaList.wednesday_start_time != null) {
    _list.add(TableRow(children: [
      _buildTextTable(Texts.wednesday, center: false),
      _buildTextTable(
          leaveQuotaList.wednesday_start_time?.substring(0, 5) ?? "-"),
      _buildTextTable(
          leaveQuotaList.wednesday_end_time?.substring(0, 5) ?? "-"),
    ]));
  }
  if (leaveQuotaList.thursday_start_time != null) {
    _list.add(TableRow(children: [
      _buildTextTable(Texts.thursday, center: false),
      _buildTextTable(
          leaveQuotaList.thursday_start_time?.substring(0, 5) ?? "-"),
      _buildTextTable(leaveQuotaList.thursday_end_time?.substring(0, 5) ?? "-"),
    ]));
  }
  if (leaveQuotaList.friday_start_time != null) {
    _list.add(TableRow(children: [
      _buildTextTable(Texts.friday, center: false),
      _buildTextTable(leaveQuotaList.friday_start_time?.substring(0, 5) ?? "-"),
      _buildTextTable(leaveQuotaList.friday_end_time?.substring(0, 5) ?? "-"),
    ]));
  }
  if (leaveQuotaList.saturday_start_time != null) {
    _list.add(TableRow(children: [
      _buildTextTable(Texts.saturday, center: false),
      _buildTextTable(
          leaveQuotaList.saturday_start_time?.substring(0, 5) ?? "-"),
      _buildTextTable(leaveQuotaList.saturday_end_time?.substring(0, 5) ?? "-"),
    ]));
  }
  return _list;
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
