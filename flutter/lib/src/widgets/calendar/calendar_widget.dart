import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';

import '../export_widget.dart';

// ignore: must_be_immutable
class CalendarWidget extends StatefulWidget {
  final void Function(DateTime) onDayTap;
  final void Function(DateTime) onSelectedMouth;
  final void Function(DateTime) onSelectedYear;
  final void Function(List<String>)? onMultiDayTap;
  final List<CalendarStatus>? status;
  final Map<DateTime, List<String>>? events;
  bool multiSelectDay;
  bool selectFirstDay;
  DateTime dateTime;
  DateTime? firstDay;
  DateTime? lastDay;
  Map<int, List<DateTime>>? weekDayOff;
  Set<DateTime>? selectedDays;
  String? monthDuration;
  List<String>? disableDay;
  bool disableSelectDay;
  void Function()? onClickAdjust;

  CalendarWidget(
      {Key? key,
      required this.onDayTap,
      required this.onSelectedMouth,
      required this.onSelectedYear,
      required this.dateTime,
      this.onMultiDayTap,
      this.status,
      this.events,
      this.multiSelectDay = false,
      this.selectFirstDay = false,
      this.firstDay,
      this.lastDay,
      this.weekDayOff,
      this.selectedDays,
      this.monthDuration,
      this.disableDay,
      this.disableSelectDay = false,
      this.onClickAdjust})
      : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  ValueNotifier<int?> selectedMounth = ValueNotifier(null);
  ValueNotifier<int?> selectedYear = ValueNotifier(null);
  final DateTime _dateTimeNow = DateTime.now();

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  void dispose() {
    selectedMounth.dispose();
    selectedYear.dispose();
    super.dispose();
  }

  void initData() {
    setYearSelect();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    int _week =
        Jiffy([selectedDay.year, selectedDay.month, selectedDay.day]).week;

    String _selectDayString = DateTimeService.dateTimeToStringDDDD(selectedDay);

    if (selectedDay.isAfter(widget.firstDay!) &&
        selectedDay.isBefore(widget.lastDay!.add(const Duration(days: 1))) &&
        !widget.disableDay!.contains(_selectDayString.toLowerCase())) {
      if (widget.selectedDays!.contains(selectedDay)) {
        widget.selectedDays!.remove(selectedDay);

        if (widget.weekDayOff![_week]!.contains(selectedDay)) {
          widget.weekDayOff![_week]!.remove(selectedDay);
          if (widget.weekDayOff![_week]!.isEmpty) {
            widget.weekDayOff!.remove(_week);
          }
        }
      } else {
        if (widget.weekDayOff![_week] == null) {
          widget.weekDayOff!.addAll({
            _week: [selectedDay]
          });
          widget.selectedDays!.add(selectedDay);
        } else {
          if (widget.weekDayOff![_week]!.length < 2) {
            widget.weekDayOff![_week]!.add(selectedDay);
            widget.selectedDays!.add(selectedDay);
          }
        }
      }
      widget.dateTime = focusedDay;
      List<DateTime> _dayList = widget.selectedDays!.toList();
      List<String> _dayFormatList = List.generate(_dayList.length,
          (index) => DateTimeService.getStringTimeServer(_dayList[index]));
      setState(() {
        widget.onMultiDayTap!(_dayFormatList);
      });
    }
  }

  List<int> setYearSelect() {
    List<int> _year = [];
    if (widget.firstDay != null && widget.lastDay != null) {
      for (var i = 0; i <= widget.lastDay!.year - widget.firstDay!.year; i++) {
        _year.add(widget.firstDay!.year + i);
      }
      return _year;
    } else {
      _year.add(_dateTimeNow.year - 1);
      _year.add(_dateTimeNow.year);
      _year.add(_dateTimeNow.year + 1);
      return _year;
    }
  }

  List<int> setMonth() {
    List<int> _mounth = [];
    if (widget.firstDay != null && widget.lastDay != null) {
      for (var i = 0;
          i <= widget.lastDay!.month - widget.firstDay!.month;
          i++) {
        _mounth.add(widget.firstDay!.month + i);
      }
      return _mounth;
    } else {
      _mounth = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
      return _mounth;
    }
  }

  void _onClickSeletedYear(int? value) {
    int? _newYear = value;
    if (selectedYear.value == _newYear) {
      widget.onSelectedYear(widget.dateTime);
    } else if (value == (widget.firstDay?.year ?? _dateTimeNow.year)) {
      DateTime _check = DateTime(value!, widget.dateTime.month,
          widget.selectFirstDay ? 1 : _dateTimeNow.day);
      if (widget.firstDay != null) {
        if (widget.firstDay!.year == value) {
          widget.dateTime = widget.firstDay!;
        } else {
          widget.dateTime = _check;
        }
        widget.onSelectedYear(widget.dateTime);
      } else {
        widget.dateTime = _check;
      }
    } else {
      widget.dateTime = DateTime(value!, widget.dateTime.month, 1);
    }
  }

  void _onClickSeletedMonth(int? value) {
    int? _newMonth = value;
    if (selectedMounth.value == _newMonth) {
      widget.onSelectedMouth(widget.dateTime);
    } else if (value == (widget.firstDay?.month ?? _dateTimeNow.month)) {
      DateTime _check = DateTime(widget.dateTime.year, value!,
          widget.selectFirstDay ? 1 : _dateTimeNow.day);
      if (widget.firstDay != null) {
        if (widget.firstDay!.month == value) {
          widget.dateTime = widget.firstDay!;
        } else {
          widget.dateTime = _check;
        }
      } else {
        widget.dateTime = _check;
      }
      widget.onSelectedMouth(widget.dateTime);
    } else {
      widget.dateTime = DateTime(widget.dateTime.year, value!, 1);
    }
    selectedMounth.value = value;
  }

  void _onClickPageChange(DateTime dateTime) {
    if (dateTime.year != selectedYear.value) {
      selectedYear.value = dateTime.year;
      DateTime _dateTime = DateTime(dateTime.year, dateTime.month, 1);
      widget.onSelectedYear(_dateTime);
    } else {
      selectedMounth.value = dateTime.month;
      DateTime _dateTime = DateTime(_dateTimeNow.year, dateTime.month, 1);
      widget.onSelectedMouth(_dateTime);
    }
  }

  List<String> _getEventsForDay(DateTime day) {
    DateTime _dateTime = DateTimeService.timeServerToDateTimeWithFormatZ(day);
    return widget.events?[_dateTime] ?? [];
  }

  Color checkCalendarStatus(String status) {
    switch (status) {
      case Keys.leave:
        return CalendarStatus.leave.color;
      case Keys.pending:
        return CalendarStatus.pending.color;
      case Keys.dayOff:
        return CalendarStatus.dayOff.color;
      case Keys.workDay:
        return CalendarStatus.workDay.color;
      case Keys.overTime:
        return CalendarStatus.overTime.color;
      default:
        return AppTheme.greyText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: contianerBorderShadow(
            child: Column(
              children: [
                widget.monthDuration != null
                    ? _buildMonthDuartion(
                        widget.monthDuration!, widget.firstDay!.year.toString())
                    : _buildSelectMonthAndYear(),
                verticalSpace(15),
                TableCalendar(
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, day, events) {
                      return _buildStatsEvent(events);
                    },
                  ),
                  onDisabledDayTapped: (day) {},
                  calendarStyle: CalendarStyle(
                    selectedDecoration: const BoxDecoration(
                        color: AppTheme.mainRed, shape: BoxShape.circle),
                    todayDecoration: const BoxDecoration(
                        color: AppTheme.greyBorder, shape: BoxShape.circle),
                    todayTextStyle: textStyle(),
                    selectedTextStyle: textStyle(color: AppTheme.white),
                    defaultTextStyle: textStyle(),
                    weekendTextStyle: textStyle(),
                    disabledTextStyle: textStyle(color: AppTheme.greyText),
                    outsideTextStyle: textStyle(color: AppTheme.greyText),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: textStyle(),
                    weekendStyle: textStyle(color: AppTheme.mainRed),
                  ),
                  headerVisible: false,
                  rowHeight: 40,
                  firstDay: widget.firstDay ??
                      DateTime.utc(_dateTimeNow.year - 1, 1, 1),
                  lastDay: widget.lastDay ??
                      DateTime.utc(_dateTimeNow.year + 1, 12, 31),
                  focusedDay: widget.dateTime,
                  selectedDayPredicate: (day) {
                    return widget.monthDuration != null ||
                            widget.disableSelectDay != false
                        ? false
                        : widget.multiSelectDay
                            ? widget.selectedDays!.contains(day)
                            : isSameDay(widget.dateTime, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    if (widget.disableSelectDay == false) {
                      widget.multiSelectDay
                          ? _onDaySelected(selectedDay, focusedDay)
                          : setState(() {
                              widget.onDayTap(selectedDay);
                            });
                    }
                  },
                  onPageChanged: _onClickPageChange,
                  eventLoader: (day) {
                    return _getEventsForDay(day);
                  },
                ),
                widget.status != null
                    ? Column(
                        children: [
                          verticalSpace(15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildStatus(widget.status![0]),
                              horizontalSpace(20),
                              _buildStatus(widget.status![1]),
                              horizontalSpace(20),
                              widget.status!.length > 2
                                  ? _buildStatus(widget.status![2])
                                  : Container(),
                            ],
                          )
                        ],
                      )
                    : Container()
              ],
            ),
          ),
        ),
        widget.onClickAdjust != null
            ? Positioned(
                top: 30,
                right: 30,
                child: GestureDetector(
                    onTap: widget.onClickAdjust,
                    child: const Icon(
                      Icons.info,
                      color: AppTheme.greyText,
                    )))
            : Container(),
      ],
    );
  }

  Row _buildSelectMonthAndYear() {
    List<int> _month = setMonth();
    List<int> _year = setYearSelect();
    if (selectedMounth.value != null &&
        !_month.contains(selectedMounth.value)) {
      selectedMounth.value = _month.first;
    }
    if (selectedYear.value != null && !_year.contains(selectedYear.value)) {
      selectedYear.value = _year.first;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ValueListenableBuilder(
            valueListenable: selectedMounth,
            builder: (context, int? value, child) {
              return Container(
                decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.all(5),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<int>(
                    dropdownMaxHeight: 200,
                    dropdownDecoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8)),
                    hint: Container(
                      width: 23.w,
                      alignment: Alignment.center,
                      child: text(
                          DateFormat(DateTimeFormatCustom.mmmm)
                              .format(DateTime(0, widget.dateTime.month)),
                          fontSize: AppFontSize.mediumM),
                    ),
                    items: _month
                        .map((item) => DropdownMenuItem<int>(
                              value: item,
                              child: text(
                                DateFormat(DateTimeFormatCustom.mmmm)
                                    .format(DateTime(0, item)),
                                fontSize: AppFontSize.mediumM,
                              ),
                            ))
                        .toList(),
                    value: value,
                    onChanged: (value) {
                      setState(() {
                        _onClickSeletedMonth(value);
                      });
                    },
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppTheme.mainRed,
                    ),
                    buttonHeight: 30,
                    buttonWidth: 30.w,
                    itemHeight: 40,
                    alignment: Alignment.center,
                  ),
                ),
              );
            }),
        ValueListenableBuilder(
            valueListenable: selectedYear,
            builder: (context, int? value, child) {
              return Container(
                padding: const EdgeInsets.all(5),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<int>(
                    dropdownDecoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8)),
                    hint: Container(
                        width: 13.w,
                        alignment: Alignment.center,
                        child: text("${widget.dateTime.year}",
                            fontSize: AppFontSize.mediumM)),
                    items: _year
                        .map((item) => DropdownMenuItem<int>(
                              value: item,
                              child:
                                  text("$item", fontSize: AppFontSize.mediumM),
                            ))
                        .toList(),
                    value: value,
                    onChanged: (value) {
                      setState(() {
                        _onClickSeletedYear(value);
                      });
                    },
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppTheme.greyText,
                    ),
                    buttonHeight: 30,
                    buttonWidth: 20.w,
                    itemHeight: 40,
                    alignment: Alignment.center,
                  ),
                ),
              );
            })
      ],
    );
  }

  Row _buildMonthDuartion(String month, String year) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.all(5),
          child: text(month,
              fontSize: AppFontSize.mediumM, color: AppTheme.mainRed),
        ),
        horizontalSpace(10),
        text(year, fontSize: AppFontSize.mediumM),
      ],
    );
  }

  Widget _buildStatus(CalendarStatus status) {
    return Row(
      children: [
        Container(
          height: 5,
          width: 5,
          decoration:
              BoxDecoration(color: status.color, shape: BoxShape.circle),
        ),
        horizontalSpace(5),
        text(status.title,
            fontSize: AppFontSize.small, fontStyle: FontStyle.italic),
      ],
    );
  }

  Widget _buildStatsEvent(List<Object?> events) {
    List<Widget> _markerList = [];

    for (var event in events) {
      debugPrint("test $event");
      Color color = checkCalendarStatus(event.toString());
      if (event != Keys.holiday) {
        _markerList.add(Container(
          height: 9,
          width: 9,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              color: AppTheme.white, shape: BoxShape.circle),
          child: Container(
            height: 5,
            width: 5,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ));
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _markerList,
    );
  }
}
