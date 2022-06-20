// ignore_for_file: non_constant_identifier_names, file_names

import 'package:ahead_adecco/src/models/check_in/pin_point/PinPointQuestionModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'PinPointModel.g.dart';

@JsonSerializable()
class PinPointModel {
  final int id;
  final List<PinPointQuestionModel> questions;
  final String name;
  final String? detail;
  final int project;
  final List<int> employee_projects;

  PinPointModel(
      {required this.id,
      required this.questions,
      required this.name,
      required this.detail,
      required this.project,
      required this.employee_projects});

  factory PinPointModel.fromJson(Map<String, dynamic> json) =>
      _$PinPointModelFromJson(json);

  Map<String, dynamic> toJson() => _$PinPointModelToJson(this);
}
