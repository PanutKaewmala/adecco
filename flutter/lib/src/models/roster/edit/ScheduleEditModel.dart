// ignore_for_file: non_constant_identifier_names, file_names
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:json_annotation/json_annotation.dart';
part 'ScheduleEditModel.g.dart';

@JsonSerializable()
class ScheduleEditModel {
  int? id;
  final String? sunday;
  final String? monday;
  final String? tuesday;
  final String? wednesday;
  final String? thursday;
  final String? friday;
  final String? saturday;
  final List<PlaceRosterModel> workplaces;
  int? shift;

  ScheduleEditModel(
      {required this.sunday,
      required this.monday,
      required this.tuesday,
      required this.wednesday,
      required this.thursday,
      required this.friday,
      required this.saturday,
      required this.workplaces});

  factory ScheduleEditModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleEditModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleEditModelToJson(this);
}
