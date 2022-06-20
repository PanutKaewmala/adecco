import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import 'create_day_off_ctrl.dart';
import 'create_day_off_widget.dart';

class CreateDayOffPage extends GetView {
  CreateDayOffPage({Key? key}) : super(key: key);
  final PageType _pageType = Get.arguments[Keys.pageType] ?? PageType.create;
  final int? _rosterID = Get.arguments[Keys.id];

  @override
  Widget build(BuildContext context) {
    final CreateDayOffController controller =
        Get.put(CreateDayOffController(context, _pageType, _rosterID));

    return KeyboardDismisser(
      child: Scaffold(
        appBar: appbarBackground(_pageType == PageType.create
            ? Texts.createDayOff
            : Texts.editDayOff),
        body: controller.obx(
          (state) => Obx(
            () => listViewCustom(
              controller: controller.listViewCtrl,
              children: [
                controller.showRejectReason()
                    ? buildReasonReject(
                        controller.rosterDayOffEditModel?.remark ?? '', "Admin")
                    : Container(),
                buildCreateDayOffInfo(controller.textFieldControllers.title,
                    controller.textFieldControllers.description, controller),
                buildDurationDayOff(context, controller,
                    selected: controller.selectedWorkingHours.value,
                    leaveTypeList: controller.workingTimeList),
                controller.startDate.value != null &&
                        controller.endDate.value != null &&
                        controller.selectedWorkingHours.value != null
                    ? GetBuilder<CreateDayOffController>(
                        builder: (controller) => CalendarWidget(
                              selectedDays: controller.setSelectDayList,
                              weekDayOff: controller.weekDay,
                              dateTime: controller.selectDateTime.value,
                              onDayTap: (DateTime date) {},
                              onSelectedMouth: (DateTime date) {},
                              onSelectedYear: (DateTime date) {},
                              multiSelectDay: true,
                              onMultiDayTap: (dayList) {
                                dayList.isNotEmpty
                                    ? controller.selectDayList
                                        .assignAll(dayList)
                                    : Container();
                              },
                              firstDay: controller.startDate.value,
                              lastDay: controller.endDate.value,
                              disableDay: controller.disableDay,
                            ))
                    : Container()
              ],
            ),
          ),
          onLoading: Center(child: LoadingCustom.loadingWidget()),
          onEmpty: Center(child: textNotFoundAndIcon()),
          onError: (error) => Center(child: textErrorAndIcon()),
        ),
        bottomNavigationBar: Obx(() => bottomNavigation(Texts.preview,
            child: _pageType == PageType.edit
                ? Row(
                    children: [
                      Flexible(
                          flex: 1,
                          child: cancaelButton(
                              onPressed: () {
                                controller.onClickPreview();
                              },
                              disable: controller.disablePreview.value)),
                      horizontalSpace(10),
                      Flexible(
                          flex: 1,
                          child: previewButton(
                              onPressed: () {
                                controller.onClickPreview();
                              },
                              disable: controller.disablePreview.value)),
                    ],
                  )
                : previewButton(
                    onPressed: () {
                      controller.onClickPreview();
                    },
                    disable: controller.disablePreview.value))),
      ),
    );
  }
}
