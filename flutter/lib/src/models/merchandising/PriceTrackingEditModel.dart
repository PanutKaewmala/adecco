// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';
part 'PriceTrackingEditModel.g.dart';

@JsonSerializable()
class PriceTrackingEditModel {
  final int id;
  final String date;
  final double normal_price;
  final String type;
  final String start_date;
  final String end_date;
  final double? promotion_price;
  final int? buy_free;
  final int? buy_free_percentage;
  final int? buy_off;
  final int? buy_off_percentage;
  final int? reason;
  final String? promotion_name;
  final String additional_note;
  final int merchandizer_product;

  PriceTrackingEditModel(
      {required this.id,
      required this.date,
      required this.normal_price,
      required this.type,
      required this.start_date,
      required this.end_date,
      required this.promotion_price,
      required this.promotion_name,
      required this.buy_free,
      required this.buy_free_percentage,
      required this.buy_off,
      required this.buy_off_percentage,
      required this.reason,
      required this.additional_note,
      required this.merchandizer_product});

  factory PriceTrackingEditModel.fromJson(Map<String, dynamic> json) =>
      _$PriceTrackingEditModelFromJson(json);

  Map<String, dynamic> toJson() => _$PriceTrackingEditModelToJson(this);
}
