// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PriceTrackingEditModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PriceTrackingEditModel _$PriceTrackingEditModelFromJson(
        Map<String, dynamic> json) =>
    PriceTrackingEditModel(
      id: json['id'] as int,
      date: json['date'] as String,
      normal_price: (json['normal_price'] as num).toDouble(),
      type: json['type'] as String,
      start_date: json['start_date'] as String,
      end_date: json['end_date'] as String,
      promotion_price: (json['promotion_price'] as num?)?.toDouble(),
      promotion_name: json['promotion_name'] as String?,
      buy_free: json['buy_free'] as int?,
      buy_free_percentage: json['buy_free_percentage'] as int?,
      buy_off: json['buy_off'] as int?,
      buy_off_percentage: json['buy_off_percentage'] as int?,
      reason: json['reason'] as int?,
      additional_note: json['additional_note'] as String,
      merchandizer_product: json['merchandizer_product'] as int,
    );

Map<String, dynamic> _$PriceTrackingEditModelToJson(
        PriceTrackingEditModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'normal_price': instance.normal_price,
      'type': instance.type,
      'start_date': instance.start_date,
      'end_date': instance.end_date,
      'promotion_price': instance.promotion_price,
      'buy_free': instance.buy_free,
      'buy_free_percentage': instance.buy_free_percentage,
      'buy_off': instance.buy_off,
      'buy_off_percentage': instance.buy_off_percentage,
      'reason': instance.reason,
      'promotion_name': instance.promotion_name,
      'additional_note': instance.additional_note,
      'merchandizer_product': instance.merchandizer_product,
    };
