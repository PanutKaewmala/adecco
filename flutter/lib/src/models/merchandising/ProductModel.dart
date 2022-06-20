// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';
part 'ProductModel.g.dart';

@JsonSerializable()
class ProductModel {
  final int id;
  final String name;
  final String setting_level;
  final String setting_name;
  final int merchandizer_product;

  ProductModel(
      {required this.id,
      required this.name,
      required this.setting_level,
      required this.setting_name,
      required this.merchandizer_product});

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
