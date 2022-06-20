// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LeaveRequestModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaveRequestModel _$LeaveRequestModelFromJson(Map<String, dynamic> json) =>
    LeaveRequestModel(
      id: json['id'] as int,
      leave_request_id: json['leave_request_id'] as int,
      date: json['date'] as String,
      start_time: json['start_time'] as String?,
      end_time: json['end_time'] as String?,
      type: json['type'] as String?,
      all_day: json['all_day'] as bool,
      status: json['status'] as String,
    );

Map<String, dynamic> _$LeaveRequestModelToJson(LeaveRequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'leave_request_id': instance.leave_request_id,
      'date': instance.date,
      'start_time': instance.start_time,
      'end_time': instance.end_time,
      'type': instance.type,
      'all_day': instance.all_day,
      'status': instance.status,
    };
