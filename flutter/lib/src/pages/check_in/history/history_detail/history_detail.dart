import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import '../../../../constants/export_constants.dart';
import '../../../../models/export_models.dart';
import 'history_detail_ctrl.dart';

class HistoryDetailPage extends StatelessWidget {
  HistoryDetailPage({Key? key}) : super(key: key);
  final String _date = Get.arguments[Keys.date];
  @override
  Widget build(BuildContext context) {
    final HistoryDetailController controller =
        Get.put(HistoryDetailController(context, _date));

    return Scaffold(
      appBar: appbarBackground(Texts.attendanceHistory),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: contianerBorderShadow(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text(
                  DateTimeService.timeServerToStringWithFormat(_date,
                      format: DateTimeFormatCustom.mmmmddyyyy),
                  fontSize: AppFontSize.mediumL),
              verticalSpace(10),
              controller.obx(
                (state) => buildLisToDay(state!, controller.listViewCtrl),
                onLoading: Expanded(
                    child: Center(child: LoadingCustom.loadingWidget())),
                onEmpty: Expanded(
                  child: Center(child: textNotFoundAndIcon()),
                ),
                onError: (error) => Expanded(
                  child: Center(child: textErrorAndIcon()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLisToDay(
      List<CheckInTasksModel> dailyList, ScrollController controller) {
    return Expanded(
      child: ListView.separated(
        controller: controller,
        padding: EdgeInsets.zero,
        itemCount: dailyList.length,
        itemBuilder: (context, index) {
          return LocationDetail(checkInTasksModel: dailyList[index]);
        },
        separatorBuilder: (context, index) {
          return const Divider(
            height: 20,
          );
        },
      ),
    );
  }
}
