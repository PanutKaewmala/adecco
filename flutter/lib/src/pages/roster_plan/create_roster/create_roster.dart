import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import '../../../constants/export_constants.dart';
import 'create_roster_ctrl.dart';
import 'create_roster_widget.dart';
import 'crete_roster_shift.dart';

class CreateRosterPage extends StatelessWidget {
  CreateRosterPage({Key? key}) : super(key: key);
  final int? _rosterID = Get.arguments[Keys.id];
  final PageType _pageType = Get.arguments[Keys.pageType];

  @override
  Widget build(BuildContext context) {
    final CreateRosterController controller = Get.put(CreateRosterController(
        context,
        rosterID: _rosterID,
        pageType: _pageType));

    return KeyboardDismisser(
        child: Scaffold(
      appBar: appbarBackground(
          _pageType == PageType.create ? Texts.createRoster : Texts.editRoster),
      body: controller.obx(
        (state) => Obx(
          () => listViewCustom(
            controller: controller.listViewCtrl,
            children: [
              controller.showRejectReason()
                  ? buildReasonReject(
                      controller.rosterEditModel?.remark ?? '', "Admin")
                  : Container(),
              buildCreateRosterInfo(controller.textFieldControllers.title,
                  controller.textFieldControllers.description, controller),
              buildDuration(context, controller,
                  selected: controller.selectedWorkingHours.value,
                  leaveTypeList: controller.workingTimeList),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.shiftList.length,
                  itemBuilder: (context, index) {
                    bool _showDelete = controller.shiftList.length == index + 1;
                    return RosterShift(index: index, showDelete: _showDelete);
                  }),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                child: roundButton(Texts.addShift,
                    fontSize: AppFontSize.mediumM,
                    buttonColor: AppTheme.white,
                    textColor: AppTheme.mainRed,
                    side: true, onPressed: () {
                  controller.onClickAddShift();
                }),
              ),
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
                              controller.onClickCancel();
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
    ));
  }
}
