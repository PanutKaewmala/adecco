import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';
import 'create_pin_point_ctrl.dart';

class CreatePinPoint extends StatelessWidget {
  CreatePinPoint({Key? key}) : super(key: key);
  final int pinPointTypeID = Get.arguments[Keys.id];
  @override
  Widget build(BuildContext context) {
    final CreatePinPointController controller =
        Get.put(CreatePinPointController(context, id: pinPointTypeID));

    bool checkRequire(int index) {
      return controller.pinPointModel.questions[index].require;
    }

    return KeyboardDismisser(
      child: Scaffold(
        appBar: appbarBackground(Texts.createPinPoint),
        body: controller.obx(
          (state) => singleChildScrollViewCustom(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: contianerBorderShadow(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  textWithContainerGradient(Texts.details),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.pinPointModel.questions.length,
                      itemBuilder: (context, index) => checkRequire(index)
                          ? Obx(() => textFieldWithlabel(
                              controller.pinPointModel.questions[index].name +
                                  (checkRequire(index) ? "*" : ""),
                              controller
                                  .textController!.textControllerList[index],
                              addPadding: true,
                              validate: checkRequire(index)
                                  ? controller.textController!.isValid(index)
                                  : null))
                          : textFieldWithlabel(
                              controller.pinPointModel.questions[index].name +
                                  (checkRequire(index) ? "*" : ""),
                              controller.textController!.textControllerList[index],
                              addPadding: true,
                              validate: checkRequire(index) ? controller.textController!.isValid(index) : null)),
                ],
              )),
            ),
          ),
          onLoading: Center(child: LoadingCustom.loadingWidget()),
          onEmpty: Center(child: textNotFoundAndIcon()),
          onError: (error) => Center(child: textErrorAndIcon()),
        ),
        bottomNavigationBar: bottomNavigation(Texts.confirm, onPressed: () {
          controller.onCLickConfirm();
        }),
      ),
    );
  }
}
