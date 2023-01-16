// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameData _$GameDataFromJson(Map<String, dynamic> json) => GameData(
      lines: (json['lines'] as List<dynamic>)
          .map((e) => Line.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentLine: json['currentLine'] as int,
      targetWord: json['targetWord'] as String,
      correctLetters: (json['correctLetters'] as List<dynamic>)
          .map((e) => e as String)
          .toSet(),
      incorrectLetters: (json['incorrectLetters'] as List<dynamic>)
          .map((e) => e as String)
          .toSet(),
      misplacedLetters: (json['misplacedLetters'] as List<dynamic>)
          .map((e) => e as String)
          .toSet(),
    );

Map<String, dynamic> _$GameDataToJson(GameData instance) => <String, dynamic>{
      'lines': instance.lines,
      'currentLine': instance.currentLine,
      'targetWord': instance.targetWord,
      'correctLetters': instance.correctLetters.toList(),
      'incorrectLetters': instance.incorrectLetters.toList(),
      'misplacedLetters': instance.misplacedLetters.toList(),
    };
