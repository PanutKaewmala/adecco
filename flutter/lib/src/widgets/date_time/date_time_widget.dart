import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

Widget dateSelectWithLabel(
    BuildContext context, DateTime? startDate, DateTime? endDate,
    {void Function(DateTime)? onPressStartDate,
    void Function(DateTime)? onPressEndDate,
    String? lableStart,
    String? lableEnd,
    DateTime? endDateStart,
    DateTime? minTime,
    DateTime? maxTime}) {
  return Row(
    children: [
      Flexible(
        flex: 1,
        child: textLableWithContainer(
          lableStart ?? Texts.startDate,
          startDate != null
              ? DateTimeService.getStringDateTimeFormat(startDate,
                  format: DateTimeFormatCustom.ddmmmyyyy)
              : Texts.hintDate,
          onTap: onPressStartDate != null
              ? () {
                  TimePickerCustom.openDateTimePicker(context,
                      onConfirm: onPressStartDate);
                }
              : null,
          icon: SvgPicture.asset(Assets.calendar),
        ),
      ),
      horizontalSpace(15),
      Flexible(
        flex: 1,
        child: textLableWithContainer(
          lableEnd ?? Texts.endDate,
          endDate != null
              ? DateTimeService.getStringDateTimeFormat(endDate,
                  format: DateTimeFormatCustom.ddmmmyyyy)
              : Texts.hintDate,
          onTap: onPressEndDate != null
              ? () {
                  if (startDate != null) {
                    TimePickerCustom.openDateTimePicker(
                      context,
                      endDateStart: endDateStart,
                      onConfirm: onPressEndDate,
                      minTime: minTime,
                      maxTime: maxTime,
                    );
                  } else {
                    DialogCustom.showSnackBar(
                        title: Texts.alert, message: Texts.plsSelectStartTime);
                  }
                }
              : null,
          icon: SvgPicture.asset(Assets.calendar),
        ),
      ),
    ],
  );
}

Widget oneDateSelectWithLabel(
  BuildContext context,
  DateTime? startDate, {
  void Function(DateTime)? onPressSelectDate,
  String? lableStart,
}) {
  return textLableWithContainer(
    lableStart ?? Texts.startDate,
    startDate != null
        ? DateTimeService.getStringDateTimeFormat(startDate,
            format: DateTimeFormatCustom.ddmmmyyyy)
        : Texts.hintDate,
    onTap: onPressSelectDate != null
        ? () {
            TimePickerCustom.openDateTimePicker(context,
                onConfirm: onPressSelectDate);
          }
        : null,
    icon: SvgPicture.asset(Assets.calendar),
  );
}

Widget timeSelectWithLabel(
    BuildContext context, DateTime? startTime, DateTime? endTime,
    {required void Function(DateTime) onPressStartDate,
    required void Function(DateTime) onPressEndDate,
    String? lableStart,
    String? lableEnd}) {
  return Row(
    children: [
      Flexible(
          flex: 1,
          child: textLableWithContainer(
              Texts.startTime,
              startTime != null
                  ? DateTimeService.getStringDateTimeFormat(startTime,
                      format: DateTimeFormatCustom.hhmm)
                  : Texts.hintTime, onTap: () {
            startTime ??= DateTime.now();
            TimePickerCustom.openTimePicker(
              context,
              startTime!,
              onChangeDateTime: onPressStartDate,
            );
          })),
      horizontalSpace(15),
      Flexible(
          flex: 1,
          child: textLableWithContainer(
              Texts.endTime,
              endTime != null
                  ? DateTimeService.getStringDateTimeFormat(endTime,
                      format: DateTimeFormatCustom.hhmm)
                  : Texts.hintTime, onTap: () {
            if (startTime != null) {
              endTime ??= DateTime.now();
              TimePickerCustom.openTimePicker(
                context,
                endTime!,
                onChangeDateTime: onPressEndDate,
              );
            } else {
              DialogCustom.showSnackBar(
                  title: Texts.alert, message: Texts.plsSelectStartTime);
            }
          })),
    ],
  );
}

Widget dateWithLabel(DateTime? startDate, DateTime? endDate,
    {String? lableStart, String? lableEnd}) {
  return Row(
    children: [
      Flexible(
        flex: 1,
        child: textLableWithContainer(
          lableStart ?? Texts.startDate,
          startDate != null
              ? DateTimeService.getStringDateTimeFormat(startDate,
                  format: DateTimeFormatCustom.ddmmmyyyy)
              : Texts.hintDate,
          icon: SvgPicture.asset(Assets.calendar),
        ),
      ),
      horizontalSpace(15),
      Flexible(
        flex: 1,
        child: textLableWithContainer(
          lableEnd ?? Texts.endDate,
          endDate != null
              ? DateTimeService.getStringDateTimeFormat(endDate,
                  format: DateTimeFormatCustom.ddmmmyyyy)
              : Texts.hintDate,
          icon: SvgPicture.asset(Assets.calendar),
        ),
      ),
    ],
  );
}
