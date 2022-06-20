// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';

part 'UploadAttachmentModel.g.dart';

@JsonSerializable()
class UploadAttachmentModel {
  final int id;
  final String name;
  final String file;

  UploadAttachmentModel({
    required this.id,
    required this.name,
    required this.file,
  });

  factory UploadAttachmentModel.fromJson(Map<String, dynamic> json) =>
      _$UploadAttachmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$UploadAttachmentModelToJson(this);
}
