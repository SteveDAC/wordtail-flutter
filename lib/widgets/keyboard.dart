import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cell_state.dart';
import '../models/board.dart';

import 'keyboard_button.dart';

class Keyboard extends StatefulWidget {
  const Keyboard({
    required this.board,
    Key? key,
  }) : super(key: key);

  final Board board;

  @override
  State<Keyboard> createState() => _KeyboardState();
}

class _KeyboardState extends State<Keyboard> {
  var firstRow = 'QWERTYUIOP'.split('');
  var secondRow = 'ASDFGHJKL'.split('');
  var thirdRow = '+ZXCVBNM-'.split('');

  String _currentWord = '';

  void clearBuffer() {
    log('Keyboard: Clearing buffer.');
    _currentWord = '';
  }

  List<Widget> _buildRowButtons(
    BuildContext context,
    List<String> keys,
    Map<CellState, Set<String>> keyStates,
  ) {
    var scaffold = ScaffoldMessenger.of(context);

    void submitWord() async {
      if (!widget.board.allWords.contains(_currentWord)) {
        scaffold.clearSnackBars();
        scaffold.showSnackBar(SnackBar(
            content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).errorColor,
            ),
            const SizedBox(width: 5),
            const Text('Your word is not in the dictionary.'),
          ],
        )));
        return;
      }

      clearBuffer();
      widget.board.validateWord();
    }

    void keyPressed(String key) async {
      if (Provider.of<Board>(context, listen: false).isValidating) {
        log('Validating so exit.');
        return;
      }

      switch (key) {
        case 'ENTER':
          if (_currentWord.length == 5) {
            submitWord();
          }
          break;

        case 'DELETE':
          if (_currentWord.isEmpty) {
            return;
          }
          _currentWord = _currentWord.substring(0, _currentWord.length - 1);
          widget.board.setWord(_currentWord);
          break;

        default:
          if (_currentWord.length < 5) {
            _currentWord += key;
            widget.board.setWord(_currentWord);
          }
          break;
      }
    }

    List<Widget> keyboardButtons = [];
    for (String k in keys) {
      var key = k;
      var isSpecialKey = false;
      var keyState = CellState.none;
      switch (key) {
        case '+':
          key = 'ENTER';
          isSpecialKey = true;
          break;

        case '-':
          key = 'DELETE';
          isSpecialKey = true;
          break;

        default:
          if (keyStates[CellState.correct]!.contains(key)) {
            keyState = CellState.correct;
          } else if (keyStates[CellState.incorrect]!.contains(key)) {
            keyState = CellState.incorrect;
          } else if (keyStates[CellState.misplaced]!.contains(key)) {
            keyState = CellState.misplaced;
          }
      }

      keyboardButtons.add(
        KeyboardButton(
          buttonKey: key,
          buttonState: keyState,
          isSpecialKey: isSpecialKey,
          buttonPressed: keyPressed,
        ),
      );
    }
    return keyboardButtons;
  }

  Widget _buildKeyboardRow(
      List<String> keys, Map<CellState, Set<String>> keyStates) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildRowButtons(context, keys, keyStates),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var keyStates = {
      CellState.correct: widget.board.correctLetters,
      CellState.incorrect: widget.board.incorrectLetters,
      CellState.misplaced: widget.board.misplacedLetters,
    };

    return Container(
      // height: 200,
      padding: const EdgeInsets.only(
        left: 3,
        bottom: 15,
        right: 3,
      ),
      // color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildKeyboardRow(firstRow, keyStates),
          _buildKeyboardRow(secondRow, keyStates),
          _buildKeyboardRow(thirdRow, keyStates),
        ],
      ),
    );
  }
}
