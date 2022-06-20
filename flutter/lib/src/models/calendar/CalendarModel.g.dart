// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CalendarModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalendarModel _$CalendarModelFromJson(Map<String, dynamic> json) =>
    CalendarModel(
      month_name: json['month_name'] as String,
      calendars: (json['calendars'] as List<dynamic>)
          .map((e) => CalendarDateModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CalendarModelToJson(CalendarModel instance) =>
    <String, dynamic>{
      'month_name': instance.month_name,
      'calendars': instance.calendars,
    };
