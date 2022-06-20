// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';

part 'DropDownModel.g.dart';

@JsonSerializable()
class DropDownModel {
  final int value;
  final String label;

  DropDownModel({
    required this.value,
    required this.label,
  });

  factory DropDownModel.fromJson(Map<String, dynamic> json) =>
      _$DropDownModelFromJson(json);

  Map<String, dynamic> toJson() => _$DropDownModelToJson(this);
}
