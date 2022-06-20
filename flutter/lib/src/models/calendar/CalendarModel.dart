// ignore_for_file: non_constant_identifier_names, file_names
import 'package:json_annotation/json_annotation.dart';

import 'CalendarDateModel.dart';
part 'CalendarModel.g.dart';

@JsonSerializable()
class CalendarModel {
  final String month_name;
  final List<CalendarDateModel> calendars;

  CalendarModel({required this.month_name, required this.calendars});

  factory CalendarModel.fromJson(Map<String, dynamic> json) =>
      _$CalendarModelFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarModelToJson(this);
}
