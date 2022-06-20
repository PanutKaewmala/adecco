// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';

part 'PinPointQuestionModel.g.dart';

@JsonSerializable()
class PinPointQuestionModel {
  final int id;
  final String name;
  final bool require, hide, template;

  PinPointQuestionModel(
      {required this.id,
      required this.name,
      required this.hide,
      required this.require,
      required this.template});

  factory PinPointQuestionModel.fromJson(Map<String, dynamic> json) =>
      _$PinPointQuestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$PinPointQuestionModelToJson(this);
}
