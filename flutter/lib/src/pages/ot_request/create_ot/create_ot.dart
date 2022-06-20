import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/pages/ot_request/create_ot/create_ot_ctrl.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import 'create_ot_widget.dart';

class CreateOTRequest extends StatelessWidget {
  CreateOTRequest({Key? key}) : super(key: key);
  final PageType? pageType = Get.arguments?[Keys.pageType] ?? PageType.create;
  final int? id = Get.arguments[Keys.overTime]?.id;

  @override
  Widget build(BuildContext context) {
    final CreateOTController controller =
        Get.put(CreateOTController(context, id: id, pageType: pageType));
    return Scaffold(
      appBar: appbarBackground(Texts.otRequest),
      body: controller.obx(
        (state) => Obx(
          () => listViewCustom(controller: controller.listViewCtrl, children: [
            buildQuotaOTTable(
                controller.showQuota.value, controller.overTimeQuotaModel.value,
                onTap: (value) {
              controller.showQuota.value = value;
            }),
            buildOTDetail(controller, controller.overTimeEditModel?.status,
                showStatus: pageType == PageType.edit),
            buildOTDateTime(context, controller),
            buildSelectWorkPlace(controller.selectedWorkPlace.value?.label,
                onTap: () {
              controller.onClickSelectWorkPlace();
            }),
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
          controller.onClickCreate();
        }, onPressedCreate: () {
          controller.onClickCreate();
        }),
      ),
    );
  }
}
