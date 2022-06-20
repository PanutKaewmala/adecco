// ignore_for_file: non_constant_identifier_names, file_names
import 'package:json_annotation/json_annotation.dart';
part 'RosterDayModel.g.dart';

@JsonSerializable()
class RosterDayModel {
  final String date;
  final String type;

  RosterDayModel({required this.date, required this.type});

  factory RosterDayModel.fromJson(Map<String, dynamic> json) =>
      _$RosterDayModelFromJson(json);

  Map<String, dynamic> toJson() => _$RosterDayModelToJson(this);
}
