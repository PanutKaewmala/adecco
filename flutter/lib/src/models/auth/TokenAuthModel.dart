// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';
import 'UserModel.dart';

part 'TokenAuthModel.g.dart';

@JsonSerializable()
class TokenAuthModel {
  final String access, refresh;
  final UserModel user;

  TokenAuthModel(
      {required this.access, required this.refresh, required this.user});

  factory TokenAuthModel.fromJson(Map<String, dynamic> json) =>
      _$TokenAuthModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokenAuthModelToJson(this);
}
