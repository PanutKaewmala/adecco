// ignore_for_file: non_constant_identifier_names, file_names

import 'package:ahead_adecco/src/models/check_in/check_in_new/CheckInTimeModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'WorkingHoursLocation.g.dart';

@JsonSerializable()
class WorkingHoursLocation {
  final int? id;
  final CheckInTimeModel? start_time;
  final CheckInTimeModel? end_time;

  WorkingHoursLocation(
      {required this.id, required this.start_time, required this.end_time});

  factory WorkingHoursLocation.fromJson(Map<String, dynamic> json) =>
      _$WorkingHoursLocationFromJson(json);

  Map<String, dynamic> toJson() => _$WorkingHoursLocationToJson(this);
}
