// ignore_for_file: non_constant_identifier_names, file_names

import 'package:ahead_adecco/src/models/check_in/check_in_new/ActivityModel.dart';
import 'package:ahead_adecco/src/models/check_in/check_in_new/WorkPlaceModel.dart';
import 'package:ahead_adecco/src/models/check_in/check_in_new/WorkingHoursLocation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'LocationModel.g.dart';

@JsonSerializable()
class LocationModel {
  final WorkPlaceModel workplace;
  final int project;
  final String date;
  final WorkingHoursLocation? working_hour;
  final bool from_roster;
  final ActivityModel activity;

  LocationModel(
      {required this.workplace,
      required this.project,
      required this.date,
      required this.working_hour,
      required this.from_roster,
      required this.activity});

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);
}
