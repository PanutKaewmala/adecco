// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';

part 'PlaceModel.g.dart';

@JsonSerializable()
class PlaceModel {
  final int id;
  final String place_name;
  final double latitude;
  final double longitude;

  PlaceModel({
    required this.id,
    required this.place_name,
    required this.latitude,
    required this.longitude,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) =>
      _$PlaceModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceModelToJson(this);
}
