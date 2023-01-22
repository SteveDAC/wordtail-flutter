import 'dart:convert';
import 'dart:developer' show log;
import 'dart:math' hide log;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cell_state.dart';
import 'line.dart';

part 'board.g.dart';

@JsonSerializable()
class GameData {
  GameData({
    required this.lines,
    required this.currentLine,
    required this.targetWord,
    required this.correctLetters,
    required this.incorrectLetters,
    required this.misplacedLetters,
  });

  final List<Line> lines;
  final int currentLine;
  final String targetWord;
  final Set<String> correctLetters;
  final Set<String> incorrectLetters;
  final Set<String> misplacedLetters;

  factory GameData.fromJson(Map<String, dynamic> json) =>
      _$GameDataFromJson(json);
  Map<String, dynamic> toJson() => _$GameDataToJson(this);
}

class Board with ChangeNotifier {
  List<Line> lines = [
    Line(),
    Line(),
    Line(),
    Line(),
    Line(),
    Line(),
  ];
  Set<String> correctLetters = {};
  Set<String> incorrectLetters = {};
  Set<String> misplacedLetters = {};
  int currentLine = 0;
  String targetWord = '';
  bool isGameOver = true;
  List<String> allWords = [];
  List<String> targetWords = [];

  Board() {
    void init() async {
      bool isDataLoaded = await loadData();
      if (!isDataLoaded) {
        log('No saved game data found.');
        initNewGame();
      }
    }

    rootBundle.loadString('assets/words/allWords.txt').then((words) {
      allWords = words.toUpperCase().split('\n').toList();
      log('All words loaded: ${allWords.length}');
    });

    rootBundle.loadString('assets/words/targetWords.txt').then((words) {
      targetWords = words.toUpperCase().split('\n').toList();
      log('Target words loaded: ${targetWords.length}');
      init();
    });
  }

  bool get gameWon => lines.where((line) => line.isCorrect).isNotEmpty;
  String get currentWord => lines[currentLine].word;

  void initNewGame() {
    log('Initialising new game.');
    lines = [
      Line(),
      Line(),
      Line(),
      Line(),
      Line(),
      Line(),
    ];
    correctLetters = {};
    incorrectLetters = {};
    misplacedLetters = {};
    targetWord = targetWords[Random().nextInt(targetWords.length)];
    currentLine = 0;
    isGameOver = false;

    log('Target word: $targetWord');

    notifyListeners();
  }

  void setWord(String word) {
    lines[currentLine].setWord(word);
    notifyListeners();
  }

  void validateWord() {
    var word = targetWord;

    if (word.length != 5) {
      log('Board validate: Word must be 5 characters in length.');
      return;
    }

    var result = lines[currentLine].validateWord(word);
    correctLetters.addAll(result[CellState.correct] as Set<String>);
    incorrectLetters.addAll(result[CellState.incorrect] as Set<String>);
    misplacedLetters = result[CellState.misplaced] as Set<String>;

    log('correctLetters: $correctLetters');
    log('incorrectLetters: $incorrectLetters');
    log('misplacedLetters: $misplacedLetters');

    isGameOver =
        lines[currentLine].isCorrect || currentLine == lines.length - 1;

    if (!isGameOver) {
      currentLine++;
      saveData();
    } else {
      clearSavedData();
    }

    notifyListeners();
  }

  void saveData() {
    log('Saving game data.');

    SharedPreferences.getInstance().then(
      (prefs) {
        var gameData = GameData(
          lines: lines,
          currentLine: currentLine,
          targetWord: targetWord,
          correctLetters: correctLetters,
          incorrectLetters: incorrectLetters,
          misplacedLetters: misplacedLetters,
        );
        prefs.setString('gameData', jsonEncode(gameData.toJson()));
      },
    );
  }

  Future<bool> loadData() async {
    var prefs = await SharedPreferences.getInstance();
    log('Checking for saved game data.');

    if (prefs.containsKey('gameData')) {
      log('Loading saved game data.');
      var gameData = GameData.fromJson(
        jsonDecode(
          prefs.getString('gameData')!,
        ),
      );

      lines = gameData.lines;
      currentLine = gameData.currentLine;
      targetWord = gameData.targetWord;
      correctLetters = gameData.correctLetters;
      incorrectLetters = gameData.incorrectLetters;
      misplacedLetters = gameData.misplacedLetters;
      isGameOver = false;

      log('Data loaded. targetWord: $targetWord');
      notifyListeners();
      return true;
    }
    return false;
  }

  void clearSavedData() {
    log('Clearing saved game data.');
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('gameData');
    });
  }
}
