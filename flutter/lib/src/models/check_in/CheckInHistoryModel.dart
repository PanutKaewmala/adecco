// ignore_for_file: non_constant_identifier_names, file_names

import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:json_annotation/json_annotation.dart';
part 'CheckInHistoryModel.g.dart';

@JsonSerializable()
class CheckInHistoryModel {
  final String date_time;
  final String? check_in;
  final String? check_out;
  final String? status;
  final LeaveModel? leave;

  CheckInHistoryModel(
      {required this.date_time,
      required this.check_in,
      required this.check_out,
      required this.status,
      required this.leave});

  factory CheckInHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$CheckInHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CheckInHistoryModelToJson(this);
}
