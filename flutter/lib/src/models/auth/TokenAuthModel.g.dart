// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TokenAuthModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenAuthModel _$TokenAuthModelFromJson(Map<String, dynamic> json) =>
    TokenAuthModel(
      access: json['access'] as String,
      refresh: json['refresh'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TokenAuthModelToJson(TokenAuthModel instance) =>
    <String, dynamic>{
      'access': instance.access,
      'refresh': instance.refresh,
      'user': instance.user,
    };
