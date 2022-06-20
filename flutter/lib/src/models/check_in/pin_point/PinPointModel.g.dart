// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PinPointModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PinPointModel _$PinPointModelFromJson(Map<String, dynamic> json) =>
    PinPointModel(
      id: json['id'] as int,
      questions: (json['questions'] as List<dynamic>)
          .map((e) => PinPointQuestionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String,
      detail: json['detail'] as String?,
      project: json['project'] as int,
      employee_projects: (json['employee_projects'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
    );

Map<String, dynamic> _$PinPointModelToJson(PinPointModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'questions': instance.questions,
      'name': instance.name,
      'detail': instance.detail,
      'project': instance.project,
      'employee_projects': instance.employee_projects,
    };
