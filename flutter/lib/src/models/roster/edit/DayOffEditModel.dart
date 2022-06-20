// ignore_for_file: non_constant_identifier_names, file_names
import 'package:json_annotation/json_annotation.dart';
part 'DayOffEditModel.g.dart';

@JsonSerializable()
class DayOffEditModel {
  final int id;
  final String status;
  final int working_hour;
  final List<String> detail_list;

  DayOffEditModel(
      {required this.id,
      required this.status,
      required this.working_hour,
      required this.detail_list});

  factory DayOffEditModel.fromJson(Map<String, dynamic> json) =>
      _$DayOffEditModelFromJson(json);

  Map<String, dynamic> toJson() => _$DayOffEditModelToJson(this);
}
