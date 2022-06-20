import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/models/export_models.dart';

class RosterPlanData {
  RosterPlanData({required this.rosterModel});
  final RosterModel rosterModel;
  final isExpanded = false.obs;
  RosterDetailModel? rosterDetailModel;
}
