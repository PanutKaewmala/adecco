// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProductDateModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductDateModel _$ProductDateModelFromJson(Map<String, dynamic> json) =>
    ProductDateModel(
      id: json['id'] as int,
      date: json['date'] as String,
      type: json['type'] as String,
      normal_price: (json['normal_price'] as num).toDouble(),
      promotion_price: (json['promotion_price'] as num).toDouble(),
    );

Map<String, dynamic> _$ProductDateModelToJson(ProductDateModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'type': instance.type,
      'normal_price': instance.normal_price,
      'promotion_price': instance.promotion_price,
    };
