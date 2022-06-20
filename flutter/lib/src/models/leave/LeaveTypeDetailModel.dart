// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';

part 'LeaveTypeDetailModel.g.dart';

@JsonSerializable()
class LeaveTypeDetailModel {
  final int value;
  final String label;

  LeaveTypeDetailModel({
    required this.value,
    required this.label,
  });

  factory LeaveTypeDetailModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveTypeDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$LeaveTypeDetailModelToJson(this);
}
