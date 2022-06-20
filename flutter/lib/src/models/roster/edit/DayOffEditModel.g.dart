// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DayOffEditModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DayOffEditModel _$DayOffEditModelFromJson(Map<String, dynamic> json) =>
    DayOffEditModel(
      id: json['id'] as int,
      status: json['status'] as String,
      working_hour: json['working_hour'] as int,
      detail_list: (json['detail_list'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$DayOffEditModelToJson(DayOffEditModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'working_hour': instance.working_hour,
      'detail_list': instance.detail_list,
    };
