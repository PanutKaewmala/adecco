// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PlaceModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceModel _$PlaceModelFromJson(Map<String, dynamic> json) => PlaceModel(
      id: json['id'] as int,
      place_name: json['place_name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$PlaceModelToJson(PlaceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'place_name': instance.place_name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
