import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/models/roster/AdjustRequestModel.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

Widget buildDayPlace(AdjustRequestModel adjustRequestModel) {
  List<String> workPlaceName =
      adjustRequestModel.workplaces.map((place) => place.name).toList();
  List<String> startEndTime = adjustRequestModel.working_hour.split(" - ");
  return SizedBox(
    height: 60,
    width: double.maxFinite,
    child: Row(
      children: [
        containerGradient(
          height: 50,
          width: 50,
          color1: AppTheme.mainRed,
          color2: AppTheme.peach,
          padding: const EdgeInsets.all(2),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                text(
                    DateTimeService.timeServerToStringDD(
                        adjustRequestModel.date),
                    fontSize: AppFontSize.mediumM,
                    color: AppTheme.mainRed),
              ],
            ),
          ),
        ),
        horizontalSpace(10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  text(adjustRequestModel.day_name,
                      fontSize: AppFontSize.mediumL,
                      fontWeight: FontWeight.bold),
                  horizontalSpace(10),
                  buildStatus(adjustRequestModel.type),
                ],
              ),
              text(
                  adjustRequestModel.workplaces.isNotEmpty
                      ? workPlaceName.join(", ")
                      : "-",
                  fontSize: AppFontSize.mediumS,
                  overflow: TextOverflow.ellipsis,
                  color: AppTheme.greyText,
                  maxline: 2)
            ],
          ),
        ),
        horizontalSpace(10),
        Container(
          alignment: Alignment.centerRight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              text(startEndTime.first, fontSize: AppFontSize.mediumM),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Container(
                  height: 1,
                  width: 5,
                  color: AppTheme.greyText,
                ),
              ),
              text(startEndTime.last,
                  fontSize: AppFontSize.mediumM, color: AppTheme.greyText)
            ],
          ),
        )
      ],
    ),
  );
}

Widget buildStatus(String status) {
  Color color = AppTheme.grey;
  String title = "";
  switch (status) {
    case Keys.workDay:
      title = CalendarStatus.workDay.title;
      color = CalendarStatus.workDay.color;
      break;
    case Keys.dayOff:
      title = CalendarStatus.dayOff.title;
      color = CalendarStatus.dayOff.color;
      break;
    default:
  }
  return Row(
    children: [
      Container(
        height: 5,
        width: 5,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      horizontalSpace(10),
      text(title, fontSize: AppFontSize.small),
    ],
  );
}
