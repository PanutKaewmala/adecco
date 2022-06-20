// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CalendarDateModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalendarDateModel _$CalendarDateModelFromJson(Map<String, dynamic> json) =>
    CalendarDateModel(
      date: json['date'] as String,
      type: (json['type'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$CalendarDateModelToJson(CalendarDateModel instance) =>
    <String, dynamic>{
      'date': instance.date,
      'type': instance.type,
    };
