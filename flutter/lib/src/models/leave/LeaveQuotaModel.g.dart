// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LeaveQuotaModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaveQuotaModel _$LeaveQuotaModelFromJson(Map<String, dynamic> json) =>
    LeaveQuotaModel(
      id: json['id'] as int,
      type: json['type'] as String,
      total: (json['total'] as num).toDouble(),
      used: (json['used'] as num).toDouble(),
      remained: (json['remained'] as num).toDouble(),
    );

Map<String, dynamic> _$LeaveQuotaModelToJson(LeaveQuotaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'total': instance.total,
      'used': instance.used,
      'remained': instance.remained,
    };
