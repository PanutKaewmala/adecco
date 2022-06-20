// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TasksModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TasksModel _$TasksModelFromJson(Map<String, dynamic> json) => TasksModel(
      type: json['type'] as String,
      name: json['name'] as String,
      extra_type: json['extra_type'] as String?,
      date_time: json['date_time'] as String?,
    );

Map<String, dynamic> _$TasksModelToJson(TasksModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'name': instance.name,
      'extra_type': instance.extra_type,
      'date_time': instance.date_time,
    };
