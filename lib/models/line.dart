import 'dart:developer' show log;
import 'package:json_annotation/json_annotation.dart';

import 'cell_state.dart';
import 'cell.dart';

part 'line.g.dart';

@JsonSerializable()
class Line {
  Line();

  List<Cell> cells = [
    Cell(),
    Cell(),
    Cell(),
    Cell(),
    Cell(),
  ];

  String get word => cells.map((cell) => cell.letter).join();
  bool get isCorrect => cells
      .where(
        (cell) => cell.cellState != CellState.correct,
      )
      .isEmpty;

  void setWord(String word) {
    for (int i = 0; i < 5; i++) {
      if (i < word.length) {
        cells[i].letter = word[i];
      } else {
        cells[i].letter = '';
      }
    }
  }

  Map<CellState, Set<String>> validateWord(String targetWord) {
    String currentWord = word;
    var availableLetters = targetWord.split('');
    Set<String> correctLetters = {};
    Set<String> incorrectLetters = {};
    Set<String> misplacedLetters = {};

    log('Line Validating: $currentWord => $targetWord');

    // check for correct letter
    for (int i = 0; i < currentWord.length; i++) {
      if (currentWord[i] == targetWord[i]) {
        availableLetters.remove(currentWord[i]);
        cells[i].cellState = CellState.correct;
        correctLetters.add(currentWord[i]);
      }
    }

    // check for misplaced letters
    for (int i = 0; i < currentWord.length; i++) {
      if (cells[i].cellState == CellState.correct) {
        continue;
      }

      if (availableLetters.contains(currentWord[i])) {
        availableLetters.remove(currentWord[i]);
        cells[i].cellState = CellState.misplaced;
        misplacedLetters.add(currentWord[i]);
      }
    }

    // check for incorrect letters
    for (int i = 0; i < currentWord.length; i++) {
      if ({CellState.correct, CellState.misplaced}
          .contains(cells[i].cellState)) {
        continue;
      }

      cells[i].cellState = CellState.incorrect;
      incorrectLetters.add(currentWord[i]);
    }

    incorrectLetters.removeAll(correctLetters);
    incorrectLetters.removeAll(misplacedLetters);

    return {
      CellState.correct: correctLetters,
      CellState.incorrect: incorrectLetters,
      CellState.misplaced: misplacedLetters,
    };
  }

  factory Line.fromJson(Map<String, Object?> json) => _$LineFromJson(json);
  Map<String, dynamic> toJson() => _$LineToJson(this);
}
