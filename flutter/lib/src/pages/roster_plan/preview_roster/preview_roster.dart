import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/pages/roster_plan/preview_roster/preview_roster_ctrl.dart';
import 'package:ahead_adecco/src/pages/roster_plan/preview_roster/preview_roster_widget.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class PreviewRosterPage extends StatelessWidget {
  PreviewRosterPage({Key? key}) : super(key: key);
  final Map<String, Object?> _data = Get.arguments[Keys.data];
  final RosterPageType _type = Get.arguments[Keys.roster];
  final PageType _pageType = Get.arguments[Keys.pageType];
  final DateTime _startDate = Get.arguments[Keys.date];
  final int? _id = Get.arguments[Keys.id];
  @override
  Widget build(BuildContext context) {
    final PreviewRosterController controller = Get.put(PreviewRosterController(
        context,
        data: _data,
        rosterType: _type,
        pageType: _pageType,
        rosterID: _id));
    controller.selectDateTime.value = _startDate;

    return Scaffold(
        appBar: appbarBackground(Texts.previewRoster),
        body: controller.obx(
          (state) => ListView(
            controller: controller.listViewCtrl,
            children: [
              GetBuilder<PreviewRosterController>(
                builder: (_) => CalendarWidget(
                  dateTime: controller.selectDateTime.value,
                  onDayTap: (DateTime date) {},
                  onSelectedMouth: (DateTime date) {},
                  onSelectedYear: (DateTime date) {},
                  status: const [CalendarStatus.workDay, CalendarStatus.dayOff],
                  events: controller.events,
                  firstDay: controller.firstDate,
                  lastDay: controller.lastDate,
                  monthDuration: controller.monthDuration,
                  multiSelectDay: true,
                ),
              ),
              PreviewRosterShift(rosterDetailModel: state!),
            ],
          ),
          onLoading: Center(child: LoadingCustom.loadingWidget()),
          onEmpty: Center(child: textNotFoundAndIcon()),
          onError: (error) => Center(child: textErrorAndIcon()),
        ),
        bottomNavigationBar: bottomNavigation(Texts.save, onPressed: () {
          controller.onClickSave();
        }));
  }
}
