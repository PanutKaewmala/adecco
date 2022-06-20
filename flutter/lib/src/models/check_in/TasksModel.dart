// ignore_for_file: non_constant_identifier_names, file_names
import 'package:json_annotation/json_annotation.dart';

part 'TasksModel.g.dart';

@JsonSerializable()
class TasksModel {
  final String type;
  final String name;
  final String? extra_type;
  final String? date_time;

  TasksModel(
      {required this.type,
      required this.name,
      required this.extra_type,
      required this.date_time});

  factory TasksModel.fromJson(Map<String, dynamic> json) =>
      _$TasksModelFromJson(json);

  Map<String, dynamic> toJson() => _$TasksModelToJson(this);
}
