// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';
part 'FindProductModel.g.dart';

@JsonSerializable()
class FindProductModel {
  final int id;
  final String name;
  final String level_name;

  FindProductModel(
      {required this.id, required this.name, required this.level_name});

  factory FindProductModel.fromJson(Map<String, dynamic> json) =>
      _$FindProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$FindProductModelToJson(this);
}
