import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/models/export_models.dart';

class ShiftDataModel {
  final int id;
  int maxWorkDay = 0;
  final startDate = Rx<DateTime?>(null);
  final endDate = Rx<DateTime?>(null);
  final placeList = <PlaceShift>[].obs;
  final workDayType = <Map<String, String>>[].obs;
  final List<String> selectedDay = [];
  ShiftDataModel({required this.id});
}

class PlaceShift {
  final placeShift = <PlaceRosterModel>[].obs;
}
