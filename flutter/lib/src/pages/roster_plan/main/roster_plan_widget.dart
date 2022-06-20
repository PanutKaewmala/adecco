import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/pages/roster_plan/main/roster_plan_ctrl.dart';
import 'package:ahead_adecco/src/pages/roster_plan/main/roster_plan_model.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import '../../../constants/export_constants.dart';
import 'roster_plan_shift.dart';

Widget buildTapbarRoster(String title, bool onSelected,
    {required double width, required void Function() onPressed, Color? color}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      height: 30,
      color: color ?? AppTheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          textAutoSize(title,
              fontSize: AppFontSize.mediumS,
              fontWeight: onSelected ? FontWeight.bold : fontWeightNormal()),
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

class RosterRow extends StatefulWidget {
  final RosterPlanData rosterPlanData;
  const RosterRow({Key? key, required this.rosterPlanData}) : super(key: key);

  @override
  State<RosterRow> createState() => _RosterRowState();
}

class _RosterRowState extends State<RosterRow> {
  late RosterPlanController controller;
  late RosterModel _rosterModel;
  late String _date;
  bool isShow = false;
  @override
  void initState() {
    controller = Get.find();
    _rosterModel = widget.rosterPlanData.rosterModel;
    _date =
        DateTimeService.timeServerToStringDDMMMYYYY(_rosterModel.start_date) +
            " to " +
            DateTimeService.timeServerToStringDDMMMYYYY(_rosterModel.end_date);
    super.initState();
  }

  bool checkCanEdit() {
    return _rosterModel.status == Keys.pending ||
        _rosterModel.status == Keys.reject;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RosterPlanController>(
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
        child: contianerBorderShadow(
          child: Column(
            children: [
              elevatedButtonCustom(
                onPressed: checkCanEdit()
                    ? () {
                        controller.onClickEditRoster(
                            _rosterModel.id, _rosterModel.type);
                      }
                    : null,
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
                        text(_rosterModel.name,
                            fontSize: AppFontSize.mediumL,
                            fontWeight: FontWeight.bold),
                        const Spacer(),
                        _rosterModel.status == Keys.pending ||
                                _rosterModel.status == Keys.reject
                            ? textStatus(_rosterModel.status)
                            : Container(),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isShow = !isShow;
                            });
                          },
                          child: Container(
                            height: 20,
                            width: 30,
                            alignment: Alignment.centerRight,
                            child: Icon(
                              isShow
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: AppTheme.greyText,
                            ),
                          ),
                        )
                      ],
                    ),
                    verticalSpace(10),
                    text(_date,
                        fontSize: AppFontSize.mediumS,
                        color: AppTheme.greyText),
                  ],
                ),
              ),
              isShow
                  ? RosterShiftDetail(
                      id: _rosterModel.id,
                      rosterPlanData: widget.rosterPlanData,
                      onPress: () {
                        controller.onPressedTab(RosterPlan.currentRoster);
                      },
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
