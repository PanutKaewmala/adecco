import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import '../../../constants/export_constants.dart';

Widget buildCheckInTime(bool isCheckIn, {String? date, String? time}) {
  return Expanded(
    child: Column(
      children: [
        text(isCheckIn ? Texts.checkInTime : Texts.checkOutTime,
            fontSize: AppFontSize.mediumM, color: AppTheme.greyText),
        text(
            time != null
                ? DateTimeService.timeServerToStringHHMM(time)
                : Keys.defaultTime,
            fontSize: AppFontSize.largeXL,
            color: isCheckIn ? AppTheme.blueText : AppTheme.redText),
        date != null
            ? text(
                DateTimeService.getStringTimeNowFormat(
                    format: DateTimeFormatCustom.mmmmddyyyy),
                fontSize: AppFontSize.mediumM,
                color: AppTheme.black,
                fontStyle: FontStyle.italic)
            : Container()
      ],
    ),
  );
}

Widget buildLisToDay(
    List<CheckInTasksModel> dailyList, ScrollController controller) {
  return ListView.builder(
    controller: controller,
    padding: EdgeInsets.zero,
    itemCount: dailyList.length,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
        child: LocationDetail(checkInTasksModel: dailyList[index]),
      );
    },
  );
}
