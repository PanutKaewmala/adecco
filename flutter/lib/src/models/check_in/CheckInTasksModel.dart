// ignore_for_file: non_constant_identifier_names, file_names
import 'package:json_annotation/json_annotation.dart';

import 'TasksModel.dart';

part 'CheckInTasksModel.g.dart';

@JsonSerializable()
class CheckInTasksModel {
  final String type;
  final String name;
  final bool inside;
  final String daily_task_from;
  final List<TasksModel> tasks;

  CheckInTasksModel(
      {required this.type,
      required this.name,
      required this.inside,
      required this.daily_task_from,
      required this.tasks});

  factory CheckInTasksModel.fromJson(Map<String, dynamic> json) =>
      _$CheckInTasksModelFromJson(json);

  Map<String, dynamic> toJson() => _$CheckInTasksModelToJson(this);
}
