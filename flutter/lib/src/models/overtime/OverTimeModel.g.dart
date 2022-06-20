// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OverTimeModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OverTimeModel _$OverTimeModelFromJson(Map<String, dynamic> json) =>
    OverTimeModel(
      id: json['id'] as int,
      user: UserOverTimeModel.fromJson(json['user'] as Map<String, dynamic>),
      workplace:
          WorkPlaceModel.fromJson(json['workplace'] as Map<String, dynamic>),
      created_at: json['created_at'] as String,
      start_date: json['start_date'] as String,
      ot_total: json['ot_total'] as String,
      status: json['status'] as String,
      title: json['title'] as String?,
    );

Map<String, dynamic> _$OverTimeModelToJson(OverTimeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'workplace': instance.workplace,
      'created_at': instance.created_at,
      'start_date': instance.start_date,
      'ot_total': instance.ot_total,
      'status': instance.status,
      'title': instance.title,
    };
