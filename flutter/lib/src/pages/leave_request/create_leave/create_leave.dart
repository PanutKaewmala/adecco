import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';
import 'create_leave_ctrl.dart';
import 'create_leave_widget.dart';

class CreateLeavePage extends GetView<CreateLeaveController> {
  CreateLeavePage({Key? key}) : super(key: key);
  final PageType? pageType = Get.arguments?[Keys.pageType] ?? PageType.create;
  final int? _id = Get.arguments?[Keys.id];

  @override
  Widget build(BuildContext context) {
    final CreateLeaveController controller =
        Get.put(CreateLeaveController(context, pageType: pageType, id: _id));

    return KeyboardDismisser(
      child: Scaffold(
        appBar: appbarBackground(Texts.leaveRequest),
        body: controller.obx(
          (state) => Obx(
            () => controller.leaveRequestDetailModel!.status ==
                    LeaveRequest.upcoming.key
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: contianerBorderShadow(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                                colors: [
                                              AppTheme.mainRed,
                                              AppTheme.peach
                                            ])),
                                      ),
                                      horizontalSpace(5),
                                      text(Texts.details,
                                          fontSize: AppFontSize.mediumL,
                                          fontWeight: FontWeight.bold),
                                    ],
                                  ),
                                ],
                              ),
                              verticalSpace(10),
                              AbsorbPointer(
                                absorbing: true,
                                child: textFieldWithlabel(
                                  Texts.title,
                                  controller.textController.title,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      buildAttachment(controller),
                      uplaodAttachmentLst(controller),
                    ],
                  )
                : listViewCustom(
                    controller: controller.listViewCtrl,
                    children: [
                        buildQuotaTable(controller.showQuota.value,
                            leaveQuotaList: controller.leaveQuotaDetailList,
                            onTap: (value) {
                          controller.showQuota.value = value;
                        }),
                        buildDetail(controller,
                            controller.leaveRequestDetailModel?.status,
                            leaveTypeList: controller.leaveTypeList,
                            showPending: pageType == PageType.edit,
                            selected: controller.leaveType.value,
                            onSelected: (value) {
                          controller.leaveType.value = value;
                        }),
                        buildDate(context, controller),
                        buildAttachment(controller),
                        uplaodAttachmentLst(controller)
                      ]),
          ),
          onLoading: Center(child: LoadingCustom.loadingWidget()),
          onEmpty: Center(child: textNotFoundAndIcon()),
          onError: (error) => Center(child: textErrorAndIcon()),
        ),
        bottomNavigationBar: Obx(
          () => bottomNavigationWithEdit(
              pageType!, controller.disableButton.value, onPressedCancel: () {
            controller.onClickCancel();
          }, onPressedSave: () {
            controller.leaveRequestDetailModel!.status ==
                    LeaveRequest.upcoming.key
                ? controller.onClickSaveAttachment()
                : controller.onClickCreate();
          }, onPressedCreate: () {
            controller.onClickCreate();
          }),
        ),
      ),
    );
  }
}
