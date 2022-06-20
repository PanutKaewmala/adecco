// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';

part 'LeaveQuotaModel.g.dart';

@JsonSerializable()
class LeaveQuotaModel {
  final int id;
  final String type;
  final double total;
  final double used;
  final double remained;

  LeaveQuotaModel(
      {required this.id,
      required this.type,
      required this.total,
      required this.used,
      required this.remained});

  factory LeaveQuotaModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveQuotaModelFromJson(json);

  Map<String, dynamic> toJson() => _$LeaveQuotaModelToJson(this);
}
