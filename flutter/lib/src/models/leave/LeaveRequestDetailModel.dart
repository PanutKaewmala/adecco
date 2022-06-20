// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';

import '../export_models.dart';
part 'LeaveRequestDetailModel.g.dart';

@JsonSerializable()
class LeaveRequestDetailModel {
  final int id;
  final String start_date;
  final String end_date;
  final String? start_time;
  final String? end_time;
  final List<UploadAttachmentModel> upload_attachments;
  final String type;
  final bool all_day;
  final String status;
  final String title;
  final String description;

  LeaveRequestDetailModel(
      {required this.id,
      required this.start_date,
      required this.end_date,
      required this.start_time,
      required this.end_time,
      required this.upload_attachments,
      required this.type,
      required this.all_day,
      required this.status,
      required this.title,
      required this.description});

  factory LeaveRequestDetailModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveRequestDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$LeaveRequestDetailModelToJson(this);
}
