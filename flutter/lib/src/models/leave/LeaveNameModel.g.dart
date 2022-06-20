// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LeaveNameModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaveNameModel _$LeaveNameModelFromJson(Map<String, dynamic> json) =>
    LeaveNameModel(
      leave_name: (json['leave_name'] as List<dynamic>)
          .map((e) => LeaveTypeDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LeaveNameModelToJson(LeaveNameModel instance) =>
    <String, dynamic>{
      'leave_name': instance.leave_name,
    };
