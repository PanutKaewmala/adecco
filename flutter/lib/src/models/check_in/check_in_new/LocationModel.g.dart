// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LocationModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationModel _$LocationModelFromJson(Map<String, dynamic> json) =>
    LocationModel(
      workplace:
          WorkPlaceModel.fromJson(json['workplace'] as Map<String, dynamic>),
      project: json['project'] as int,
      date: json['date'] as String,
      working_hour: json['working_hour'] == null
          ? null
          : WorkingHoursLocation.fromJson(
              json['working_hour'] as Map<String, dynamic>),
      from_roster: json['from_roster'] as bool,
      activity:
          ActivityModel.fromJson(json['activity'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LocationModelToJson(LocationModel instance) =>
    <String, dynamic>{
      'workplace': instance.workplace,
      'project': instance.project,
      'date': instance.date,
      'working_hour': instance.working_hour,
      'from_roster': instance.from_roster,
      'activity': instance.activity,
    };
