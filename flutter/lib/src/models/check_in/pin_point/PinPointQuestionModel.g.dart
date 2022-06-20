// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PinPointQuestionModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PinPointQuestionModel _$PinPointQuestionModelFromJson(
        Map<String, dynamic> json) =>
    PinPointQuestionModel(
      id: json['id'] as int,
      name: json['name'] as String,
      hide: json['hide'] as bool,
      require: json['require'] as bool,
      template: json['template'] as bool,
    );

Map<String, dynamic> _$PinPointQuestionModelToJson(
        PinPointQuestionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'require': instance.require,
      'hide': instance.hide,
      'template': instance.template,
    };
