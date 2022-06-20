// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';

part 'OverTimeQuotaModel.g.dart';

@JsonSerializable()
class OverTimeQuotaModel {
  final double ot_quota_used;
  final double ot_quota;

  OverTimeQuotaModel({required this.ot_quota_used, required this.ot_quota});

  factory OverTimeQuotaModel.fromJson(Map<String, dynamic> json) =>
      _$OverTimeQuotaModelFromJson(json);

  Map<String, dynamic> toJson() => _$OverTimeQuotaModelToJson(this);
}
