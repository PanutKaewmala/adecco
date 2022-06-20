// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PinPointAnswerQuestionModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PinPointAnswerQuestionModel _$PinPointAnswerQuestionModelFromJson(
        Map<String, dynamic> json) =>
    PinPointAnswerQuestionModel(
      pin_point: json['pin_point'] as int?,
      question: json['question'] as int,
      question_name: json['question_name'] as String,
      answer: json['answer'] as String,
    );

Map<String, dynamic> _$PinPointAnswerQuestionModelToJson(
        PinPointAnswerQuestionModel instance) =>
    <String, dynamic>{
      'pin_point': instance.pin_point,
      'question': instance.question,
      'question_name': instance.question_name,
      'answer': instance.answer,
    };
