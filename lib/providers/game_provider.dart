import 'package:flutter/material.dart';
import 'dart:math';

class GameProvider extends ChangeNotifier {
  List<List<int>> _board = List.generate(9, (_) => List.filled(9, 0));
  List<List<int>> _solution = List.generate(9, (_) => List.filled(9, 0));
  List<List<int>> _originalBoard = List.generate(9, (_) => List.filled(9, 0));
  List<Move> _moveHistory = [];
  String _difficulty = 'Easy';
  bool _isGameComplete = false;

  GameProvider() {
    _generateNewGame();
  }

  List<List<int>> get board => _board;
  List<List<int>> get solution => _solution;
  List<List<int>> get originalBoard => _originalBoard;
  List<Move> get moveHistory => _moveHistory;
  String get difficulty => _difficulty;
  bool get isGameComplete => _isGameComplete;

  void setDifficulty(String difficulty) {
    _difficulty = difficulty;
    _generateNewGame();
    print('Difficulty set to: $_difficulty');
  }

  void _generateNewGame() {
    _generateSolution();
    _createPuzzle();
    _moveHistory.clear();
    _isGameComplete = false;
    notifyListeners();
  }

  void _generateSolution() {
    // Generate a valid Sudoku solution
    _solution = List.generate(9, (_) => List.filled(9, 0));
    _fillDiagonal();
    _solveSudoku(_solution);
  }

  void _fillDiagonal() {
    // Fill the three 3x3 boxes on the diagonal
    _fillBox(0, 0);
    _fillBox(3, 3);
    _fillBox(6, 6);
  }

  void _fillBox(int row, int col) {
    List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    numbers.shuffle();
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        _solution[row + i][col + j] = numbers.removeLast();
      }
    }
  }

  bool _solveSudoku(List<List<int>> grid) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (grid[row][col] == 0) {
          for (int num = 1; num <= 9; num++) {
            if (_isValid(grid, row, col, num)) {
              grid[row][col] = num;
              if (_solveSudoku(grid)) {
                return true;
              }
              grid[row][col] = 0;
            }
          }
          return false;
        }
      }
    }
    return true;
  }

  bool _isValid(List<List<int>> grid, int row, int col, int num) {
    // Check row
    for (int x = 0; x < 9; x++) {
      if (grid[row][x] == num) return false;
    }

    // Check column
    for (int x = 0; x < 9; x++) {
      if (grid[x][col] == num) return false;
    }

    // Check 3x3 box
    int startRow = row - row % 3;
    int startCol = col - col % 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (grid[i + startRow][j + startCol] == num) return false;
      }
    }

    return true;
  }

  void _createPuzzle() {
    _board = List.generate(9, (i) => List.from(_solution[i]));
    _originalBoard = List.generate(9, (i) => List.from(_solution[i]));

    int cellsToRemove;
    switch (_difficulty) {
      case 'Easy':
        cellsToRemove = 30;
        break;
      case 'Medium':
        cellsToRemove = 45;
        break;
      case 'Hard':
        cellsToRemove = 55;
        break;
      default:
        cellsToRemove = 30;
    }

    Random random = Random();
    int removed = 0;
    while (removed < cellsToRemove) {
      int row = random.nextInt(9);
      int col = random.nextInt(9);
      if (_board[row][col] != 0) {
        _board[row][col] = 0;
        _originalBoard[row][col] = 0;
        removed++;
      }
    }
    
    // Debug: Print the board to console
    print('Generated Sudoku Board:');
    for (int i = 0; i < 9; i++) {
      print(_board[i].join(' '));
    }
  }

  void makeMove(int row, int col, int value) {
    if (_originalBoard[row][col] != 0) return; // Can't edit original numbers

    int previousValue = _board[row][col];
    _board[row][col] = value;
    
    _moveHistory.add(Move(row, col, previousValue, value));
    
    _checkGameComplete();
    notifyListeners();
  }

  void undoMove() {
    if (_moveHistory.isEmpty) return;

    Move lastMove = _moveHistory.removeLast();
    _board[lastMove.row][lastMove.col] = lastMove.previousValue;
    
    _checkGameComplete();
    notifyListeners();
  }

  void _checkGameComplete() {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (_board[i][j] != _solution[i][j]) {
          _isGameComplete = false;
          return;
        }
      }
    }
    _isGameComplete = true;
  }

  bool isOriginalCell(int row, int col) {
    return _originalBoard[row][col] != 0;
  }

  void resetGame() {
    _board = List.generate(9, (i) => List.from(_originalBoard[i]));
    _moveHistory.clear();
    _isGameComplete = false;
    notifyListeners();
  }
}

class Move {
  final int row;
  final int col;
  final int previousValue;
  final int newValue;

  Move(this.row, this.col, this.previousValue, this.newValue);
}
