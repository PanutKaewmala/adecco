import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import 'calendar_ctrl.dart';
import 'calendar_widget.dart';

class CalendarPage extends GetView<CalendarController> {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CalendarController controller = Get.put(CalendarController(context));

    return Scaffold(
      appBar: appbarBackgroundWithAction(Texts.calendarTitle,
          action: appBarButton(Texts.create, onPressed: () {
            context.showBottomSheetCustom(
                onTap: (index) {
                  controller.navigatorMenu(index);
                },
                item: [Texts.task, Texts.leave, Texts.ot],
                title: Texts.plsSelectAct);
          })),
      body: Column(
        children: [
          GetBuilder<CalendarController>(builder: (controller) {
            return CalendarWidget(
              dateTime: controller.selectDateTime.value,
              onDayTap: (DateTime date) {
                controller.onClickSelectDay(date);
              },
              onSelectedMouth: (DateTime date) {
                controller.onClickSelectMonthYear(date);
              },
              onSelectedYear: (DateTime date) {
                controller.onClickSelectMonthYear(date);
              },
              status: const [
                CalendarStatus.workDay,
                CalendarStatus.leave,
                CalendarStatus.overTime
              ],
              events: controller.events,
            );
          }),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
              child: contianerBorderShadow(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Row(
                        children: [
                          DateTimeService.checkDateTimeIsToDay(
                                  controller.selectDateTime.value)
                              ? Row(children: [
                                  text(Texts.today,
                                      fontSize: AppFontSize.mediumL,
                                      fontWeight: FontWeight.bold),
                                  horizontalSpace(5),
                                ])
                              : Container(),
                          text(
                              DateTimeService.getStringDateTimeFormat(
                                  controller.selectDateTime.value,
                                  format: DateTimeFormatCustom.mmmmddyyyy),
                              fontSize: AppFontSize.mediumL),
                        ],
                      ),
                    ),
                    verticalSpace(10),
                    Expanded(
                      child: controller.obx(
                        (state) => buildToDayList(controller),
                        onLoading: Center(child: LoadingCustom.loadingWidget()),
                        onEmpty: Center(child: textNotFoundAndIcon()),
                        onError: (error) => Center(child: textErrorAndIcon()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
