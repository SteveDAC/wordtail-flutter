// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'line.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Line _$LineFromJson(Map<String, dynamic> json) => Line()
  ..cells = (json['cells'] as List<dynamic>)
      .map((e) => Cell.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$LineToJson(Line instance) => <String, dynamic>{
      'cells': instance.cells,
    };
