// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CheckInTimeModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckInTimeModel _$CheckInTimeModelFromJson(Map<String, dynamic> json) =>
    CheckInTimeModel(
      before: json['before'] as String,
      time: json['time'] as String,
      after: json['after'] as String,
    );

Map<String, dynamic> _$CheckInTimeModelToJson(CheckInTimeModel instance) =>
    <String, dynamic>{
      'before': instance.before,
      'time': instance.time,
      'after': instance.after,
    };
