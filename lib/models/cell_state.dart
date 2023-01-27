import 'package:flutter/material.dart';

enum CellState {
  correct,
  incorrect,
  misplaced,
  none,
}

const Map<CellState, Color> cellStateColors = {
  CellState.correct: Colors.green,
  CellState.incorrect: Color.fromRGBO(35, 35, 35, 1),
  CellState.misplaced: Colors.amber,
  CellState.none: Colors.black,
};
