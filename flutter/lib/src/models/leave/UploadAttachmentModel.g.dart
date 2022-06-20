// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UploadAttachmentModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadAttachmentModel _$UploadAttachmentModelFromJson(
        Map<String, dynamic> json) =>
    UploadAttachmentModel(
      id: json['id'] as int,
      name: json['name'] as String,
      file: json['file'] as String,
    );

Map<String, dynamic> _$UploadAttachmentModelToJson(
        UploadAttachmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'file': instance.file,
    };
