// ignore_for_file: non_constant_identifier_names, file_names
import 'package:json_annotation/json_annotation.dart';
part 'ShiftScheduleEditModel.g.dart';

@JsonSerializable()
class ShiftScheduleEditModel {
  final String? sunday;
  final String? monday;
  final String? tuesday;
  final String? wednesday;
  final String? thursday;
  final String? friday;
  final String? saturday;
  final List<int> workplaces;
  final int shift;

  ShiftScheduleEditModel(
      {required this.sunday,
      required this.monday,
      required this.tuesday,
      required this.wednesday,
      required this.thursday,
      required this.friday,
      required this.saturday,
      required this.workplaces,
      required this.shift});

  factory ShiftScheduleEditModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftScheduleEditModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftScheduleEditModelToJson(this);
}
