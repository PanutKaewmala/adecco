// ignore_for_file: non_constant_identifier_names, file_names
import 'package:json_annotation/json_annotation.dart';
part 'PlaceRosterModel.g.dart';

@JsonSerializable()
class PlaceRosterModel {
  final int id;
  final String name;

  PlaceRosterModel({required this.id, required this.name});

  factory PlaceRosterModel.fromJson(Map<String, dynamic> json) =>
      _$PlaceRosterModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceRosterModelToJson(this);
}
