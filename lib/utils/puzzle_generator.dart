import 'dart:math';
import 'package:sudoku_app/utils/sudoku_solver.dart';

class PuzzleGenerator {
  // Generate a complete valid Sudoku solution
  static List<List<int>> generateCompleteSolution({int? seed}) {
    final rng = seed != null ? Random(seed) : Random();
    final grid = List.generate(9, (_) => List.filled(9, 0));

    // Fill diagonal 3x3 boxes first (they are independent)
    _fillBox(grid, 0, 0, rng);
    _fillBox(grid, 3, 3, rng);
    _fillBox(grid, 6, 6, rng);

    // Solve the rest
    _solveSudoku(grid, rng);
    return grid;
  }

  static void _fillBox(List<List<int>> grid, int row, int col, Random rng) {
    final numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9]..shuffle(rng);
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        grid[row + i][col + j] = numbers.removeLast();
      }
    }
  }

  static bool _solveSudoku(List<List<int>> grid, Random rng) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (grid[row][col] == 0) {
          final numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9]..shuffle(rng);
          for (int num in numbers) {
            if (_isValid(grid, row, col, num)) {
              grid[row][col] = num;
              if (_solveSudoku(grid, rng)) {
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

  static bool _isValid(List<List<int>> grid, int row, int col, int num) {
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

  // Returns a board with exactly emptiesCount zeros, guaranteed solvable and unique
  // by masking from a valid solved grid. Throws if unable within attempts.
  static List<List<int>> generateMaskedUnique(
    List<List<int>> solved,
    int emptiesCount, {
    int maxAttempts = 500,
    int? seed,
  }) {
    final rng = seed != null ? Random(seed) : Random();
    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      final board = List.generate(9, (r) => List<int>.from(solved[r]));
      final List<int> cells = List.generate(81, (i) => i)..shuffle(rng);
      int removed = 0;
      for (final idx in cells) {
        if (removed >= emptiesCount) break;
        final r = idx ~/ 9;
        final c = idx % 9;
        if (board[r][c] == 0) continue;
        board[r][c] = 0;
        removed++;
      }

      // ensure exactly emptiesCount
      int zeros = 0;
      for (int r = 0; r < 9; r++) {
        for (int c = 0; c < 9; c++) {
          if (board[r][c] == 0) zeros++;
        }
      }
      if (zeros != emptiesCount) continue;

      // Validate consistency and uniqueness
      if (!SudokuSolver.isValidGrid(board)) continue;
      final res = SudokuSolver.solveWithUniqueness(board);
      if (res.solved && res.unique) {
        return board;
      }
    }
    throw StateError(
        'Unable to generate unique puzzle with $emptiesCount empties');
  }
}
