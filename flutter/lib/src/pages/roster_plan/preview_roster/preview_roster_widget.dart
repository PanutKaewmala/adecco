import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/pages/roster_plan/main/roster_plan_widget.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class PreviewRosterShift extends StatefulWidget {
  final RosterDetailModel rosterDetailModel;
  const PreviewRosterShift({Key? key, required this.rosterDetailModel})
      : super(key: key);

  @override
  State<PreviewRosterShift> createState() => _PreviewRosterShiftState();
}

class _PreviewRosterShiftState extends State<PreviewRosterShift> {
  final List<bool> shiftList = [];
  int isSelected = 0;
  String _date = "";

  @override
  void initState() {
    _date = DateTimeService.timeServerToStringDDMMMYYYY(
            widget.rosterDetailModel.start_date) +
        " to " +
        DateTimeService.timeServerToStringDDMMMYYYY(
            widget.rosterDetailModel.end_date);
    widget.rosterDetailModel.shifts.asMap().forEach((key, value) {
      if (key == 0) {
        shiftList.add(true);
      } else {
        shiftList.add(false);
      }
    });
    super.initState();
  }

  void onPressedShiftTab(int index) {
    isSelected = index;
    for (int i = 0; i < shiftList.length; i++) {
      shiftList[i] = i == index;
    }
    setState(() {});
  }

  String checkDayWorkPlace(List<String> place) {
    String _place = "";
    _place = place.toString().replaceAll("[", "").replaceAll(']', '');
    return _place;
  }

  int checkDayCount(ShiftDetailModel shiftDetailModel) {
    int _day = 0;
    if (shiftDetailModel.monday != null) {
      _day++;
    }
    if (shiftDetailModel.tuesday != null) {
      _day++;
    }
    if (shiftDetailModel.wednesday != null) {
      _day++;
    }
    if (shiftDetailModel.thursday != null) {
      _day++;
    }
    if (shiftDetailModel.friday != null) {
      _day++;
    }
    if (shiftDetailModel.saturday != null) {
      _day++;
    }
    if (shiftDetailModel.sunday != null) {
      _day++;
    }
    return _day;
  }

  @override
  Widget build(BuildContext context) {
    ShiftDetailModel _shiftDetailModel =
        widget.rosterDetailModel.shifts[isSelected];
    Widget buildShiftTabTitle() {
      return SizedBox(
        height: 40,
        child: ListView.builder(
            itemCount: shiftList.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, indexShift) => Row(
                  children: [
                    buildTapbarRoster(
                      "Shift ${indexShift + 1}",
                      shiftList[indexShift],
                      width: 50,
                      color: AppTheme.white,
                      onPressed: () {
                        onPressedShiftTab(indexShift);
                      },
                    ),
                    indexShift + 1 == shiftList.length
                        ? Container()
                        : dividerVertical(20, left: 5, right: 5)
                  ],
                )),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: contianerBorderShadow(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                text(widget.rosterDetailModel.name,
                    fontSize: AppFontSize.mediumL, fontWeight: FontWeight.bold),
              ],
            ),
            verticalSpace(10),
            text(_date,
                fontSize: AppFontSize.mediumS, color: AppTheme.greyText),
            dividerHorizontal(top: 10, bottom: 10),
            buildShiftTabTitle(),
            Padding(
              padding: const EdgeInsets.only(left: 15, bottom: 15),
              child: text(
                  DateTimeService.timeServerToStringDDMMMYYYY(
                          _shiftDetailModel.from_date) +
                      " to " +
                      DateTimeService.timeServerToStringDDMMMYYYY(
                          _shiftDetailModel.to_date),
                  fontSize: AppFontSize.mediumS,
                  color: AppTheme.greyText),
            ),
            dividerHorizontal(bottom: 10),
            Column(
              children: [
                _shiftDetailModel.monday != null
                    ? shiftDay(Texts.monday, _shiftDetailModel.working_hour,
                        checkDayWorkPlace(_shiftDetailModel.monday!))
                    : Container(),
                _shiftDetailModel.tuesday != null
                    ? shiftDay(Texts.tuesday, _shiftDetailModel.working_hour,
                        checkDayWorkPlace(_shiftDetailModel.tuesday!))
                    : Container(),
                _shiftDetailModel.wednesday != null
                    ? shiftDay(Texts.wednesday, _shiftDetailModel.working_hour,
                        checkDayWorkPlace(_shiftDetailModel.wednesday!))
                    : Container(),
                _shiftDetailModel.thursday != null
                    ? shiftDay(Texts.thursday, _shiftDetailModel.working_hour,
                        checkDayWorkPlace(_shiftDetailModel.thursday!))
                    : Container(),
                _shiftDetailModel.friday != null
                    ? shiftDay(Texts.friday, _shiftDetailModel.working_hour,
                        checkDayWorkPlace(_shiftDetailModel.friday!))
                    : Container(),
                _shiftDetailModel.saturday != null
                    ? shiftDay(Texts.saturday, _shiftDetailModel.working_hour,
                        checkDayWorkPlace(_shiftDetailModel.saturday!))
                    : Container(),
                _shiftDetailModel.sunday != null
                    ? shiftDay(Texts.sunday, _shiftDetailModel.working_hour,
                        checkDayWorkPlace(_shiftDetailModel.sunday!))
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
