// ignore_for_file: non_constant_identifier_names, file_names
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:json_annotation/json_annotation.dart';
part 'RosterDetailModel.g.dart';

@JsonSerializable()
class RosterDetailModel {
  final int? id;
  final String name;
  final String? status;
  final String start_date;
  final String end_date;
  final List<ShiftDetailModel> shifts;
  final RosterCalendarModel? calendar;
  final List<String>? holiday_list;
  final List<String>? day_off;
  final String? remark;
  final String? description;
  final List<String>? working_hours;
  final bool? roster_setting;

  RosterDetailModel(
      {required this.id,
      required this.name,
      required this.status,
      required this.start_date,
      required this.end_date,
      required this.shifts,
      required this.calendar,
      required this.holiday_list,
      required this.day_off,
      required this.remark,
      required this.description,
      required this.working_hours,
      required this.roster_setting});

  factory RosterDetailModel.fromJson(Map<String, dynamic> json) =>
      _$RosterDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$RosterDetailModelToJson(this);
}
