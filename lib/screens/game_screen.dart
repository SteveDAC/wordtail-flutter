import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

import '../models/board.dart';

import '../widgets/game_board.dart';
import '../widgets/keyboard.dart';
import '../screens/about_screen.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  Widget buildWinMessage() {
    return const Text('Congratulations! You are WINNER!');
  }

  Widget buildLossMessage(String word) {
    return Text('So sad. You lose. The word was $word');
  }

  Widget buildGame() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Consumer<Board>(
          builder: (context, board, _) {
            return Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: GameBoard(
                  board: board,
                ),
              ),
            );
          },
        ),
        Consumer<Board>(builder: (context, board, _) {
          if (!board.isGameOver) {
            return FittedBox(
              fit: BoxFit.contain,
              child: Keyboard(board: board),
            );
          } else {
            return Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (board.gameWon) buildWinMessage(),
                    if (!board.gameWon) buildLossMessage(board.targetWord),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      child: const Text('New Game'),
                      onPressed: () => board.initNewGame(),
                    ),
                  ],
                ),
              ),
            );
          }
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WordTail'),
        actions: [
          Consumer<Board>(
            builder: (context, board, child) => TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AboutScreen.routeName).then(
                  (_) {
                    if (board.isGameOver) {
                      Wakelock.disable();
                    } else {
                      Wakelock.enable();
                    }
                  },
                );
              },
              child: const Text('About'),
            ),
          ),
        ],
      ),
      body: buildGame(),
    );
  }
}
