// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ShiftEditModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftEditModel _$ShiftEditModelFromJson(Map<String, dynamic> json) =>
    ShiftEditModel(
      id: json['id'] as int?,
      from_date: json['from_date'] as String?,
      to_date: json['to_date'] as String?,
      working_hour: json['working_hour'] as String,
      schedules: (json['schedules'] as List<dynamic>)
          .map((e) => ScheduleEditModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      roster: json['roster'] as int,
    );

Map<String, dynamic> _$ShiftEditModelToJson(ShiftEditModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'from_date': instance.from_date,
      'to_date': instance.to_date,
      'working_hour': instance.working_hour,
      'schedules': instance.schedules,
      'roster': instance.roster,
    };
