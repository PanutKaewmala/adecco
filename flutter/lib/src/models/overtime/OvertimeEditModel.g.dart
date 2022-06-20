// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OvertimeEditModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OvertimeEditModel _$OvertimeEditModelFromJson(Map<String, dynamic> json) =>
    OvertimeEditModel(
      id: json['id'] as int,
      workplace:
          WorkPlaceModel.fromJson(json['workplace'] as Map<String, dynamic>),
      start_date: json['start_date'] as String,
      end_date: json['end_date'] as String,
      start_time: json['start_time'] as String,
      end_time: json['end_time'] as String,
      title: json['title'] as String?,
      description: json['description'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$OvertimeEditModelToJson(OvertimeEditModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workplace': instance.workplace,
      'start_date': instance.start_date,
      'end_date': instance.end_date,
      'start_time': instance.start_time,
      'end_time': instance.end_time,
      'title': instance.title,
      'description': instance.description,
      'status': instance.status,
    };
