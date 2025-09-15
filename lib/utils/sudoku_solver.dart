class SudokuSolverResult {
  final bool solved;
  final List<List<int>> solution;
  final bool unique;
  SudokuSolverResult(
      {required this.solved, required this.solution, required this.unique});
}

class SudokuSolver {
  // Validate current grid: no conflicts for non-zero values
  static bool isValidGrid(List<List<int>> grid) {
    // Rows and columns
    for (int i = 0; i < 9; i++) {
      final rowSeen = <int>{};
      final colSeen = <int>{};
      for (int j = 0; j < 9; j++) {
        final r = grid[i][j];
        if (r != 0) {
          if (rowSeen.contains(r)) return false;
          rowSeen.add(r);
        }
        final c = grid[j][i];
        if (c != 0) {
          if (colSeen.contains(c)) return false;
          colSeen.add(c);
        }
      }
    }
    // 3x3 boxes
    for (int br = 0; br < 3; br++) {
      for (int bc = 0; bc < 3; bc++) {
        final seen = <int>{};
        for (int r = 0; r < 3; r++) {
          for (int c = 0; c < 3; c++) {
            final v = grid[br * 3 + r][bc * 3 + c];
            if (v != 0) {
              if (seen.contains(v)) return false;
              seen.add(v);
            }
          }
        }
      }
    }
    return true;
  }

  static SudokuSolverResult solveWithUniqueness(List<List<int>> input) {
    final grid = List.generate(9, (i) => List<int>.from(input[i]));
    int solutionsFound = 0;
    List<List<int>>? firstSolution;

    bool backtrack() {
      int minCandidates = 10;
      int targetRow = -1, targetCol = -1;
      Set<int> candidates = {};
      for (int r = 0; r < 9; r++) {
        for (int c = 0; c < 9; c++) {
          if (grid[r][c] == 0) {
            final cs = _candidates(grid, r, c);
            if (cs.isEmpty) return false;
            if (cs.length < minCandidates) {
              minCandidates = cs.length;
              targetRow = r;
              targetCol = c;
              candidates = cs;
              if (minCandidates == 1) break;
            }
          }
        }
        if (minCandidates == 1) break;
      }

      if (targetRow == -1) {
        solutionsFound++;
        if (firstSolution == null) {
          firstSolution = List.generate(9, (i) => List<int>.from(grid[i]));
        }
        return solutionsFound >= 2; // stop if more than one
      }

      for (final v in candidates) {
        if (_isSafe(grid, targetRow, targetCol, v)) {
          grid[targetRow][targetCol] = v;
          final shouldStop = backtrack();
          grid[targetRow][targetCol] = 0;
          if (shouldStop) return true;
        }
      }
      return false;
    }

    final consistent = isValidGrid(grid);
    if (!consistent) {
      return SudokuSolverResult(solved: false, solution: input, unique: false);
    }
    backtrack();
    final solved = solutionsFound >= 1;
    final unique = solutionsFound == 1;
    return SudokuSolverResult(
      solved: solved,
      solution: firstSolution ?? input,
      unique: unique,
    );
  }

  static Set<int> _candidates(List<List<int>> grid, int row, int col) {
    final taken = <int>{};
    for (int i = 0; i < 9; i++) {
      taken.add(grid[row][i]);
      taken.add(grid[i][col]);
    }
    final br = (row ~/ 3) * 3;
    final bc = (col ~/ 3) * 3;
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 3; c++) {
        taken.add(grid[br + r][bc + c]);
      }
    }
    final out = <int>{};
    for (int v = 1; v <= 9; v++) {
      if (!taken.contains(v)) out.add(v);
    }
    return out;
  }

  static bool _isSafe(List<List<int>> grid, int row, int col, int val) {
    for (int i = 0; i < 9; i++) {
      if (grid[row][i] == val) return false;
      if (grid[i][col] == val) return false;
    }
    final br = (row ~/ 3) * 3;
    final bc = (col ~/ 3) * 3;
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 3; c++) {
        if (grid[br + r][bc + c] == val) return false;
      }
    }
    return true;
  }
}
