// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';
part 'LeaveModel.g.dart';

@JsonSerializable()
class LeaveModel {
  final String start_date;
  final String end_date;
  final String? start_time;
  final String? end_time;
  final bool all_day;

  LeaveModel(
      {required this.start_date,
      required this.end_date,
      required this.start_time,
      required this.end_time,
      required this.all_day});

  factory LeaveModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveModelFromJson(json);

  Map<String, dynamic> toJson() => _$LeaveModelToJson(this);
}
