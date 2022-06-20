// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';

part 'LeaveRequestModel.g.dart';

@JsonSerializable()
class LeaveRequestModel {
  final int id;
  final int leave_request_id;
  final String date;
  final String? start_time;
  final String? end_time;
  final String? type;
  final bool all_day;
  final String status;

  LeaveRequestModel({
    required this.id,
    required this.leave_request_id,
    required this.date,
    required this.start_time,
    required this.end_time,
    required this.type,
    required this.all_day,
    required this.status,
  });

  factory LeaveRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$LeaveRequestModelToJson(this);
}
