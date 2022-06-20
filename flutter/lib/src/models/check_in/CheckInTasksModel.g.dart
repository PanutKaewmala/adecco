// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CheckInTasksModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckInTasksModel _$CheckInTasksModelFromJson(Map<String, dynamic> json) =>
    CheckInTasksModel(
      type: json['type'] as String,
      name: json['name'] as String,
      inside: json['inside'] as bool,
      daily_task_from: json['daily_task_from'] as String,
      tasks: (json['tasks'] as List<dynamic>)
          .map((e) => TasksModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CheckInTasksModelToJson(CheckInTasksModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'name': instance.name,
      'inside': instance.inside,
      'daily_task_from': instance.daily_task_from,
      'tasks': instance.tasks,
    };
