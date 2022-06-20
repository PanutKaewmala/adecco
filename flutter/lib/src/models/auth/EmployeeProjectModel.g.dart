// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'EmployeeProjectModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeProjectModel _$EmployeeProjectModelFromJson(
        Map<String, dynamic> json) =>
    EmployeeProjectModel(
      id: json['id'] as int,
      project: ProjectModel.fromJson(json['project'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EmployeeProjectModelToJson(
        EmployeeProjectModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'project': instance.project,
    };
