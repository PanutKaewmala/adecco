// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RosterCalendarModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RosterCalendarModel _$RosterCalendarModelFromJson(Map<String, dynamic> json) =>
    RosterCalendarModel(
      month_name: json['month_name'] as String,
      calendars: (json['calendars'] as List<dynamic>)
          .map((e) => RosterDayModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RosterCalendarModelToJson(
        RosterCalendarModel instance) =>
    <String, dynamic>{
      'month_name': instance.month_name,
      'calendars': instance.calendars,
    };
