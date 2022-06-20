// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';
part 'TokenRefreshModel.g.dart';

@JsonSerializable()
class TokenRefreshModel {
  final String access;

  TokenRefreshModel({required this.access});

  factory TokenRefreshModel.fromJson(Map<String, dynamic> json) =>
      _$TokenRefreshModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokenRefreshModelToJson(this);
}
