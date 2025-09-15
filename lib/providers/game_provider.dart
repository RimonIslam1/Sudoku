import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:sudoku_app/services/storage_service.dart';
import 'package:sudoku_app/models/solved_puzzle.dart';
import 'package:sudoku_app/models/leaderboard_entry.dart';

class GameProvider extends ChangeNotifier {
  List<List<int>> _board = List.generate(9, (_) => List.filled(9, 0));
  List<List<int>> _solution = List.generate(9, (_) => List.filled(9, 0));
  List<List<int>> _originalBoard = List.generate(9, (_) => List.filled(9, 0));
  List<Move> _moveHistory = [];
  int _mistakes = 0;
  String? _currentPuzzleId;
  String _difficulty = 'Easy';
  bool _isGameComplete = false;
  late List<List<Set<int>>> _candidates;

  // Timer functionality
  Timer? _timer;
  Duration _elapsedTime = Duration.zero;
  bool _isTimerRunning = false;
  bool _hasGameStarted = false;

  GameProvider() {
    _generateNewGame();
  }

  List<List<int>> get board => _board;
  List<List<int>> get solution => _solution;
  List<List<int>> get originalBoard => _originalBoard;
  List<Move> get moveHistory => _moveHistory;
  int get mistakes => _mistakes;
  String get difficulty => _difficulty;
  bool get isGameComplete => _isGameComplete;
  List<List<Set<int>>> get candidates => _candidates;
  Duration get elapsedTime => _elapsedTime;
  bool get isTimerRunning => _isTimerRunning;
  bool get hasGameStarted => _hasGameStarted;

  // Get digit counts (excluding candidates)
  Map<int, int> get digitCounts {
    Map<int, int> counts = {};
    for (int i = 1; i <= 9; i++) {
      counts[i] = 0;
    }

    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        int value = _board[row][col];
        if (value > 0) {
          counts[value] = (counts[value] ?? 0) + 1;
        }
      }
    }
    return counts;
  }

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
    _initCandidates();
    _resetTimer();
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

    // Start timer on first move
    if (!_hasGameStarted && value != 0) {
      startGame();
    }

    int previousValue = _board[row][col];
    _board[row][col] = value;
    if (value != 0) {
      _candidates[row][col].clear();
    }

    _moveHistory.add(Move(row, col, previousValue, value));

    if (value != 0 &&
        _solution[row][col] != 0 &&
        value != _solution[row][col]) {
      _mistakes++;
    }

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
    // Stop timer when game is complete
    if (_isGameComplete) {
      _stopTimer();
      _persistCompletion();
    }
  }

  Future<void> _persistCompletion() async {
    try {
      final storage = StorageService();
      final String id =
          _currentPuzzleId ?? DateTime.now().millisecondsSinceEpoch.toString();
      final solved = SolvedPuzzle(
        id: id,
        difficulty: _difficulty,
        originalBoard: List.generate(9, (i) => List.from(_originalBoard[i])),
        solutionBoard: List.generate(9, (i) => List.from(_solution[i])),
        elapsedTime: _elapsedTime,
        completedAt: DateTime.now(),
        movesCount: _moveHistory.length,
        mistakesCount: _mistakes,
      );
      await storage.saveSolvedPuzzle(solved);

      final name = await storage.getPlayerName();
      final leaderboardEntry = LeaderboardEntry(
        id: id,
        playerName: name,
        difficulty: _difficulty,
        elapsedTime: _elapsedTime,
        puzzlesSolved: 1,
        completedAt: DateTime.now(),
        puzzleId: id,
        movesCount: _moveHistory.length,
      );
      await storage.addLeaderboardEntry(leaderboardEntry);
    } catch (_) {
      // ignore persistence errors to not affect gameplay
    }
  }

  bool isOriginalCell(int row, int col) {
    return _originalBoard[row][col] != 0;
  }

  void resetGame() {
    _board = List.generate(9, (i) => List.from(_originalBoard[i]));
    _moveHistory.clear();
    _isGameComplete = false;
    _mistakes = 0;
    _initCandidates();
    _resetTimer();
    notifyListeners();
  }

  void _initCandidates() {
    _candidates =
        List.generate(9, (_) => List.generate(9, (_) => <int>{}.toSet()));
  }

  void toggleCandidate(int row, int col, int number) {
    if (isOriginalCell(row, col)) return;
    final cellCandidates = _candidates[row][col];
    if (cellCandidates.contains(number)) {
      cellCandidates.remove(number);
    } else {
      cellCandidates.add(number);
    }
    notifyListeners();
  }

  Set<int> getCandidates(int row, int col) {
    return _candidates[row][col];
  }

  void clearCandidates(int row, int col) {
    _candidates[row][col].clear();
    notifyListeners();
  }

  bool provideHintAt(int row, int col) {
    if (isOriginalCell(row, col)) return false;
    if (_solution[row][col] == 0) return false;
    final correctValue = _solution[row][col];
    if (_board[row][col] == correctValue) return false;
    makeMove(row, col, correctValue);
    return true;
  }

  bool provideRandomHint() {
    final List<Point> empties = [];
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (!isOriginalCell(r, c) && _board[r][c] != _solution[r][c]) {
          empties.add(Point(r, c));
        }
      }
    }
    if (empties.isEmpty) return false;
    final random = Random();
    final p = empties[random.nextInt(empties.length)];
    return provideHintAt(p.row, p.col);
  }

  void loadPuzzle(
      List<List<int>> board, List<List<int>> solution, String difficulty) {
    _difficulty = difficulty;
    _solution = List.generate(9, (i) => List.from(solution[i]));
    _board = List.generate(9, (i) => List.from(board[i]));
    _originalBoard = List.generate(9, (i) => List.from(board[i]));
    _moveHistory.clear();
    _isGameComplete = false;
    _mistakes = 0;
    _currentPuzzleId = _computePuzzleId(board, solution);
    _initCandidates();
    notifyListeners();
  }

  // Timer methods
  void _resetTimer() {
    _stopTimer();
    _elapsedTime = Duration.zero;
    _hasGameStarted = false;
    _isTimerRunning = false;
  }

  void _startTimer() {
    if (!_isTimerRunning) {
      _isTimerRunning = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _elapsedTime += const Duration(seconds: 1);
        notifyListeners();
      });
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    _isTimerRunning = false;
  }

  void _pauseTimer() {
    _stopTimer();
  }

  void startGame() {
    if (!_hasGameStarted) {
      _hasGameStarted = true;
      _startTimer();
    }
  }

  void pauseGame() {
    _pauseTimer();
  }

  void resumeGame() {
    if (_hasGameStarted && !_isGameComplete) {
      _startTimer();
    }
  }

  String get formattedTime {
    int hours = _elapsedTime.inHours;
    int minutes = _elapsedTime.inMinutes.remainder(60);
    int seconds = _elapsedTime.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  String _computePuzzleId(List<List<int>> board, List<List<int>> solution) {
    final buffer = StringBuffer();
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        buffer.write(solution[r][c]);
      }
    }
    return buffer.toString();
  }
}

class Move {
  final int row;
  final int col;
  final int previousValue;
  final int newValue;

  Move(this.row, this.col, this.previousValue, this.newValue);
}

class Point {
  final int row;
  final int col;
  const Point(this.row, this.col);
}
