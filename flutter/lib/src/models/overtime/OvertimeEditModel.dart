// ignore_for_file: non_constant_identifier_names, file_names

import 'package:ahead_adecco/src/models/check_in/check_in_new/WorkPlaceModel.dart';

import 'package:json_annotation/json_annotation.dart';

part 'OvertimeEditModel.g.dart';

@JsonSerializable()
class OvertimeEditModel {
  final int id;
  final WorkPlaceModel workplace;
  final String start_date;
  final String end_date;
  final String start_time;
  final String end_time;
  final String? title;
  final String description;
  final String status;

  OvertimeEditModel({
    required this.id,
    required this.workplace,
    required this.start_date,
    required this.end_date,
    required this.start_time,
    required this.end_time,
    required this.title,
    required this.description,
    required this.status,
  });

  factory OvertimeEditModel.fromJson(Map<String, dynamic> json) =>
      _$OvertimeEditModelFromJson(json);

  Map<String, dynamic> toJson() => _$OvertimeEditModelToJson(this);
}
