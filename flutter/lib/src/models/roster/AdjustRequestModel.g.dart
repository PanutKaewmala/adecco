// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AdjustRequestModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdjustRequestModel _$AdjustRequestModelFromJson(Map<String, dynamic> json) =>
    AdjustRequestModel(
      id: json['id'] as int,
      employee_name: json['employee_name'] as String,
      employee_project: json['employee_project'] as int,
      working_hour: json['working_hour'] as String,
      date: json['date'] as String,
      day_name: json['day_name'] as String,
      type: json['type'] as String,
      remark: json['remark'] as String?,
      workplaces: (json['workplaces'] as List<dynamic>)
          .map((e) => PlaceRosterModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AdjustRequestModelToJson(AdjustRequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employee_project': instance.employee_project,
      'employee_name': instance.employee_name,
      'working_hour': instance.working_hour,
      'date': instance.date,
      'day_name': instance.day_name,
      'type': instance.type,
      'remark': instance.remark,
      'workplaces': instance.workplaces,
    };
