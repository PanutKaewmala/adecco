import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class DateTimeFormatCustom {
  static const String hhmm = "HH:mm";
  static const String mmmmddyyyy = "MMMM dd, yyyy";
  static const String yyyymmdd = "yyyy-MM-dd";
  static const String ddmmmyyyy = "dd MMM yyyy";
  static const String ddmmmyyyy2 = "dd-MMM-yyyy";
  static const String yyyymmddThhmm = "yyyy-MM-dd'T'HH:mm:ss";
  static const String yyyymmddhhmmZ = "yyyy-MM-dd HH:mm:ss.SSS'Z";
  static const String yyyymmddhhmmZZ = "yyyy-MM-dd HH:mm:ss.sss'Z";
  static const String mmmm = "MMMM";
  static const String ddmmmyyyyhhmm = "dd MMM yyyy HH:mm";
  static const String ddmmmyyyyhhmmss = "yyyy-MM-dd HH:mm:ss";
  static const String dd = "dd";
  static const String eeee = "EEEE";
  static const String mmm = "MMM";
  static const String mmmmyyyy = "MMMM yyyy";
}

class DateTimeService {
  static String getStringTimeNow(DateTime dateTime) {
    String time = DateFormat(DateTimeFormatCustom.hhmm).format(dateTime);
    return time;
  }

  static String getStringTimeServer(DateTime dateTime) {
    String time = DateFormat(DateTimeFormatCustom.yyyymmdd).format(dateTime);
    return time;
  }

  static String getStringTimeServerNow() {
    String time =
        DateFormat(DateTimeFormatCustom.yyyymmdd).format(DateTime.now());
    return time;
  }

  static String getStringTimeNowFormat({required String format}) {
    String time = DateFormat(format).format(DateTime.now());
    return time;
  }

  static String getStringDateTimeFormat(DateTime dateTime,
      {required String format}) {
    String time = DateFormat(format).format(dateTime);
    return time;
  }

  static String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return Texts.goodMorning;
    }
    if (hour < 17) {
      return Texts.goodAfternoon;
    }
    return Texts.goodEvening;
  }

  static String timeServerToStringDD(String time) {
    DateTime _dateTime =
        DateFormat(DateTimeFormatCustom.yyyymmdd).parse(time).toLocal();
    String _time = DateFormat(DateTimeFormatCustom.dd).format(_dateTime);
    return _time;
  }

  static String timeServerToStringHHMM(String time) {
    DateTime _dateTime = DateTime.parse(time).toLocal();
    String _time = DateFormat(DateTimeFormatCustom.hhmm).format(_dateTime);
    return _time;
  }

  static String timeServerToStringDDDD(String time) {
    DateTime _dateTime =
        DateFormat(DateTimeFormatCustom.yyyymmdd).parse(time).toLocal();
    String _time = DateFormat(DateTimeFormatCustom.eeee).format(_dateTime);
    return _time;
  }

  static String dateTimeToStringDDDD(DateTime time) {
    String _time = DateFormat(DateTimeFormatCustom.eeee).format(time);
    return _time;
  }

  static String timeServerToStringMMM(String time) {
    DateTime _dateTime =
        DateFormat(DateTimeFormatCustom.yyyymmdd).parse(time).toLocal();
    String _time = DateFormat(DateTimeFormatCustom.mmm).format(_dateTime);
    return _time;
  }

  static String timeServerToStringMMMM(String time) {
    DateTime _dateTime =
        DateFormat(DateTimeFormatCustom.yyyymmdd).parse(time).toLocal();
    String _time = DateFormat(DateTimeFormatCustom.mmmm).format(_dateTime);
    return _time;
  }

  static String dateTimeToStringHHMM(DateTime time) {
    String _time = DateFormat(DateTimeFormatCustom.hhmm).format(time);
    return _time;
  }

  static String timeServerToStringWithFormat(String time,
      {required String format}) {
    DateTime _dateTime =
        DateFormat(DateTimeFormatCustom.yyyymmdd).parse(time).toLocal();
    String _time = DateFormat(format).format(_dateTime);
    return _time;
  }

  static String timeServerToStringDDMMMYYYY(String time) {
    DateTime _dateTime =
        DateFormat(DateTimeFormatCustom.yyyymmdd).parse(time).toLocal();
    String _time = DateFormat(DateTimeFormatCustom.ddmmmyyyy).format(_dateTime);
    return _time;
  }

  static String timeServerToStringDDMMMYYYY2(String time) {
    DateTime _dateTime =
        DateFormat(DateTimeFormatCustom.yyyymmdd).parse(time).toLocal();
    String _time =
        DateFormat(DateTimeFormatCustom.ddmmmyyyy2).format(_dateTime);
    return _time;
  }

  static DateTime timeServerToDateTime(String time) {
    DateTime _dateTime = DateTime.parse(time).toLocal();
    return _dateTime;
  }

  static DateTime timeServerHHmmToDateTime(String time) {
    DateTime _now = DateTime.now();
    DateTime _dateTime = DateFormat(DateTimeFormatCustom.hhmm).parse(time);
    _dateTime = DateTime(
        _now.year, _now.month, _now.day, _dateTime.hour, _dateTime.minute);
    return _dateTime;
  }

  static DateTime timeServerToDateTimeWithFormat(String time,
      {required String format}) {
    DateTime _dateTime = DateFormat(format).parse(time).toLocal();
    return _dateTime;
  }

  static DateTime timeServerToDateTimeWithFormatZ(DateTime time) {
    DateTime _dateTime = DateTime(time.year, time.month, time.day);
    return _dateTime;
  }

  static DateTime dateTimeToDateTimeWithFormatUtc(DateTime time) {
    DateTime now = DateTime.now();
    var offset = now.timeZoneOffset;

    DateTime _utc = DateTime(time.year, time.month, time.day).toUtc();
    _utc = _utc.add(offset);
    return _utc;
  }

  static bool checkTimeInRange(TimeOfDay startTime, TimeOfDay endTime) {
    TimeOfDay now = TimeOfDay.now();
    return ((now.hour > startTime.hour) ||
            (now.hour == startTime.hour && now.minute >= startTime.minute)) &&
        ((now.hour < endTime.hour) ||
            (now.hour == endTime.hour && now.minute <= endTime.minute));
  }

  static bool checkDateTimeSelected(String dateTime, DateTime selected) {
    DateTime _dateTime =
        DateFormat(DateTimeFormatCustom.yyyymmdd).parse(dateTime).toLocal();
    return _dateTime.difference(selected).inDays == 0 &&
        _dateTime.day == selected.day;
  }

  static bool checkDateTimeIsToDay(DateTime dateTime) {
    DateTime _now = DateTime.now();
    return dateTime.difference(DateTime.now()).inDays == 0 &&
        dateTime.day == _now.day;
  }

  static DateTime? setDate(bool isStartDate, DateTime selectDate,
      DateTime? startDate, DateTime? endDate) {
    Get.focusScope!.unfocus();
    DateTime _now = DateTime.now();
    if (isStartDate) {
      if (startDate == null) {
        startDate = DateTime(selectDate.year, selectDate.month, selectDate.day,
            _now.hour, _now.minute);
      } else {
        startDate = selectDate;
      }
      return startDate;
    } else {
      if (selectDate.difference(startDate!).inDays < 0) {
        DialogCustom.showSnackBar(
            title: Texts.alert, message: Texts.incorrectDate);
        return null;
      } else {
        endDate = selectDate;
        if (selectDate.difference(startDate).inMinutes < 15) {
          endDate = startDate.add(const Duration(minutes: 15));
        }
        return endDate;
      }
    }
  }
}
