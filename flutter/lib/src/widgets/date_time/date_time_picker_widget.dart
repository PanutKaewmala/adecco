import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class TimePickerCustom {
  static openTimePicker(BuildContext context, DateTime timeNow,
      {void Function(DateTime)? onChangeDateTime}) {
    TimeOfDay _time = TimeOfDay.fromDateTime(timeNow);
    Navigator.of(context).push(
      showPicker(
        okStyle: TextStyle(
            fontFamily: Theme.of(context).textTheme.bodyText1!.fontFamily,
            fontWeight: FontWeight.bold),
        cancelStyle: TextStyle(
            fontFamily: Theme.of(context).textTheme.bodyText1!.fontFamily,
            fontWeight: FontWeight.bold),
        context: context,
        is24HrFormat: true,
        iosStylePicker: true,
        value: _time,
        onChange: (timeOfDay) {},
        onChangeDateTime: (date) {
          var dateTime = DateTime(
              timeNow.year, timeNow.month, timeNow.day, date.hour, date.minute);
          onChangeDateTime!(dateTime);
        },
      ),
    );
  }

  static openDateTimePicker(BuildContext context,
      {void Function(DateTime)? onConfirm,
      DateTime? endDateStart,
      DateTime? minTime,
      DateTime? maxTime}) {
    final dateTimeNow = DateTime.now();
    DatePickerCustom.showDatePicker(context,
        theme: DatePickerTheme(
          itemStyle: TextStyle(
              fontSize: AppFontSize.mediumM,
              fontWeight: FontWeight.w500,
              fontFamily: Theme.of(context).textTheme.bodyText1!.fontFamily),
          cancelStyle: TextStyle(
              fontSize: AppFontSize.mediumM,
              fontWeight: FontWeight.w500,
              fontFamily: Theme.of(context).textTheme.bodyText1!.fontFamily),
          doneStyle: TextStyle(
              fontSize: AppFontSize.mediumM,
              fontWeight: FontWeight.w500,
              color: AppTheme.mainRed,
              fontFamily: Theme.of(context).textTheme.bodyText1!.fontFamily),
        ),
        datePickerFormat: DatePickerFormat.dd_mm_yyyy,
        showTitleActions: true,
        minTime: minTime ?? DateTime(dateTimeNow.year, 1, 1),
        maxTime: maxTime ?? DateTime(dateTimeNow.year + 1, 12, 31),
        onChanged: (date) {}, onConfirm: (date) {
      DateTime _date = DateTimeService.timeServerToDateTimeWithFormatZ(date);
      if (onConfirm != null) {
        onConfirm(_date);
      }
    }, currentTime: endDateStart ?? DateTime.now());
  }

  static openMonthYearPicker(BuildContext context,
      {void Function(DateTime)? onChangeDateTime}) {
    final dateTimeNow = DateTime.now();
    DatePickerCustom.showDatePicker(context,
        theme: DatePickerTheme(
          itemStyle: TextStyle(
              fontSize: AppFontSize.mediumM,
              fontWeight: FontWeight.w500,
              fontFamily: Theme.of(context).textTheme.bodyText1!.fontFamily),
          cancelStyle: TextStyle(
              fontSize: AppFontSize.mediumM,
              fontWeight: FontWeight.w500,
              fontFamily: Theme.of(context).textTheme.bodyText1!.fontFamily),
          doneStyle: TextStyle(
              fontSize: AppFontSize.mediumM,
              fontWeight: FontWeight.w500,
              color: AppTheme.mainRed,
              fontFamily: Theme.of(context).textTheme.bodyText1!.fontFamily),
        ),
        datePickerFormat: DatePickerFormat.mmmm_yyyy,
        showTitleActions: true,
        minTime: DateTime(dateTimeNow.year, 1, 1),
        maxTime: DateTime(dateTimeNow.year + 1, 12, 31),
        onChanged: (date) {},
        onConfirm: onChangeDateTime,
        currentTime: DateTime.now());
  }
}
