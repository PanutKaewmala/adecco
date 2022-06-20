// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RosterModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RosterModel _$RosterModelFromJson(Map<String, dynamic> json) => RosterModel(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as String,
      start_date: json['start_date'] as String,
      end_date: json['end_date'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$RosterModelToJson(RosterModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'start_date': instance.start_date,
      'end_date': instance.end_date,
      'type': instance.type,
    };
