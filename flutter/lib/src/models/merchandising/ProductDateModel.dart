// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';
part 'ProductDateModel.g.dart';

@JsonSerializable()
class ProductDateModel {
  final int id;
  final String date;
  final String type;
  final double normal_price;
  final double promotion_price;

  ProductDateModel(
      {required this.id,
      required this.date,
      required this.type,
      required this.normal_price,
      required this.promotion_price});

  factory ProductDateModel.fromJson(Map<String, dynamic> json) =>
      _$ProductDateModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDateModelToJson(this);
}
