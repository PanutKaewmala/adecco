// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WorkingHoursLocation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkingHoursLocation _$WorkingHoursLocationFromJson(
        Map<String, dynamic> json) =>
    WorkingHoursLocation(
      id: json['id'] as int?,
      start_time: json['start_time'] == null
          ? null
          : CheckInTimeModel.fromJson(
              json['start_time'] as Map<String, dynamic>),
      end_time: json['end_time'] == null
          ? null
          : CheckInTimeModel.fromJson(json['end_time'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WorkingHoursLocationToJson(
        WorkingHoursLocation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'start_time': instance.start_time,
      'end_time': instance.end_time,
    };
