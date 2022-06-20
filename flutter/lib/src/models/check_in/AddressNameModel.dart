// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';
part 'AddressNameModel.g.dart';

@JsonSerializable()
class AddressNameModel {
  final String name;
  final String address;

  AddressNameModel({required this.name, required this.address});

  factory AddressNameModel.fromJson(Map<String, dynamic> json) =>
      _$AddressNameModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressNameModelToJson(this);
}
