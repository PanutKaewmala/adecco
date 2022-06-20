// ignore_for_file: non_constant_identifier_names, file_names
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:json_annotation/json_annotation.dart';
part 'RosterDayOffEditModel.g.dart';

@JsonSerializable()
class RosterDayOffEditModel {
  final int id;
  final String name;
  final String? status;
  final String start_date;
  final String end_date;
  final String? remark;
  final String? description;
  final DayOffEditModel day_off;

  RosterDayOffEditModel(
      {required this.id,
      required this.name,
      required this.status,
      required this.start_date,
      required this.end_date,
      required this.remark,
      required this.description,
      required this.day_off});

  factory RosterDayOffEditModel.fromJson(Map<String, dynamic> json) =>
      _$RosterDayOffEditModelFromJson(json);

  Map<String, dynamic> toJson() => _$RosterDayOffEditModelToJson(this);
}
