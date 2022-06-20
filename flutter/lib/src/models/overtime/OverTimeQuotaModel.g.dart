// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OverTimeQuotaModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OverTimeQuotaModel _$OverTimeQuotaModelFromJson(Map<String, dynamic> json) =>
    OverTimeQuotaModel(
      ot_quota_used: (json['ot_quota_used'] as num).toDouble(),
      ot_quota: (json['ot_quota'] as num).toDouble(),
    );

Map<String, dynamic> _$OverTimeQuotaModelToJson(OverTimeQuotaModel instance) =>
    <String, dynamic>{
      'ot_quota_used': instance.ot_quota_used,
      'ot_quota': instance.ot_quota,
    };
