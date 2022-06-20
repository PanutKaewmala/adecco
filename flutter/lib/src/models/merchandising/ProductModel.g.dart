// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProductModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      id: json['id'] as int,
      name: json['name'] as String,
      setting_level: json['setting_level'] as String,
      setting_name: json['setting_name'] as String,
      merchandizer_product: json['merchandizer_product'] as int,
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'setting_level': instance.setting_level,
      'setting_name': instance.setting_name,
      'merchandizer_product': instance.merchandizer_product,
    };
