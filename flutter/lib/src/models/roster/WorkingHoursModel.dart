// ignore_for_file: non_constant_identifier_names, file_names
import 'package:json_annotation/json_annotation.dart';
part 'WorkingHoursModel.g.dart';

@JsonSerializable()
class WorkingHoursModel {
  final int id;
  final String? sunday;
  final String? monday;
  final String? tuesday;
  final String? wednesday;
  final String? thursday;
  final String? friday;
  final String? saturday;
  final String name;
  final String? sunday_start_time;
  final String? sunday_end_time;
  final String? monday_start_time;
  final String? monday_end_time;
  final String? tuesday_start_time;
  final String? tuesday_end_time;
  final String? wednesday_start_time;
  final String? wednesday_end_time;
  final String? thursday_start_time;
  final String? thursday_end_time;
  final String? friday_start_time;
  final String? friday_end_time;
  final String? saturday_start_time;
  final String? saturday_end_time;

  WorkingHoursModel({
    required this.id,
    required this.sunday,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.name,
    required this.sunday_start_time,
    required this.sunday_end_time,
    required this.monday_start_time,
    required this.monday_end_time,
    required this.tuesday_start_time,
    required this.tuesday_end_time,
    required this.wednesday_start_time,
    required this.wednesday_end_time,
    required this.thursday_start_time,
    required this.thursday_end_time,
    required this.friday_start_time,
    required this.friday_end_time,
    required this.saturday_start_time,
    required this.saturday_end_time,
  });

  factory WorkingHoursModel.fromJson(Map<String, dynamic> json) =>
      _$WorkingHoursModelFromJson(json);

  Map<String, dynamic> toJson() => _$WorkingHoursModelToJson(this);
}
