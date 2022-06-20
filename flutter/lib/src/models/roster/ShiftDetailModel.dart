// ignore_for_file: non_constant_identifier_names, file_names
import 'package:json_annotation/json_annotation.dart';
part 'ShiftDetailModel.g.dart';

@JsonSerializable()
class ShiftDetailModel {
  final int? id;
  final String from_date;
  final String to_date;
  final String working_hour;
  final String? status;
  final List<String>? sunday;
  final List<String>? monday;
  final List<String>? tuesday;
  final List<String>? wednesday;
  final List<String>? thursday;
  final List<String>? friday;
  final List<String>? saturday;

  ShiftDetailModel({
    required this.id,
    required this.from_date,
    required this.to_date,
    required this.working_hour,
    required this.status,
    required this.sunday,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
  });

  factory ShiftDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftDetailModelToJson(this);
}
