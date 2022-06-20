// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LeaveRequestDetailModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaveRequestDetailModel _$LeaveRequestDetailModelFromJson(
        Map<String, dynamic> json) =>
    LeaveRequestDetailModel(
      id: json['id'] as int,
      start_date: json['start_date'] as String,
      end_date: json['end_date'] as String,
      start_time: json['start_time'] as String?,
      end_time: json['end_time'] as String?,
      upload_attachments: (json['upload_attachments'] as List<dynamic>)
          .map((e) => UploadAttachmentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      type: json['type'] as String,
      all_day: json['all_day'] as bool,
      status: json['status'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$LeaveRequestDetailModelToJson(
        LeaveRequestDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'start_date': instance.start_date,
      'end_date': instance.end_date,
      'start_time': instance.start_time,
      'end_time': instance.end_time,
      'upload_attachments': instance.upload_attachments,
      'type': instance.type,
      'all_day': instance.all_day,
      'status': instance.status,
      'title': instance.title,
      'description': instance.description,
    };
