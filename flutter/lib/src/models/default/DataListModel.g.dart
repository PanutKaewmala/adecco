// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DataListModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataListModel _$DataListModelFromJson(Map<String, dynamic> json) =>
    DataListModel(
      count: json['count'] as int,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$DataListModelToJson(DataListModel instance) =>
    <String, dynamic>{
      'count': instance.count,
      'next': instance.next,
      'previous': instance.previous,
      'results': instance.results,
    };
