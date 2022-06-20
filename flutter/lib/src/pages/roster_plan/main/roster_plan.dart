import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/pages/roster_plan/main/roster_plan_widget.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import 'roster_plan_ctrl.dart';

class RosterPlanPage extends StatelessWidget {
  const RosterPlanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RosterPlanController controller =
        Get.put(RosterPlanController(context: context));
    return Scaffold(
      appBar: appbarBackgroundWithAction(Texts.rosterPlan,
          action: appBarButton(Texts.create, onPressed: () {
            context.showBottomSheetCustom(
                onTap: (index) {
                  controller.navigatorMenu(index);
                },
                item: [Texts.createRoster, Texts.createDayOff],
                title: Texts.plsSelectAct);
          })),
      body: Obx(
        () => Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 15),
              child: Row(
                children: [
                  buildTapbarRoster(
                      Texts.currentRoter, controller.tabList[0].value,
                      width: 100, onPressed: () {
                    controller.onPressedTab(RosterPlan.currentRoster);
                  }),
                  dividerVertical(25, left: 10, right: 10),
                  buildTapbarRoster(Texts.pending, controller.tabList[1].value,
                      width: 100, onPressed: () {
                    controller.onPressedTab(RosterPlan.pending);
                  }),
                  dividerVertical(25, left: 10, right: 10),
                  buildTapbarRoster(
                    Texts.rejected,
                    controller.tabList[2].value,
                    width: 100,
                    onPressed: () {
                      controller.onPressedTab(RosterPlan.rejected);
                    },
                  )
                ],
              ),
            ),
            Expanded(
              child: listViewCustom(
                controller: controller.listViewCtrl,
                children: [
                  GetBuilder<RosterPlanController>(
                    builder: (_) => CalendarWidget(
                      dateTime: controller.selectDateTime.value,
                      onDayTap: (DateTime date) {},
                      onSelectedMouth: (DateTime date) {
                        controller.onClickSelectMonthYear(date);
                      },
                      onSelectedYear: (DateTime date) {
                        controller.onClickSelectMonthYear(date);
                      },
                      status: const [
                        CalendarStatus.workDay,
                        CalendarStatus.dayOff,
                        CalendarStatus.pending
                      ],
                      events: controller.events,
                      disableSelectDay: true,
                      onClickAdjust: controller.onClickAdjust,
                    ),
                  ),
                  controller.obx(
                    (state) => ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state!.length,
                        itemBuilder: (context, index) =>
                            RosterRow(rosterPlanData: state[index])),
                    onLoading: SizedBox(
                        height: 30.h,
                        child: Center(child: LoadingCustom.loadingWidget())),
                    onEmpty: SizedBox(
                      height: 30.h,
                      child: Center(child: textNotFoundAndIcon()),
                    ),
                    onError: (error) => SizedBox(
                      height: 30.h,
                      child: Center(child: textErrorAndIcon()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
