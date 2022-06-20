// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ShiftDetailModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftDetailModel _$ShiftDetailModelFromJson(Map<String, dynamic> json) =>
    ShiftDetailModel(
      id: json['id'] as int?,
      from_date: json['from_date'] as String,
      to_date: json['to_date'] as String,
      working_hour: json['working_hour'] as String,
      status: json['status'] as String?,
      sunday:
          (json['sunday'] as List<dynamic>?)?.map((e) => e as String).toList(),
      monday:
          (json['monday'] as List<dynamic>?)?.map((e) => e as String).toList(),
      tuesday:
          (json['tuesday'] as List<dynamic>?)?.map((e) => e as String).toList(),
      wednesday: (json['wednesday'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      thursday: (json['thursday'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      friday:
          (json['friday'] as List<dynamic>?)?.map((e) => e as String).toList(),
      saturday: (json['saturday'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ShiftDetailModelToJson(ShiftDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'from_date': instance.from_date,
      'to_date': instance.to_date,
      'working_hour': instance.working_hour,
      'status': instance.status,
      'sunday': instance.sunday,
      'monday': instance.monday,
      'tuesday': instance.tuesday,
      'wednesday': instance.wednesday,
      'thursday': instance.thursday,
      'friday': instance.friday,
      'saturday': instance.saturday,
    };
