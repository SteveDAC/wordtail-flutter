import 'package:flutter/material.dart';

import '../models/cell_state.dart';

class KeyboardButton extends StatelessWidget {
  KeyboardButton({
    Key? key,
    required this.buttonKey,
    required this.buttonState,
    required this.buttonPressed,
    this.isSpecialKey = false,
  }) : super(key: key);

  final keyColors = {
    CellState.correct: Colors.green,
    CellState.incorrect: Colors.grey.shade900,
    CellState.misplaced: const Color.fromRGBO(202, 154, 11, 1),
    CellState.none: const Color.fromRGBO(36, 59, 71, 1),
  };

  final Function(String key) buttonPressed;
  final String buttonKey;
  final CellState buttonState;
  final bool isSpecialKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isSpecialKey ? 60 : 35,
      height: 59,
      margin: const EdgeInsets.all(1),
      child: Material(
        borderRadius: BorderRadius.circular(7),
        child: Ink(
          decoration: BoxDecoration(
            color: keyColors[buttonState],
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              width: 1,
              color: Colors.black54,
            ),
          ),
          child: InkWell(
            onTap: () {
              buttonPressed(buttonKey);
            },
            child: Container(
                padding: const EdgeInsets.all(10),
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      buttonKey,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ))),
          ),
        ),
      ),
    );
  }
}
