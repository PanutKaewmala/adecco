// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ActivityModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityModel _$ActivityModelFromJson(Map<String, dynamic> json) =>
    ActivityModel(
      check_in: json['check_in'] as String?,
      check_out: json['check_out'] as String?,
      pair_id: json['pair_id'] as int?,
    );

Map<String, dynamic> _$ActivityModelToJson(ActivityModel instance) =>
    <String, dynamic>{
      'check_in': instance.check_in,
      'check_out': instance.check_out,
      'pair_id': instance.pair_id,
    };
