// ignore_for_file: non_constant_identifier_names, file_names
import 'package:json_annotation/json_annotation.dart';

import 'ScheduleEditModel.dart';
part 'ShiftEditModel.g.dart';

@JsonSerializable()
class ShiftEditModel {
  final int? id;
  final String? from_date;
  final String? to_date;
  final String working_hour;
  final List<ScheduleEditModel> schedules;
  final int roster;

  ShiftEditModel(
      {required this.id,
      required this.from_date,
      required this.to_date,
      required this.working_hour,
      required this.schedules,
      required this.roster});

  factory ShiftEditModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftEditModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftEditModelToJson(this);
}
