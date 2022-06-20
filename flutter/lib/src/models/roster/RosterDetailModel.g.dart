// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RosterDetailModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RosterDetailModel _$RosterDetailModelFromJson(Map<String, dynamic> json) =>
    RosterDetailModel(
      id: json['id'] as int?,
      name: json['name'] as String,
      status: json['status'] as String?,
      start_date: json['start_date'] as String,
      end_date: json['end_date'] as String,
      shifts: (json['shifts'] as List<dynamic>)
          .map((e) => ShiftDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      calendar: json['calendar'] == null
          ? null
          : RosterCalendarModel.fromJson(
              json['calendar'] as Map<String, dynamic>),
      holiday_list: (json['holiday_list'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      day_off:
          (json['day_off'] as List<dynamic>?)?.map((e) => e as String).toList(),
      remark: json['remark'] as String?,
      description: json['description'] as String?,
      working_hours: (json['working_hours'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      roster_setting: json['roster_setting'] as bool?,
    );

Map<String, dynamic> _$RosterDetailModelToJson(RosterDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'start_date': instance.start_date,
      'end_date': instance.end_date,
      'shifts': instance.shifts,
      'calendar': instance.calendar,
      'holiday_list': instance.holiday_list,
      'day_off': instance.day_off,
      'remark': instance.remark,
      'description': instance.description,
      'working_hours': instance.working_hours,
      'roster_setting': instance.roster_setting,
    };
