// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserOverTimeModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserOverTimeModel _$UserOverTimeModelFromJson(Map<String, dynamic> json) =>
    UserOverTimeModel(
      id: json['id'] as int,
      full_name: json['full_name'] as String,
      email: json['email'] as String,
      photo: json['photo'] as String?,
      first_name: json['first_name'] as String,
      last_name: json['last_name'] as String,
      phone_number: json['phone_number'] as String?,
    );

Map<String, dynamic> _$UserOverTimeModelToJson(UserOverTimeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.full_name,
      'email': instance.email,
      'photo': instance.photo,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'phone_number': instance.phone_number,
    };
