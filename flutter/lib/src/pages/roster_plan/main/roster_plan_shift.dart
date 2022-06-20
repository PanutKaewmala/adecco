import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/pages/roster_plan/main/roster_plan_model.dart';
import 'package:ahead_adecco/src/services/roster.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import '../../../constants/export_constants.dart';

class RosterShiftDetail extends StatefulWidget {
  final int id;
  final RosterPlanData rosterPlanData;
  final void Function() onPress;
  const RosterShiftDetail(
      {Key? key,
      required this.id,
      required this.rosterPlanData,
      required this.onPress})
      : super(key: key);

  @override
  State<RosterShiftDetail> createState() => _RosterShiftDetailState();
}

class _RosterShiftDetailState extends State<RosterShiftDetail> {
  final List<bool> shiftList = [];
  int isSelected = 0;
  int dayCount = 0;
  late Future<RosterDetailModel?> rosterDetailModelFT;
  late RosterPlanService rosterPlanService;

  @override
  void initState() {
    rosterPlanService = RosterPlanService();
    if (widget.rosterPlanData.rosterDetailModel == null) {
      rosterDetailModelFT = callAPIRosterDetail(widget.id);
    } else {
      addShift(widget.rosterPlanData.rosterDetailModel!);
    }
    super.initState();
  }

  void onPressedShiftTab(int index) {
    setState(() {
      isSelected = index;
      for (int i = 0; i < shiftList.length; i++) {
        shiftList[i] = i == index;
      }
    });
  }

  bool checkPending(int indexShift) {
    ShiftDetailModel shiftDetailModel =
        widget.rosterPlanData.rosterDetailModel!.shifts[indexShift];
    return widget.rosterPlanData.rosterModel.status == Keys.approve &&
        shiftDetailModel.status == Keys.editPending;
  }

  String checkDayWorkPlace(List<String> place) {
    String _place = "";
    _place = place.toString().replaceAll("[", "").replaceAll(']', '');
    return _place;
  }

  Future<RosterDetailModel?> callAPIRosterDetail(int id) async {
    try {
      RosterDetailModel _rosterDetailModel =
          await rosterPlanService.getRosterShiftDetailByID(id);
      addShift(_rosterDetailModel);
      widget.rosterPlanData.rosterDetailModel = _rosterDetailModel;
      return _rosterDetailModel;
    } catch (e) {
      debugPrint("$e");
      return null;
    }
  }

  void addShift(RosterDetailModel rosterDetailModel) {
    rosterDetailModel.shifts.asMap().forEach((key, value) {
      if (key == 0) {
        shiftList.add(true);
      } else {
        shiftList.add(false);
      }
    });
  }

  bool checkEditShift(String fromDate) {
    DateTime _fromDate = DateTimeService.timeServerToDateTime(fromDate);
    debugPrint(
        "_fromDate ${DateTime.now().difference(DateTime.now().add(const Duration(days: -3))).inDays}");
    if (DateTime.now().difference(_fromDate).inDays >= 0) {
      return false;
    } else {
      return widget.rosterPlanData.rosterModel.type != Keys.dayOff &&
          widget.rosterPlanData.rosterModel.status == Keys.approve &&
          widget.rosterPlanData.rosterDetailModel!.roster_setting != true;
    }
  }

  void onClickEditShift(int? shiftID, int rosterID, int index) {
    Get.toNamed(Routes.editRosterShift, arguments: {
      Keys.id: shiftID,
      Keys.roster: rosterID,
      Keys.index: index
    })!
        .then((value) => onBackRefresh(
            function: () {
              widget.onPress();
            },
            value: value));
  }

  @override
  Widget build(BuildContext context) {
    return widget.rosterPlanData.rosterDetailModel != null
        ? _buildShiftDetail(
            widget.rosterPlanData.rosterDetailModel!.shifts[isSelected],
            checkEditShift(widget.rosterPlanData.rosterDetailModel!
                .shifts[isSelected].from_date),
            widget.rosterPlanData.rosterModel.id)
        : FutureBuilder<RosterDetailModel?>(
            future: rosterDetailModelFT,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                ShiftDetailModel _shiftDetailModel =
                    snapshot.data!.shifts[isSelected];
                return _buildShiftDetail(
                    _shiftDetailModel,
                    checkEditShift(_shiftDetailModel.from_date),
                    widget.rosterPlanData.rosterModel.id);
              } else {
                return Center(
                  child: LoadingCustom.loadingWidget(),
                );
              }
            });
  }

  Widget _buildShiftDetail(
      ShiftDetailModel _shiftDetail, bool showEditShift, int rosterID) {
    final String _date =
        DateTimeService.timeServerToStringDDMMMYYYY(_shiftDetail.from_date) +
            " to " +
            DateTimeService.timeServerToStringDDMMMYYYY(_shiftDetail.to_date);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        dividerHorizontal(top: 10, bottom: 10),
        buildShiftTabTitle(),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: SizedBox(
            height: 30,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text(_date,
                    fontSize: AppFontSize.mediumS, color: AppTheme.greyText),
                showEditShift && _shiftDetail.status == Keys.approve
                    ? GestureDetector(
                        onTap: () {
                          onClickEditShift(
                              _shiftDetail.id, rosterID, isSelected + 1);
                        },
                        child: const SizedBox(
                          height: 30,
                          child: Icon(
                            Icons.edit_note_rounded,
                            color: AppTheme.mainRed,
                            size: 30,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
        dividerHorizontal(bottom: 10, top: 10),
        Column(
          children: [
            _shiftDetail.monday != null
                ? shiftDay(Texts.monday, _shiftDetail.working_hour,
                    checkDayWorkPlace(_shiftDetail.monday!))
                : Container(),
            _shiftDetail.tuesday != null
                ? shiftDay(Texts.tuesday, _shiftDetail.working_hour,
                    checkDayWorkPlace(_shiftDetail.tuesday!))
                : Container(),
            _shiftDetail.wednesday != null
                ? shiftDay(Texts.wednesday, _shiftDetail.working_hour,
                    checkDayWorkPlace(_shiftDetail.wednesday!))
                : Container(),
            _shiftDetail.thursday != null
                ? shiftDay(Texts.thursday, _shiftDetail.working_hour,
                    checkDayWorkPlace(_shiftDetail.thursday!))
                : Container(),
            _shiftDetail.friday != null
                ? shiftDay(Texts.friday, _shiftDetail.working_hour,
                    checkDayWorkPlace(_shiftDetail.friday!))
                : Container(),
            _shiftDetail.saturday != null
                ? shiftDay(Texts.saturday, _shiftDetail.working_hour,
                    checkDayWorkPlace(_shiftDetail.saturday!))
                : Container(),
            _shiftDetail.sunday != null
                ? shiftDay(Texts.sunday, _shiftDetail.working_hour,
                    checkDayWorkPlace(_shiftDetail.sunday!))
                : Container(),
          ],
        ),
      ],
    );
  }

  Widget _buildTapbarRoster(String title, bool onSelected,
      {required double width,
      required void Function() onPressed,
      Color? color,
      bool showPending = false}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 30,
        color: color ?? AppTheme.background,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                textAutoSize(title,
                    fontSize: AppFontSize.mediumS,
                    fontWeight:
                        onSelected ? FontWeight.bold : fontWeightNormal()),
                showPending
                    ? Row(
                        children: [
                          horizontalSpace(5),
                          Container(
                            height: 5,
                            width: 5,
                            decoration: BoxDecoration(
                                color: CalendarStatus.pending.color,
                                shape: BoxShape.circle),
                          ),
                        ],
                      )
                    : Container()
              ],
            ),
            verticalSpace(5),
            onSelected
                ? containerGradientH(
                    height: 5,
                    width: width,
                    color1: AppTheme.mainRed,
                    color2: AppTheme.peach)
                : SizedBox(
                    height: 5,
                    width: width,
                  )
          ],
        ),
      ),
    );
  }

  Widget buildShiftTabTitle() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
          itemCount: shiftList.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, indexShift) => Row(
                children: [
                  _buildTapbarRoster(
                      "Shift ${indexShift + 1}", shiftList[indexShift],
                      width: 55, color: AppTheme.white, onPressed: () {
                    onPressedShiftTab(indexShift);
                  }, showPending: checkPending(indexShift)),
                  indexShift + 1 == shiftList.length
                      ? Container()
                      : dividerVertical(20, left: 5, right: 5)
                ],
              )),
    );
  }
}
