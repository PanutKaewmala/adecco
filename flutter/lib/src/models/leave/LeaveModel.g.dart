// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LeaveModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaveModel _$LeaveModelFromJson(Map<String, dynamic> json) => LeaveModel(
      start_date: json['start_date'] as String,
      end_date: json['end_date'] as String,
      start_time: json['start_time'] as String?,
      end_time: json['end_time'] as String?,
      all_day: json['all_day'] as bool,
    );

Map<String, dynamic> _$LeaveModelToJson(LeaveModel instance) =>
    <String, dynamic>{
      'start_date': instance.start_date,
      'end_date': instance.end_date,
      'start_time': instance.start_time,
      'end_time': instance.end_time,
      'all_day': instance.all_day,
    };
