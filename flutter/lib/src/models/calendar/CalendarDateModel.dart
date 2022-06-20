// ignore_for_file: non_constant_identifier_names, file_names
import 'package:json_annotation/json_annotation.dart';
part 'CalendarDateModel.g.dart';

@JsonSerializable()
class CalendarDateModel {
  final String date;
  final List<String> type;

  CalendarDateModel({required this.date, required this.type});

  factory CalendarDateModel.fromJson(Map<String, dynamic> json) =>
      _$CalendarDateModelFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarDateModelToJson(this);
}
