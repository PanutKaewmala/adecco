// ignore_for_file: non_constant_identifier_names, file_names
import 'package:json_annotation/json_annotation.dart';
part 'RosterModel.g.dart';

@JsonSerializable()
class RosterModel {
  final int id;
  final String name;
  final String status;
  final String start_date;
  final String end_date;
  final String type;

  RosterModel(
      {required this.id,
      required this.name,
      required this.status,
      required this.start_date,
      required this.end_date,
      required this.type});

  factory RosterModel.fromJson(Map<String, dynamic> json) =>
      _$RosterModelFromJson(json);

  Map<String, dynamic> toJson() => _$RosterModelToJson(this);
}
