import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import 'history_ctrl.dart';
import 'history_widget.dart';

class HistoryPage extends GetView<HistoryController> {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HistoryController controller = Get.put(HistoryController(context));
    return Scaffold(
      appBar: appbarBackground(Texts.attendanceHistory),
      body: Column(
        children: [
          GetBuilder<HistoryController>(
            builder: (controller) => CalendarWidget(
              dateTime: controller.selectDateTime.value,
              selectFirstDay: true,
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
                CalendarStatus.onTime,
                CalendarStatus.leave,
                CalendarStatus.lated
              ],
              events: controller.events,
            ),
          ),
          Expanded(
            child: controller.obx(
              (state) => ListView.builder(
                controller: controller.listViewCtrl,
                itemCount: state!.length,
                itemBuilder: (context, index) => AutoScrollTag(
                  key: ValueKey(index),
                  controller: controller.listViewCtrl,
                  index: index,
                  child: buildHistoryRow(
                      state[index], controller.selectDateTime.value),
                ),
              ),
              onLoading: Center(child: LoadingCustom.loadingWidget()),
              onEmpty: Center(child: textNotFoundAndIcon()),
              onError: (error) => Center(child: textErrorAndIcon()),
            ),
          ),
        ],
      ),
    );
  }
}
