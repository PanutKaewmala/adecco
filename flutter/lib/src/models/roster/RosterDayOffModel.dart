// ignore_for_file: non_constant_identifier_names, file_names
import 'package:json_annotation/json_annotation.dart';
part 'RosterDayOffModel.g.dart';

@JsonSerializable()
class RosterDayOffModel {
  int? id;
  final int working_hour;
  final List<String> detail_list;

  RosterDayOffModel({required this.working_hour, required this.detail_list});

  factory RosterDayOffModel.fromJson(Map<String, dynamic> json) =>
      _$RosterDayOffModelFromJson(json);

  Map<String, dynamic> toJson() => _$RosterDayOffModelToJson(this);
}
