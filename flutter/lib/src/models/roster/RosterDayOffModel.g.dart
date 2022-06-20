// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RosterDayOffModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RosterDayOffModel _$RosterDayOffModelFromJson(Map<String, dynamic> json) =>
    RosterDayOffModel(
      working_hour: json['working_hour'] as int,
      detail_list: (json['detail_list'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    )..id = json['id'] as int?;

Map<String, dynamic> _$RosterDayOffModelToJson(RosterDayOffModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'working_hour': instance.working_hour,
      'detail_list': instance.detail_list,
    };
