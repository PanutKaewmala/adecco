// ignore_for_file: non_constant_identifier_names, file_names
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:json_annotation/json_annotation.dart';
part 'AdjustRequestModel.g.dart';

@JsonSerializable()
class AdjustRequestModel {
  final int id, employee_project;
  final String employee_name, working_hour, date, day_name, type;
  final String? remark;
  final List<PlaceRosterModel> workplaces;

  AdjustRequestModel(
      {required this.id,
      required this.employee_name,
      required this.employee_project,
      required this.working_hour,
      required this.date,
      required this.day_name,
      required this.type,
      required this.remark,
      required this.workplaces});

  factory AdjustRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AdjustRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$AdjustRequestModelToJson(this);
}
