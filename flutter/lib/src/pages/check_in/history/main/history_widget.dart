import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import '../../../../constants/export_constants.dart';

Widget buildHistoryRow(
    CheckInHistoryModel checkInHistoryModel, DateTime selectDate) {
  bool isToday = DateTimeService.checkDateTimeSelected(
      checkInHistoryModel.date_time, selectDate);
  var _textColor = isToday ? AppTheme.white : AppTheme.greyText;
  return SizedBox(
    height: 90,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(15, 7.5, 15, 7.5),
      child: roundElevatedButton(
          onPressed: () {
            Get.toNamed(Routes.historyDetail,
                arguments: {Keys.date: checkInHistoryModel.date_time});
          },
          child: Row(
            children: [
              containerGradient(
                height: 60,
                width: 60,
                color1: AppTheme.mainRed,
                color2: AppTheme.peach,
                padding: const EdgeInsets.all(2),
                child: Container(
                  decoration: isToday
                      ? null
                      : BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      text(
                          DateTimeService.timeServerToStringDD(
                              checkInHistoryModel.date_time),
                          fontSize: AppFontSize.mediumM,
                          color: _textColor),
                      text(
                          DateTimeService.timeServerToStringMMM(
                              checkInHistoryModel.date_time),
                          fontSize: AppFontSize.mediumM,
                          color: _textColor)
                    ],
                  ),
                ),
              ),
              horizontalSpace(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      text(
                        DateTimeService.timeServerToStringDDDD(
                            checkInHistoryModel.date_time),
                        fontSize: AppFontSize.mediumM,
                        fontWeight: FontWeight.bold,
                      ),
                      horizontalSpace(5),
                      dayType(
                          checkInHistoryModel.status,
                          checkInHistoryModel.leave != null
                              ? checkInHistoryModel.leave!.all_day
                              : null),
                    ],
                  ),
                  _buildCheckInTime(
                      true,
                      checkInHistoryModel.check_in != null &&
                              (checkInHistoryModel.leave != null
                                  ? checkInHistoryModel.leave!.all_day
                                  : false)
                          ? DateTimeService.timeServerToStringHHMM(
                              checkInHistoryModel.check_in!)
                          : Keys.defaultTime),
                  _buildCheckInTime(
                      false,
                      checkInHistoryModel.check_out != null &&
                              (checkInHistoryModel.leave != null
                                  ? checkInHistoryModel.leave!.all_day
                                  : false)
                          ? DateTimeService.timeServerToStringHHMM(
                              checkInHistoryModel.check_in!)
                          : Keys.defaultTime),
                ],
              ),
            ],
          )),
    ),
  );
}

Widget _buildCheckInTime(bool isCheckIn, String time) {
  return Row(
    children: [
      SizedBox(
        width: 120,
        child: text(isCheckIn ? Texts.checkIn : Texts.checkOut,
            fontSize: AppFontSize.mediumS, color: AppTheme.greyText),
      ),
      SizedBox(
        width: 120,
        child: text(
          time,
          fontSize: AppFontSize.mediumS,
        ),
      ),
    ],
  );
}

Widget dayType(String? type, bool? allDay) {
  Color _color = AppTheme.white;
  if (type == CalendarStatus.onTime.key) {
    _color = CalendarStatus.onTime.color;
  } else if (type == CalendarStatus.leave.key) {
    _color = CalendarStatus.leave.color;
  } else if (type == CalendarStatus.lated.key) {
    _color = CalendarStatus.lated.color;
  }
  return type != null
      ? Row(
          children: [
            Container(
              height: 5,
              width: 5,
              decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
            ),
            horizontalSpace(5),
            text(type,
                fontSize: AppFontSize.small, fontStyle: FontStyle.italic),
            horizontalSpace(5),
            allDay != null
                ? text("(${Texts.allDay})",
                    fontSize: AppFontSize.small, fontStyle: FontStyle.italic)
                : Container(),
          ],
        )
      : Container();
}
