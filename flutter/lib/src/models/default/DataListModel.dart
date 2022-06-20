// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';

part 'DataListModel.g.dart';

@JsonSerializable()
class DataListModel {
  final int count;
  final String? next;
  final String? previous;
  final List<Map<String, dynamic>> results;

  DataListModel(
      {required this.count, this.next, this.previous, required this.results});

  factory DataListModel.fromJson(Map<String, dynamic> json) =>
      _$DataListModelFromJson(json);

  Map<String, dynamic> toJson() => _$DataListModelToJson(this);
}
