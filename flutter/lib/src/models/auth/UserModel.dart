// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';

part 'UserModel.g.dart';

@JsonSerializable()
class UserModel {
  final int id;
  final String username, email, first_name, last_name;
  final String? role;
  bool default_password_changed;

  UserModel(
      {required this.id,
      required this.username,
      required this.email,
      required this.first_name,
      required this.last_name,
      required this.default_password_changed,
      this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
