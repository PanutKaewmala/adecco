import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/pages/roster_plan/edit_roster_shift/edit_roster_shift_ctrl.dart';
import 'package:ahead_adecco/src/pages/roster_plan/edit_roster_shift/edit_roster_shift_widget.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class EditRosterShift extends StatelessWidget {
  EditRosterShift({Key? key}) : super(key: key);
  final int _shiftID = Get.arguments[Keys.id];
  final int _shiftIndex = Get.arguments[Keys.index] ?? 1;
  final int _rosterID = Get.arguments[Keys.roster];
  @override
  Widget build(BuildContext context) {
    final EditRosterShiftController controller = Get.put(
        EditRosterShiftController(
            context: context, shiftID: _shiftID, rosterID: _rosterID));
    return KeyboardDismisser(
      child: Scaffold(
          appBar: appbarBackground(Texts.editShift),
          body: controller.obx(
            (state) =>
                listViewCustom(controller: controller.listViewCtrl, children: [
              EditRosterShiftWidget(shiftIndex: _shiftIndex),
            ]),
            onLoading: Center(child: LoadingCustom.loadingWidget()),
            onEmpty: Center(child: textNotFoundAndIcon()),
            onError: (error) => Center(child: textErrorAndIcon()),
          ),
          bottomNavigationBar: bottomNavigation(Texts.save, onPressed: () {
            controller.onClickSave();
          })),
    );
  }
}
