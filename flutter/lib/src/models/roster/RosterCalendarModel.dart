// ignore_for_file: non_constant_identifier_names, file_names
import 'package:ahead_adecco/src/models/roster/RosterDayModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'RosterCalendarModel.g.dart';

@JsonSerializable()
class RosterCalendarModel {
  final String month_name;
  final List<RosterDayModel> calendars;

  RosterCalendarModel({required this.month_name, required this.calendars});

  factory RosterCalendarModel.fromJson(Map<String, dynamic> json) =>
      _$RosterCalendarModelFromJson(json);

  Map<String, dynamic> toJson() => _$RosterCalendarModelToJson(this);
}
