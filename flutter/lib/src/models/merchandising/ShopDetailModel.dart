// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';
part 'ShopDetailModel.g.dart';

@JsonSerializable()
class ShopDetailModel {
  final int id;
  final String name;
  final String level;

  ShopDetailModel({required this.id, required this.name, required this.level});

  factory ShopDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ShopDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShopDetailModelToJson(this);
}
