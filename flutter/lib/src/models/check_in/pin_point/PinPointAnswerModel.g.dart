// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PinPointAnswerModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PinPointAnswerModel _$PinPointAnswerModelFromJson(Map<String, dynamic> json) =>
    PinPointAnswerModel(
      activity: json['activity'] as int,
      type: json['type'] as int,
      answers: (json['answers'] as List<dynamic>)
          .map((e) =>
              PinPointAnswerQuestionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PinPointAnswerModelToJson(
        PinPointAnswerModel instance) =>
    <String, dynamic>{
      'activity': instance.activity,
      'type': instance.type,
      'answers': instance.answers,
    };
