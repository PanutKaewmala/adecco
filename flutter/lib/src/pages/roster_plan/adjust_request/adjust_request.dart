import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/pages/roster_plan/adjust_request/adjust_request_ctrl.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import 'adjust_request_widget.dart';

class AdjustRequestPage extends StatelessWidget {
  AdjustRequestPage({Key? key}) : super(key: key);
  final DateTime _dateTime = Get.arguments[Keys.date];

  @override
  Widget build(BuildContext context) {
    final AdjustRequestController controller =
        Get.put(AdjustRequestController(_dateTime));
    return Scaffold(
      appBar: appbarBackground(Texts.adjustRequest),
      body: Padding(
          padding: const EdgeInsets.all(15),
          child: contianerBorderShadow(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
            textWithContainerGradient(DateTimeService.getStringDateTimeFormat(
                _dateTime,
                format: DateTimeFormatCustom.mmmmyyyy)),
            verticalSpace(15),
            Center(
              child: controller.obx(
                (state) => ListView.separated(
                  separatorBuilder: ((context, index) =>
                      dividerHorizontal(top: 10, bottom: 10)),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: state!.length,
                  itemBuilder: (context, index) => buildDayPlace(state[index]),
                ),
                onLoading: LoadingCustom.loadingWidget(),
                onEmpty: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: textNotFoundAndIcon(),
                ),
                onError: (error) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: textErrorAndIcon(),
                ),
              ),
            ),
          ]))),
    );
  }
}
