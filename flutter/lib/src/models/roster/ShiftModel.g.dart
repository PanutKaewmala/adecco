// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ShiftModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftModel _$ShiftModelFromJson(Map<String, dynamic> json) => ShiftModel(
      id: json['id'] as int?,
      from_date: json['from_date'] as String?,
      to_date: json['to_date'] as String?,
      working_hour: json['working_hour'] as int,
      schedules: (json['schedules'] as List<dynamic>)
          .map((e) => ScheduleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      roster: json['roster'] as int?,
    );

Map<String, dynamic> _$ShiftModelToJson(ShiftModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'from_date': instance.from_date,
      'to_date': instance.to_date,
      'working_hour': instance.working_hour,
      'schedules': instance.schedules,
      'roster': instance.roster,
    };
