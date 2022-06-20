// ignore_for_file: non_constant_identifier_names, file_names
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ShiftDetailEditModel.g.dart';

@JsonSerializable()
class ShiftDetailEditModel {
  final int? id;
  final String? from_date;
  final String? to_date;
  final String? remark;
  final int working_hour;
  final List<ShiftScheduleEditModel> schedules;
  final int roster;

  ShiftDetailEditModel(
      {required this.id,
      required this.from_date,
      required this.to_date,
      required this.remark,
      required this.working_hour,
      required this.schedules,
      required this.roster});

  factory ShiftDetailEditModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftDetailEditModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftDetailEditModelToJson(this);
}
