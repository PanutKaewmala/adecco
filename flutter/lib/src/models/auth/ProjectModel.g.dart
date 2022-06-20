// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProjectModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectModel _$ProjectModelFromJson(Map<String, dynamic> json) => ProjectModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      start_date: json['start_date'] as String,
      end_date: json['end_date'] as String,
    );

Map<String, dynamic> _$ProjectModelToJson(ProjectModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'start_date': instance.start_date,
      'end_date': instance.end_date,
    };
