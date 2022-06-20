// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';

part 'CheckInTimeModel.g.dart';

@JsonSerializable()
class CheckInTimeModel {
  final String before;
  final String time;
  final String after;

  CheckInTimeModel(
      {required this.before, required this.time, required this.after});

  factory CheckInTimeModel.fromJson(Map<String, dynamic> json) =>
      _$CheckInTimeModelFromJson(json);

  Map<String, dynamic> toJson() => _$CheckInTimeModelToJson(this);
}
