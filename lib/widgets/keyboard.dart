import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
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
  final FToast fToast = FToast();
  final firstRow = 'QWERTYUIOP'.split('');
  final secondRow = 'ASDFGHJKL'.split('');
  final thirdRow = '+ZXCVBNM-'.split('');

  String _currentWord = '';

  @override
  void didUpdateWidget(covariant Keyboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    fToast.init(context);
  }

  void clearBuffer() {
    log('Keyboard: Clearing buffer.');
    _currentWord = '';
  }

  Widget toast({required String message, IconData? icon}) {
    return Material(
      borderRadius: BorderRadius.circular(25.0),
      elevation: 3,
      shadowColor: Colors.black,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.red.shade900,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: Colors.white,
                size: 48,
              ),
              const SizedBox(width: 12.0)
            ],
            Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRowButtons(
    BuildContext context,
    List<String> keys,
    Map<CellState, Set<String>> keyStates,
  ) {
    void submitWord() async {
      if (!widget.board.allWords.contains(_currentWord)) {
        fToast.removeCustomToast();
        fToast.removeQueuedCustomToasts();
        fToast.showToast(
          child: toast(
            message: 'Your word is not in the dictionary.',
            icon: Icons.error,
          ),
          fadeDuration: const Duration(milliseconds: 300),
          toastDuration: const Duration(seconds: 1, milliseconds: 700),
          gravity: ToastGravity.CENTER,
        );
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
