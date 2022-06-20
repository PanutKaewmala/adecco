// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CheckInHistoryModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckInHistoryModel _$CheckInHistoryModelFromJson(Map<String, dynamic> json) =>
    CheckInHistoryModel(
      date_time: json['date_time'] as String,
      check_in: json['check_in'] as String?,
      check_out: json['check_out'] as String?,
      status: json['status'] as String?,
      leave: json['leave'] == null
          ? null
          : LeaveModel.fromJson(json['leave'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CheckInHistoryModelToJson(
        CheckInHistoryModel instance) =>
    <String, dynamic>{
      'date_time': instance.date_time,
      'check_in': instance.check_in,
      'check_out': instance.check_out,
      'status': instance.status,
      'leave': instance.leave,
    };
