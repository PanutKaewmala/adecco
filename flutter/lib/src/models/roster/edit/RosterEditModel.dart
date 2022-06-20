// ignore_for_file: non_constant_identifier_names, file_names
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/models/roster/edit/ShiftEditModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'RosterEditModel.g.dart';

@JsonSerializable()
class RosterEditModel {
  final int? id;
  final String name;
  final String? status;
  final String start_date;
  final String end_date;
  final String? remark;
  final String? description;
  final List<String> working_hours;
  final List<ShiftEditModel> shifts;

  RosterEditModel(
      {required this.id,
      required this.name,
      required this.status,
      required this.start_date,
      required this.end_date,
      required this.remark,
      required this.description,
      required this.working_hours,
      required this.shifts});

  factory RosterEditModel.fromJson(Map<String, dynamic> json) =>
      _$RosterEditModelFromJson(json);

  Map<String, dynamic> toJson() => _$RosterEditModelToJson(this);
}
