// ignore_for_file: non_constant_identifier_names, file_names

import 'package:ahead_adecco/src/models/check_in/check_in_new/WorkPlaceModel.dart';
import 'package:ahead_adecco/src/models/overtime/UserOverTimeModel.dart';

import 'package:json_annotation/json_annotation.dart';

part 'OverTimeModel.g.dart';

@JsonSerializable()
class OverTimeModel {
  final int id;
  final UserOverTimeModel user;
  final WorkPlaceModel workplace;
  final String created_at;
  final String start_date;
  final String ot_total;
  final String status;
  final String? title;

  OverTimeModel(
      {required this.id,
      required this.user,
      required this.workplace,
      required this.created_at,
      required this.start_date,
      required this.ot_total,
      required this.status,
      required this.title});

  factory OverTimeModel.fromJson(Map<String, dynamic> json) =>
      _$OverTimeModelFromJson(json);

  Map<String, dynamic> toJson() => _$OverTimeModelToJson(this);
}
