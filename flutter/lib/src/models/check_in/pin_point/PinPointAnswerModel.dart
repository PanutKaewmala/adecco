// ignore_for_file: non_constant_identifier_names, file_names

import 'package:ahead_adecco/src/models/check_in/pin_point/PinPointAnswerQuestionModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'PinPointAnswerModel.g.dart';

@JsonSerializable()
class PinPointAnswerModel {
  final int activity, type;
  final List<PinPointAnswerQuestionModel> answers;

  PinPointAnswerModel(
      {required this.activity, required this.type, required this.answers});

  factory PinPointAnswerModel.fromJson(Map<String, dynamic> json) =>
      _$PinPointAnswerModelFromJson(json);

  Map<String, dynamic> toJson() => _$PinPointAnswerModelToJson(this);
}
