// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ShopModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopModel _$ShopModelFromJson(Map<String, dynamic> json) => ShopModel(
      id: json['id'] as int,
      shop: ShopDetailModel.fromJson(json['shop'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShopModelToJson(ShopModel instance) => <String, dynamic>{
      'id': instance.id,
      'shop': instance.shop,
    };
