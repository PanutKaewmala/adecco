// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';
part 'DetailModel.g.dart';

@JsonSerializable()
class DetailModel {
  final String detail;

  DetailModel({required this.detail});

  factory DetailModel.fromJson(Map<String, dynamic> json) =>
      _$DetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$DetailModelToJson(this);
}
