import 'package:flutter/material.dart';

import '../models/cell_state.dart';
import '../models/cell.dart';

class Tile extends StatelessWidget {
  const Tile({Key? key, required this.cell}) : super(key: key);

  final Cell cell;

  Gradient? stateGradient(Cell cell) {
    if ({CellState.none, CellState.incorrect}.contains(cell.cellState)) {
      return null;
    } else {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          cellStateColors[cell.cellState]!,
          cellStateColors[cell.cellState]!.withOpacity(0.4)
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isInput =
        (cell.letter.isNotEmpty && cell.cellState == CellState.none);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
      width: 55,
      height: 60,
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: isInput ? Colors.white : const Color.fromRGBO(35, 35, 35, 1),
        ),
        borderRadius: BorderRadius.circular(10),
        color: cellStateColors[cell.cellState],
        gradient: stateGradient(cell),
        //boxShadow: kElevationToShadow[8],
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(
          cell.letter,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 35,
          ),
        ),
      ),
    );
  }
}
