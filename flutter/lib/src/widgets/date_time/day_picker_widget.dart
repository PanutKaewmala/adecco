import 'package:ahead_adecco/src/config/font_size.dart';
import 'package:ahead_adecco/src/config/theme.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:flutter/material.dart';

class DayPickerCustom extends StatefulWidget {
  final Map<String, String> workDay;
  final List<String> disableDay;
  final void Function(String, bool)? onPressed;

  const DayPickerCustom(
      {Key? key,
      required this.workDay,
      required this.disableDay,
      this.onPressed})
      : super(key: key);

  @override
  _DayPickerCustomState createState() => _DayPickerCustomState();
}

class _DayPickerCustomState extends State<DayPickerCustom> {
  late List<DayInWeek> _daysInWeek;

  @override
  void initState() {
    _daysInWeek = [
      DayInWeek(Keys.sunday, isSelected: widget.workDay[Keys.sunday]!),
      DayInWeek(Keys.monday, isSelected: widget.workDay[Keys.monday]!),
      DayInWeek(Keys.tuesday, isSelected: widget.workDay[Keys.tuesday]!),
      DayInWeek(Keys.wednesday, isSelected: widget.workDay[Keys.wednesday]!),
      DayInWeek(Keys.thursday, isSelected: widget.workDay[Keys.thursday]!),
      DayInWeek(Keys.friday, isSelected: widget.workDay[Keys.friday]!),
      DayInWeek(Keys.saturday, isSelected: widget.workDay[Keys.saturday]!),
    ];

    super.initState();
  }

  void _getSelectedWeekDays(String isSelected, String day) {
    if (isSelected == Keys.workDay) {
      widget.workDay[day] = Keys.dayOff;
    } else if (isSelected == Keys.dayOff) {
      widget.workDay[day] = Keys.workDay;
    }
  }

  Color? _handleTextColor(String onSelect) {
    if (onSelect == Keys.workDay) {
      return AppTheme.white;
    } else if (onSelect == Keys.dayOff) {
      return AppTheme.greyText;
    }
    return AppTheme.greyText;
  }

  Color? _handleFillColor(String onSelect, String day) {
    if (onSelect == Keys.workDay ||
        (checkDisableDay(day) && onSelect == Keys.workDay)) {
      return AppTheme.mainRed;
    } else if (checkDisableDay(day) && onSelect == Keys.dayOff) {
      return AppTheme.greyBorder;
    } else if (onSelect == Keys.dayOff) {
      return AppTheme.grey;
    }
    return AppTheme.greyBorder;
  }

  bool checkDisableDay(String day) {
    return widget.disableDay.contains(day);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _daysInWeek.map(
        (day) {
          return Expanded(
            child: RawMaterialButton(
              elevation: 0,
              fillColor: _handleFillColor(day.isSelected, day.dayName),
              shape: const CircleBorder(
                side: BorderSide.none,
              ),
              onPressed: () {
                if ((day.isSelected != Keys.holiday &&
                        !checkDisableDay(day.dayName)) ||
                    day.isSelected == Keys.workDay) {
                  setState(() {
                    _getSelectedWeekDays(day.isSelected, day.dayName);
                    day.toggleIsSelected();
                  });
                  if (widget.onPressed != null) {
                    if (day.isSelected == Keys.dayOff) {
                      widget.onPressed!(day.dayName, true);
                    } else {
                      widget.onPressed!(day.dayName, false);
                    }
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  day.dayName.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    fontSize: AppFontSize.mediumM,
                    fontWeight: FontWeight.w500,
                    color: _handleTextColor(day.isSelected),
                  ),
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}

class DayInWeek {
  String dayName;
  String isSelected;

  DayInWeek(this.dayName, {this.isSelected = Keys.dayOff});

  void toggleIsSelected() {
    if (isSelected != Keys.holiday) {
      if (isSelected == Keys.dayOff) {
        isSelected = Keys.workDay;
      } else {
        isSelected = Keys.dayOff;
      }
    }
  }
}
