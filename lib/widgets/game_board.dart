import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

import '../models/line.dart';
import '../models/board.dart';

import 'tile.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({
    Key? key,
    required this.board,
  }) : super(key: key);

  final Board board;

  Widget _buildRow(Line line) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: line.cells.map((cell) => Tile(cell: cell)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (board.isGameOver) {
      Wakelock.disable();
    } else {
      Wakelock.enable();
    }
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        left: 5,
        right: 5,
      ),
      child: Column(
        children: board.lines.map(((row) => _buildRow(row))).toList(),
      ),
    );
  }
}
