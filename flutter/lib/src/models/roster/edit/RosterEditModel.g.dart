// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RosterEditModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RosterEditModel _$RosterEditModelFromJson(Map<String, dynamic> json) =>
    RosterEditModel(
      id: json['id'] as int?,
      name: json['name'] as String,
      status: json['status'] as String?,
      start_date: json['start_date'] as String,
      end_date: json['end_date'] as String,
      remark: json['remark'] as String?,
      description: json['description'] as String?,
      working_hours: (json['working_hours'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      shifts: (json['shifts'] as List<dynamic>)
          .map((e) => ShiftEditModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RosterEditModelToJson(RosterEditModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'start_date': instance.start_date,
      'end_date': instance.end_date,
      'remark': instance.remark,
      'description': instance.description,
      'working_hours': instance.working_hours,
      'shifts': instance.shifts,
    };
