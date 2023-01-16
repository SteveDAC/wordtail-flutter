import 'package:flutter/material.dart';

enum CellState {
  correct,
  incorrect,
  misplaced,
  none,
}

Map<CellState, Color> cellStateColors = {
  CellState.correct: Colors.green,
  CellState.incorrect: Colors.grey.shade900,
  CellState.misplaced: Colors.amber,
  CellState.none: Colors.black,
};
