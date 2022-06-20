// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';

part 'ProjectModel.g.dart';

@JsonSerializable()
class ProjectModel {
  final int id;
  final String name, description, start_date, end_date;

  ProjectModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.start_date,
      required this.end_date});

  factory ProjectModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectModelToJson(this);
}
