// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';
part 'UserOverTimeModel.g.dart';

@JsonSerializable()
class UserOverTimeModel {
  final int id;
  final String full_name;
  final String email;
  final String? photo;
  final String first_name;
  final String last_name;
  final String? phone_number;

  UserOverTimeModel(
      {required this.id,
      required this.full_name,
      required this.email,
      required this.photo,
      required this.first_name,
      required this.last_name,
      required this.phone_number});

  factory UserOverTimeModel.fromJson(Map<String, dynamic> json) =>
      _$UserOverTimeModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserOverTimeModelToJson(this);
}
