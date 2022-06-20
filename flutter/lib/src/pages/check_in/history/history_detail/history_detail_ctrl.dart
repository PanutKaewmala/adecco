import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/services/export_services.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../models/export_models.dart';

class HistoryDetailController extends GetxController
    with StateMixin<List<CheckInTasksModel>> {
  BuildContext context;
  final String date;
  HistoryDetailController(this.context, this.date);
  final ScrollController listViewCtrl = ScrollController();
  late CheckInService checkInService;

  @override
  void onInit() {
    checkInService = CheckInService();
    callAPIDailyTask();
    super.onInit();
  }

  @override
  void onClose() {
    listViewCtrl.dispose();
    super.onClose();
  }

  Future callAPIDailyTask() async {
    try {
      change([], status: RxStatus.loading());
      Position? currrentPosition = await LocationService().determinePosition();
      String _date = DateTimeService.getStringDateTimeFormat(DateTime.now(),
          format: DateTimeFormatCustom.yyyymmdd);
      var params = {
        "date": _date,
        "project": UserConfig.getProjectID().toString(),
        "latitude": currrentPosition!.latitude.toString(),
        "longitude": currrentPosition.longitude.toString()
      };
      await checkInService.checkIndailyTask(params).then((value) async {
        List<CheckInTasksModel> _dailyTaskList = [];
        for (var item in value) {
          _dailyTaskList.add(item);
        }
        if (_dailyTaskList.isNotEmpty) {
          change(_dailyTaskList, status: RxStatus.success());
        } else {
          change([], status: RxStatus.empty());
        }
      });
    } catch (e) {
      debugPrint("$e");
      change([], status: RxStatus.error('Error: $e'));
    }
  }
}
