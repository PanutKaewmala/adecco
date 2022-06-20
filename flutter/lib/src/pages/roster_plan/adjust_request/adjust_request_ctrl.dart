import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/models/roster/AdjustRequestModel.dart';
import 'package:ahead_adecco/src/services/roster.dart';

class AdjustRequestController extends GetxController
    with StateMixin<List<AdjustRequestModel>> {
  DateTime dateTime;
  AdjustRequestController(this.dateTime);
  late RosterPlanService rosterPlanService = RosterPlanService();

  @override
  void onInit() {
    rosterPlanService = RosterPlanService();
    callAPIAdjustRequest();
    super.onInit();
  }

  Future callAPIAdjustRequest() async {
    try {
      String _dateTimeString = DateTimeService.getStringTimeServer(dateTime);
      var param = {"month": _dateTimeString};

      change([], status: RxStatus.loading());
      List<AdjustRequestModel> _adjustRequestList =
          await rosterPlanService.getRosterAdjustRequest(param);
      if (_adjustRequestList.isNotEmpty) {
        change(_adjustRequestList, status: RxStatus.success());
      } else {
        change([], status: RxStatus.empty());
      }
    } catch (e) {
      change([], status: RxStatus.error());
    }
  }
}
