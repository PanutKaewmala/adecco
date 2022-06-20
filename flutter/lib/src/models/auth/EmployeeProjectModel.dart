// ignore_for_file: non_constant_identifier_names, file_names

import 'package:ahead_adecco/src/models/auth/ProjectModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'EmployeeProjectModel.g.dart';

@JsonSerializable()
class EmployeeProjectModel {
  final int id;
  final ProjectModel project;

  EmployeeProjectModel({required this.id, required this.project});

  factory EmployeeProjectModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeProjectModelFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeProjectModelToJson(this);
}
