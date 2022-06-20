// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';
import '../export_models.dart';

part 'LeaveNameModel.g.dart';

@JsonSerializable()
class LeaveNameModel {
  final List<LeaveTypeDetailModel> leave_name;

  LeaveNameModel({
    required this.leave_name,
  });

  factory LeaveNameModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveNameModelFromJson(json);

  Map<String, dynamic> toJson() => _$LeaveNameModelToJson(this);
}
