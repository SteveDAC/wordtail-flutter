// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cell.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cell _$CellFromJson(Map<String, dynamic> json) => Cell()
  ..cellState = $enumDecode(_$CellStateEnumMap, json['cellState'])
  ..letter = json['letter'] as String;

Map<String, dynamic> _$CellToJson(Cell instance) => <String, dynamic>{
      'cellState': _$CellStateEnumMap[instance.cellState]!,
      'letter': instance.letter,
    };

const _$CellStateEnumMap = {
  CellState.correct: 'correct',
  CellState.incorrect: 'incorrect',
  CellState.misplaced: 'misplaced',
  CellState.none: 'none',
};
