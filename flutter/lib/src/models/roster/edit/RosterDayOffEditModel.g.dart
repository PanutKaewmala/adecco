// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RosterDayOffEditModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RosterDayOffEditModel _$RosterDayOffEditModelFromJson(
        Map<String, dynamic> json) =>
    RosterDayOffEditModel(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as String?,
      start_date: json['start_date'] as String,
      end_date: json['end_date'] as String,
      remark: json['remark'] as String?,
      description: json['description'] as String?,
      day_off:
          DayOffEditModel.fromJson(json['day_off'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RosterDayOffEditModelToJson(
        RosterDayOffEditModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'start_date': instance.start_date,
      'end_date': instance.end_date,
      'remark': instance.remark,
      'description': instance.description,
      'day_off': instance.day_off,
    };
