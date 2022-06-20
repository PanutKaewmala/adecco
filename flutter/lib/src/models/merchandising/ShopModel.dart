// ignore_for_file: non_constant_identifier_names, file_names

import 'package:ahead_adecco/src/models/merchandising/ShopDetailModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'ShopModel.g.dart';

@JsonSerializable()
class ShopModel {
  final int id;
  final ShopDetailModel shop;

  ShopModel({required this.id, required this.shop});

  factory ShopModel.fromJson(Map<String, dynamic> json) =>
      _$ShopModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShopModelToJson(this);
}
