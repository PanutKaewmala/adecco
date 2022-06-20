// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';

part 'WorkPlaceModel.g.dart';

@JsonSerializable()
class WorkPlaceModel {
  final int id;
  final String name;

  WorkPlaceModel({required this.id, required this.name});

  factory WorkPlaceModel.fromJson(Map<String, dynamic> json) =>
      _$WorkPlaceModelFromJson(json);

  Map<String, dynamic> toJson() => _$WorkPlaceModelToJson(this);
}
