// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';

part 'ActivityModel.g.dart';

@JsonSerializable()
class ActivityModel {
  final String? check_in;
  final String? check_out;
  final int? pair_id;

  ActivityModel(
      {required this.check_in, required this.check_out, required this.pair_id});

  factory ActivityModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityModelToJson(this);
}
