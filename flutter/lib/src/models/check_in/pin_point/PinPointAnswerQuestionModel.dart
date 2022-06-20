// ignore_for_file: non_constant_identifier_names, file_names
import 'package:json_annotation/json_annotation.dart';

part 'PinPointAnswerQuestionModel.g.dart';

@JsonSerializable()
class PinPointAnswerQuestionModel {
  final int? pin_point;
  final int question;
  final String question_name, answer;

  PinPointAnswerQuestionModel(
      {required this.pin_point,
      required this.question,
      required this.question_name,
      required this.answer});

  factory PinPointAnswerQuestionModel.fromJson(Map<String, dynamic> json) =>
      _$PinPointAnswerQuestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$PinPointAnswerQuestionModelToJson(this);
}
