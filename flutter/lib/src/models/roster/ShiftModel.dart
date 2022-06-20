// ignore_for_file: non_constant_identifier_names, file_names
import 'package:ahead_adecco/src/models/roster/ScheduleModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'ShiftModel.g.dart';

@JsonSerializable()
class ShiftModel {
  int? id;
  final String? from_date;
  final String? to_date;
  final int working_hour;
  final List<ScheduleModel> schedules;
  int? roster;

  ShiftModel(
      {this.id,
      required this.from_date,
      required this.to_date,
      required this.working_hour,
      required this.schedules,
      this.roster});

  factory ShiftModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftModelToJson(this);
}
