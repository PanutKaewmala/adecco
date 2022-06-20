// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ScheduleEditModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleEditModel _$ScheduleEditModelFromJson(Map<String, dynamic> json) =>
    ScheduleEditModel(
      sunday: json['sunday'] as String?,
      monday: json['monday'] as String?,
      tuesday: json['tuesday'] as String?,
      wednesday: json['wednesday'] as String?,
      thursday: json['thursday'] as String?,
      friday: json['friday'] as String?,
      saturday: json['saturday'] as String?,
      workplaces: (json['workplaces'] as List<dynamic>)
          .map((e) => PlaceRosterModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..id = json['id'] as int?
      ..shift = json['shift'] as int?;

Map<String, dynamic> _$ScheduleEditModelToJson(ScheduleEditModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sunday': instance.sunday,
      'monday': instance.monday,
      'tuesday': instance.tuesday,
      'wednesday': instance.wednesday,
      'thursday': instance.thursday,
      'friday': instance.friday,
      'saturday': instance.saturday,
      'workplaces': instance.workplaces,
      'shift': instance.shift,
    };
