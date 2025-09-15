import 'dart:math';
import 'package:sudoku_app/utils/sudoku_solver.dart';

class PuzzleGenerator {
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
