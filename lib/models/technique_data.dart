
/// Represents a point on the Sudoku grid
class GridPoint {
  final int row;
  final int col;
  const GridPoint(this.row, this.col);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GridPoint && row == other.row && col == other.col;

  @override
  int get hashCode => Object.hash(row, col);
}

/// Represents a step in a technique demonstration
class TechniqueStep {
  final String description;
  final String? explanation;
  final List<List<int>> grid; // 9x9 grid, 0 means empty
  final Map<GridPoint, Set<int>> candidates; // candidate digits for empty cells
  final List<GridPoint> highlightedCells; // cells to highlight
  final List<GridPoint> affectedCells; // cells affected by eliminations
  final List<GridPoint> newDigits; // newly placed digits
  final List<GridPoint> eliminatedCandidates; // candidates to eliminate
  final String? animationType; // 'highlight', 'eliminate', 'place', 'chain'
  final Duration? animationDuration;

  const TechniqueStep({
    required this.description,
    this.explanation,
    required this.grid,
    this.candidates = const {},
    this.highlightedCells = const [],
    this.affectedCells = const [],
    this.newDigits = const [],
    this.eliminatedCandidates = const [],
    this.animationType,
    this.animationDuration,
  });
}

/// Represents a complete solving technique
class SolvingTechnique {
  final String name;
  final String description;
  final String difficulty; // 'Easy', 'Medium', 'Hard', 'Expert'
  final List<String> prerequisites;
  final List<TechniqueStep> steps;
  final List<String> tips;
  final List<String> examples;
  final String category; // 'Basic', 'Intermediate', 'Advanced', 'Expert'

  const SolvingTechnique({
    required this.name,
    required this.description,
    required this.difficulty,
    required this.prerequisites,
    required this.steps,
    required this.tips,
    required this.examples,
    required this.category,
  });
}

/// Data class containing all solving techniques
class TechniqueData {
  static final List<SolvingTechnique> techniques = [
    // Basic Techniques
    SolvingTechnique(
      name: 'Naked Single',
      description: 'A cell that has only one possible candidate.',
      difficulty: 'Easy',
      category: 'Basic',
      prerequisites: ['Basic Sudoku rules'],
      steps: [
        TechniqueStep(
          description: 'Look for empty cells with only one candidate.',
          explanation: 'When a cell has only one possible digit, it must be that digit.',
          grid: _createEmptyGrid(),
          candidates: {
            const GridPoint(4, 4): {1, 2, 3, 4, 5, 6, 7, 8, 9},
            const GridPoint(3, 3): {1, 2, 3, 4, 5, 6, 7, 8, 9},
            const GridPoint(5, 5): {1, 2, 3, 4, 5, 6, 7, 8, 9},
          },
          highlightedCells: [const GridPoint(4, 4)],
          animationType: 'highlight',
        ),
        TechniqueStep(
          description: 'Eliminate candidates based on existing digits in row, column, and box.',
          explanation: 'Remove candidates that already appear in the same row, column, or 3x3 box.',
          grid: _createEmptyGrid(),
          candidates: {
            const GridPoint(4, 4): {7}, // Only 7 remains
            const GridPoint(3, 3): {1, 2, 3, 4, 5, 6, 7, 8, 9},
            const GridPoint(5, 5): {1, 2, 3, 4, 5, 6, 7, 8, 9},
          },
          highlightedCells: [const GridPoint(4, 4)],
          animationType: 'eliminate',
        ),
        TechniqueStep(
          description: 'Place the digit in the cell.',
          explanation: 'Since only one candidate remains, place that digit.',
          grid: _createGridWithValue(4, 4, 7),
          candidates: {
            const GridPoint(3, 3): {1, 2, 3, 4, 5, 6, 7, 8, 9},
            const GridPoint(5, 5): {1, 2, 3, 4, 5, 6, 7, 8, 9},
          },
          highlightedCells: [const GridPoint(4, 4)],
          newDigits: [const GridPoint(4, 4)],
          animationType: 'place',
        ),
      ],
      tips: [
        'Scan each empty cell and count its candidates.',
        'Look for cells with exactly one candidate.',
        'This is the most basic solving technique.',
      ],
      examples: [
        'If a cell can only contain the digit 5, place 5 in that cell.',
        'After eliminating candidates, if only one remains, place it.',
      ],
    ),

    SolvingTechnique(
      name: 'Hidden Single',
      description: 'A digit that can only go in one cell within a row, column, or box.',
      difficulty: 'Easy',
      category: 'Basic',
      prerequisites: ['Naked Single'],
      steps: [
        TechniqueStep(
          description: 'Look for a digit that appears in only one cell within a unit.',
          explanation: 'A unit is a row, column, or 3x3 box. If a digit can only go in one cell within a unit, place it there.',
          grid: _createEmptyGrid(),
          candidates: {
            const GridPoint(0, 0): {1, 2, 3, 4, 5, 6, 7, 8, 9},
            const GridPoint(0, 1): {1, 2, 3, 4, 5, 6, 7, 8, 9},
            const GridPoint(0, 2): {1, 2, 3, 4, 5, 6, 7, 8, 9},
            const GridPoint(0, 3): {1, 2, 3, 4, 5, 6, 7, 8, 9},
            const GridPoint(0, 4): {1, 2, 3, 4, 5, 6, 7, 8, 9},
            const GridPoint(0, 5): {1, 2, 3, 4, 5, 6, 7, 8, 9},
            const GridPoint(0, 6): {1, 2, 3, 4, 5, 6, 7, 8, 9},
            const GridPoint(0, 7): {1, 2, 3, 4, 5, 6, 7, 8, 9},
            const GridPoint(0, 8): {1, 2, 3, 4, 5, 6, 7, 8, 9},
          },
          highlightedCells: [const GridPoint(0, 0), const GridPoint(0, 1), const GridPoint(0, 2)],
          animationType: 'highlight',
        ),
        TechniqueStep(
          description: 'Eliminate candidates based on existing digits in the row.',
          explanation: 'Remove candidates that already appear in the same row.',
          grid: _createEmptyGrid(),
          candidates: {
            const GridPoint(0, 0): {5}, // Only 5 can go here in this row
            const GridPoint(0, 1): {1, 2, 3, 4, 6, 7, 8, 9},
            const GridPoint(0, 2): {1, 2, 3, 4, 6, 7, 8, 9},
            const GridPoint(0, 3): {1, 2, 3, 4, 6, 7, 8, 9},
            const GridPoint(0, 4): {1, 2, 3, 4, 6, 7, 8, 9},
            const GridPoint(0, 5): {1, 2, 3, 4, 6, 7, 8, 9},
            const GridPoint(0, 6): {1, 2, 3, 4, 6, 7, 8, 9},
            const GridPoint(0, 7): {1, 2, 3, 4, 6, 7, 8, 9},
            const GridPoint(0, 8): {1, 2, 3, 4, 6, 7, 8, 9},
          },
          highlightedCells: [const GridPoint(0, 0)],
          animationType: 'eliminate',
        ),
        TechniqueStep(
          description: 'Place the hidden single digit.',
          explanation: 'Since 5 can only go in cell (0,0) in this row, place it there.',
          grid: _createGridWithValue(0, 0, 5),
          candidates: {
            const GridPoint(0, 1): {1, 2, 3, 4, 6, 7, 8, 9},
            const GridPoint(0, 2): {1, 2, 3, 4, 6, 7, 8, 9},
            const GridPoint(0, 3): {1, 2, 3, 4, 6, 7, 8, 9},
            const GridPoint(0, 4): {1, 2, 3, 4, 6, 7, 8, 9},
            const GridPoint(0, 5): {1, 2, 3, 4, 6, 7, 8, 9},
            const GridPoint(0, 6): {1, 2, 3, 4, 6, 7, 8, 9},
            const GridPoint(0, 7): {1, 2, 3, 4, 6, 7, 8, 9},
            const GridPoint(0, 8): {1, 2, 3, 4, 6, 7, 8, 9},
          },
          highlightedCells: [const GridPoint(0, 0)],
          newDigits: [const GridPoint(0, 0)],
          animationType: 'place',
        ),
      ],
      tips: [
        'Scan each row, column, and box for digits that appear in only one cell.',
        'Look for digits that are missing from most cells in a unit.',
        'This technique is more powerful than naked single.',
      ],
      examples: [
        'If digit 3 can only go in one cell in a row, place it there.',
        'After eliminating candidates, if a digit appears in only one cell in a unit, place it.',
      ],
    ),

    // Y-Wing example as requested
    SolvingTechnique(
      name: 'Y-Wing',
      description: 'A technique using three cells from three different 3x3 blocks to eliminate candidates.',
      difficulty: 'Hard',
      category: 'Advanced',
      prerequisites: ['XY-Wing', 'Basic elimination techniques'],
      steps: [
        TechniqueStep(
          description: 'Find three cells from three different 3x3 blocks that form a Y-Wing pattern.',
          explanation: 'The Y-Wing consists of a pivot cell and two wing cells. The pivot shares one candidate with each wing, and the wings share a common candidate.',
          grid: _createEmptyGrid(),
          candidates: {
            const GridPoint(1, 1): {2, 8}, // Pivot cell
            const GridPoint(0, 1): {2, 5}, // Wing 1
            const GridPoint(2, 2): {8, 5}, // Wing 2
            const GridPoint(1, 2): {1, 3, 4, 5, 6, 7, 9}, // Target cell
          },
          highlightedCells: [const GridPoint(1, 1), const GridPoint(0, 1), const GridPoint(2, 2)],
          animationType: 'highlight',
        ),
        TechniqueStep(
          description: 'Identify the shared candidate between the wings.',
          explanation: 'The wings share candidate 5. If the pivot is 2, wing 1 must be 5. If the pivot is 8, wing 2 must be 5. Either way, 5 must be in one of the wings.',
          grid: _createEmptyGrid(),
          candidates: {
            const GridPoint(1, 1): {2, 8}, // Pivot cell
            const GridPoint(0, 1): {2, 5}, // Wing 1
            const GridPoint(2, 2): {8, 5}, // Wing 2
            const GridPoint(1, 2): {1, 3, 4, 5, 6, 7, 9}, // Target cell
          },
          highlightedCells: [const GridPoint(0, 1), const GridPoint(2, 2)],
          animationType: 'highlight',
        ),
        TechniqueStep(
          description: 'Eliminate the shared candidate from cells that see both wings.',
          explanation: 'Since 5 must be in one of the wings, it can be eliminated from any cell that sees both wings (like the target cell).',
          grid: _createEmptyGrid(),
          candidates: {
            const GridPoint(1, 1): {2, 8}, // Pivot cell
            const GridPoint(0, 1): {2, 5}, // Wing 1
            const GridPoint(2, 2): {8, 5}, // Wing 2
            const GridPoint(1, 2): {1, 3, 4, 6, 7, 9}, // Target cell - 5 eliminated
          },
          highlightedCells: [const GridPoint(1, 1), const GridPoint(0, 1), const GridPoint(2, 2)],
          affectedCells: [const GridPoint(1, 2)],
          eliminatedCandidates: [const GridPoint(1, 2)],
          animationType: 'eliminate',
        ),
      ],
      tips: [
        'Look for three cells from three different 3x3 blocks.',
        'The pivot should share one candidate with each wing.',
        'The wings should share a common candidate.',
        'Eliminate the shared candidate from cells that see both wings.',
      ],
      examples: [
        'Y-Wing with pivot {2,8}, wing 1 {2,5}, wing 2 {8,5} eliminates 5 from cells seeing both wings.',
        'The key insight is that 5 must be in one of the wings, so it can be eliminated from their common peers.',
      ],
    ),

    // X-Wing
    SolvingTechnique(
      name: 'X-Wing',
      description: 'A pattern where a digit appears in exactly two cells in two rows (or columns), forming a rectangle.',
      difficulty: 'Medium',
      category: 'Intermediate',
      prerequisites: ['Basic elimination techniques'],
      steps: [
        TechniqueStep(
          description: 'Find two rows where a digit appears in exactly two cells.',
          explanation: 'Look for a digit that appears in exactly two cells in two different rows, and these cells are in the same columns.',
          grid: _createEmptyGrid(),
          candidates: {
            const GridPoint(1, 2): {7}, // Row 1, Column 2
            const GridPoint(1, 6): {7}, // Row 1, Column 6
            const GridPoint(5, 2): {7}, // Row 5, Column 2
            const GridPoint(5, 6): {7}, // Row 5, Column 6
          },
          highlightedCells: [const GridPoint(1, 2), const GridPoint(1, 6)],
          animationType: 'highlight',
        ),
        TechniqueStep(
          description: 'Verify the same digit appears in the same columns in another row.',
          explanation: 'Check that the same digit appears in the same two columns in a different row, forming a rectangle.',
          grid: _createEmptyGrid(),
          candidates: {
            const GridPoint(1, 2): {7}, // Row 1, Column 2
            const GridPoint(1, 6): {7}, // Row 1, Column 6
            const GridPoint(5, 2): {7}, // Row 5, Column 2
            const GridPoint(5, 6): {7}, // Row 5, Column 6
          },
          highlightedCells: [const GridPoint(5, 2), const GridPoint(5, 6)],
          animationType: 'highlight',
        ),
        TechniqueStep(
          description: 'Eliminate the digit from other cells in the same columns.',
          explanation: 'Since the digit must be in one of the two cells in each row, it can be eliminated from other cells in the same columns.',
          grid: _createEmptyGrid(),
          candidates: {
            const GridPoint(1, 2): {7}, // Row 1, Column 2
            const GridPoint(1, 6): {7}, // Row 1, Column 6
            const GridPoint(5, 2): {7}, // Row 5, Column 2
            const GridPoint(5, 6): {7}, // Row 5, Column 6
            // Other cells in columns 2 and 6 that had candidate 7
            const GridPoint(0, 2): {1, 2, 3, 4, 5, 6, 8, 9}, // 7 eliminated
            const GridPoint(2, 2): {1, 2, 3, 4, 5, 6, 8, 9}, // 7 eliminated
            const GridPoint(3, 2): {1, 2, 3, 4, 5, 6, 8, 9}, // 7 eliminated
            const GridPoint(4, 2): {1, 2, 3, 4, 5, 6, 8, 9}, // 7 eliminated
            const GridPoint(6, 2): {1, 2, 3, 4, 5, 6, 8, 9}, // 7 eliminated
            const GridPoint(7, 2): {1, 2, 3, 4, 5, 6, 8, 9}, // 7 eliminated
            const GridPoint(8, 2): {1, 2, 3, 4, 5, 6, 8, 9}, // 7 eliminated
            const GridPoint(0, 6): {1, 2, 3, 4, 5, 6, 8, 9}, // 7 eliminated
            const GridPoint(2, 6): {1, 2, 3, 4, 5, 6, 8, 9}, // 7 eliminated
            const GridPoint(3, 6): {1, 2, 3, 4, 5, 6, 8, 9}, // 7 eliminated
            const GridPoint(4, 6): {1, 2, 3, 4, 5, 6, 8, 9}, // 7 eliminated
            const GridPoint(6, 6): {1, 2, 3, 4, 5, 6, 8, 9}, // 7 eliminated
            const GridPoint(7, 6): {1, 2, 3, 4, 5, 6, 8, 9}, // 7 eliminated
            const GridPoint(8, 6): {1, 2, 3, 4, 5, 6, 8, 9}, // 7 eliminated
          },
          highlightedCells: [const GridPoint(1, 2), const GridPoint(1, 6), const GridPoint(5, 2), const GridPoint(5, 6)],
          affectedCells: [
            const GridPoint(0, 2), const GridPoint(2, 2), const GridPoint(3, 2), const GridPoint(4, 2),
            const GridPoint(6, 2), const GridPoint(7, 2), const GridPoint(8, 2),
            const GridPoint(0, 6), const GridPoint(2, 6), const GridPoint(3, 6), const GridPoint(4, 6),
            const GridPoint(6, 6), const GridPoint(7, 6), const GridPoint(8, 6),
          ],
          animationType: 'eliminate',
        ),
      ],
      tips: [
        'Look for digits that appear in exactly two cells in two rows.',
        'The cells must be in the same columns to form a rectangle.',
        'Eliminate the digit from other cells in the same columns.',
        'This technique also works with columns instead of rows.',
      ],
      examples: [
        'X-Wing on digit 7 in rows 1 and 5, columns 2 and 6, eliminates 7 from other cells in columns 2 and 6.',
        'The rectangle formed by the four cells creates a strong constraint on where 7 can be placed.',
      ],
    ),

    // Naked Pairs
    SolvingTechnique(
      name: 'Naked Pairs',
      description: 'Two cells in a unit that contain the same two candidates.',
      difficulty: 'Easy',
      category: 'Basic',
      prerequisites: ['Naked Single', 'Hidden Single'],
      steps: [
        TechniqueStep(
          description: 'Find two empty cells in the same unit (row, column, or box) that have exactly the same two candidates.',
          explanation: 'If two cells in a unit can only contain the same two digits, then those digits cannot appear in any other cell in that unit.',
          grid: _createEmptyGrid(),
          candidates: {
            const GridPoint(0, 0): {3, 7}, // Naked pair
            const GridPoint(0, 1): {3, 7}, // Naked pair
            const GridPoint(0, 2): {1, 2, 3, 4, 5, 6, 7, 8, 9}, // Other cells in row
            const GridPoint(0, 3): {1, 2, 3, 4, 5, 6, 7, 8, 9},
            const GridPoint(0, 4): {1, 2, 3, 4, 5, 6, 7, 8, 9},
            const GridPoint(0, 5): {1, 2, 3, 4, 5, 6, 7, 8, 9},
            const GridPoint(0, 6): {1, 2, 3, 4, 5, 6, 7, 8, 9},
            const GridPoint(0, 7): {1, 2, 3, 4, 5, 6, 7, 8, 9},
            const GridPoint(0, 8): {1, 2, 3, 4, 5, 6, 7, 8, 9},
          },
          highlightedCells: [const GridPoint(0, 0), const GridPoint(0, 1)],
          animationType: 'highlight',
        ),
        TechniqueStep(
          description: 'Eliminate the pair candidates from other cells in the same unit.',
          explanation: 'Since 3 and 7 must be in the two pair cells, they can be removed from all other cells in the same unit.',
          grid: _createEmptyGrid(),
          candidates: {
            const GridPoint(0, 0): {3, 7}, // Naked pair
            const GridPoint(0, 1): {3, 7}, // Naked pair
            const GridPoint(0, 2): {1, 2, 4, 5, 6, 8, 9}, // 3 and 7 eliminated
            const GridPoint(0, 3): {1, 2, 4, 5, 6, 8, 9}, // 3 and 7 eliminated
            const GridPoint(0, 4): {1, 2, 4, 5, 6, 8, 9}, // 3 and 7 eliminated
            const GridPoint(0, 5): {1, 2, 4, 5, 6, 8, 9}, // 3 and 7 eliminated
            const GridPoint(0, 6): {1, 2, 4, 5, 6, 8, 9}, // 3 and 7 eliminated
            const GridPoint(0, 7): {1, 2, 4, 5, 6, 8, 9}, // 3 and 7 eliminated
            const GridPoint(0, 8): {1, 2, 4, 5, 6, 8, 9}, // 3 and 7 eliminated
          },
          highlightedCells: [const GridPoint(0, 0), const GridPoint(0, 1)],
          affectedCells: [
            const GridPoint(0, 2), const GridPoint(0, 3), const GridPoint(0, 4),
            const GridPoint(0, 5), const GridPoint(0, 6), const GridPoint(0, 7), const GridPoint(0, 8),
          ],
          animationType: 'eliminate',
        ),
      ],
      tips: [
        'Look for cells with exactly two candidates that appear in pairs.',
        'The pair candidates can be eliminated from all other cells in the same unit.',
        'This technique works in rows, columns, and 3x3 boxes.',
      ],
      examples: [
        'If cells (0,0) and (0,1) both have candidates {3,7}, eliminate 3 and 7 from all other cells in row 0.',
        'Naked pairs are one of the most common solving techniques.',
      ],
    ),

    // Hidden Pairs
    SolvingTechnique(
      name: 'Hidden Pairs',
      description: 'Two digits that can only appear in two cells within a unit.',
      difficulty: 'Medium',
      category: 'Intermediate',
      prerequisites: ['Naked Pairs', 'Hidden Single'],
      steps: [
        TechniqueStep(
          description: 'Find two digits that appear in exactly two cells within a unit.',
          explanation: 'If two digits can only go in two specific cells within a unit, then those cells cannot contain any other digits.',
          grid: _createEmptyGrid(),
          candidates: {
            const GridPoint(0, 0): {1, 2, 3, 4, 5, 6, 7, 8, 9},
            const GridPoint(0, 1): {1, 2, 3, 4, 5, 6, 7, 8, 9},
            const GridPoint(0, 2): {1, 2, 3, 4, 5, 6, 7, 8, 9},
            const GridPoint(0, 3): {1, 2, 3, 4, 5, 6, 7, 8, 9},
            const GridPoint(0, 4): {1, 2, 3, 4, 5, 6, 7, 8, 9},
            const GridPoint(0, 5): {1, 2, 3, 4, 5, 6, 7, 8, 9},
            const GridPoint(0, 6): {1, 2, 3, 4, 5, 6, 7, 8, 9},
            const GridPoint(0, 7): {1, 2, 3, 4, 5, 6, 7, 8, 9},
            const GridPoint(0, 8): {1, 2, 3, 4, 5, 6, 7, 8, 9},
          },
          highlightedCells: [const GridPoint(0, 0), const GridPoint(0, 1)],
          animationType: 'highlight',
        ),
        TechniqueStep(
          description: 'Identify that digits 3 and 7 can only go in cells (0,0) and (0,1).',
          explanation: 'After analyzing the row, digits 3 and 7 can only appear in these two cells.',
          grid: _createEmptyGrid(),
          candidates: {
            const GridPoint(0, 0): {1, 2, 3, 4, 5, 6, 7, 8, 9}, // Can contain 3,7
            const GridPoint(0, 1): {1, 2, 3, 4, 5, 6, 7, 8, 9}, // Can contain 3,7
            const GridPoint(0, 2): {1, 2, 4, 5, 6, 8, 9}, // Cannot contain 3,7
            const GridPoint(0, 3): {1, 2, 4, 5, 6, 8, 9}, // Cannot contain 3,7
            const GridPoint(0, 4): {1, 2, 4, 5, 6, 8, 9}, // Cannot contain 3,7
            const GridPoint(0, 5): {1, 2, 4, 5, 6, 8, 9}, // Cannot contain 3,7
            const GridPoint(0, 6): {1, 2, 4, 5, 6, 8, 9}, // Cannot contain 3,7
            const GridPoint(0, 7): {1, 2, 4, 5, 6, 8, 9}, // Cannot contain 3,7
            const GridPoint(0, 8): {1, 2, 4, 5, 6, 8, 9}, // Cannot contain 3,7
          },
          highlightedCells: [const GridPoint(0, 0), const GridPoint(0, 1)],
          animationType: 'highlight',
        ),
        TechniqueStep(
          description: 'Remove all other candidates from the hidden pair cells.',
          explanation: 'Since 3 and 7 must be in these two cells, remove all other candidates from them.',
          grid: _createEmptyGrid(),
          candidates: {
            const GridPoint(0, 0): {3, 7}, // Only 3,7 remain
            const GridPoint(0, 1): {3, 7}, // Only 3,7 remain
            const GridPoint(0, 2): {1, 2, 4, 5, 6, 8, 9},
            const GridPoint(0, 3): {1, 2, 4, 5, 6, 8, 9},
            const GridPoint(0, 4): {1, 2, 4, 5, 6, 8, 9},
            const GridPoint(0, 5): {1, 2, 4, 5, 6, 8, 9},
            const GridPoint(0, 6): {1, 2, 4, 5, 6, 8, 9},
            const GridPoint(0, 7): {1, 2, 4, 5, 6, 8, 9},
            const GridPoint(0, 8): {1, 2, 4, 5, 6, 8, 9},
          },
          highlightedCells: [const GridPoint(0, 0), const GridPoint(0, 1)],
          affectedCells: [const GridPoint(0, 0), const GridPoint(0, 1)],
          animationType: 'eliminate',
        ),
      ],
      tips: [
        'Look for digits that appear in exactly two cells within a unit.',
        'Those two cells form a hidden pair and can only contain those digits.',
        'Remove all other candidates from the hidden pair cells.',
      ],
      examples: [
        'If digits 3 and 7 can only go in cells (0,0) and (0,1) in a row, remove all other candidates from those cells.',
        'Hidden pairs are more subtle than naked pairs but equally powerful.',
      ],
    ),

    // Pointing Pairs
    SolvingTechnique(
      name: 'Pointing Pairs',
      description: 'Candidates in a box that are confined to a single row or column.',
      difficulty: 'Easy',
      category: 'Basic',
      prerequisites: ['Basic elimination techniques'],
      steps: [
        TechniqueStep(
          description: 'Look for a digit that appears in only one row or column within a 3x3 box.',
          explanation: 'If a digit can only appear in one row or column within a box, it can be eliminated from the rest of that row or column.',
          grid: _createEmptyGrid(),
          candidates: {
            const GridPoint(0, 0): {5}, // Box 0,0 - digit 5 only in row 0
            const GridPoint(0, 1): {5}, // Box 0,0 - digit 5 only in row 0
            const GridPoint(0, 2): {5}, // Box 0,0 - digit 5 only in row 0
            const GridPoint(0, 3): {1, 2, 3, 4, 5, 6, 7, 8, 9}, // Row 0, other cells
            const GridPoint(0, 4): {1, 2, 3, 4, 5, 6, 7, 8, 9},
            const GridPoint(0, 5): {1, 2, 3, 4, 5, 6, 7, 8, 9},
            const GridPoint(0, 6): {1, 2, 3, 4, 5, 6, 7, 8, 9},
            const GridPoint(0, 7): {1, 2, 3, 4, 5, 6, 7, 8, 9},
            const GridPoint(0, 8): {1, 2, 3, 4, 5, 6, 7, 8, 9},
          },
          highlightedCells: [const GridPoint(0, 0), const GridPoint(0, 1), const GridPoint(0, 2)],
          animationType: 'highlight',
        ),
        TechniqueStep(
          description: 'Eliminate the digit from other cells in the same row outside the box.',
          explanation: 'Since 5 must be in the top-left box and only appears in row 0, it can be eliminated from the rest of row 0.',
          grid: _createEmptyGrid(),
          candidates: {
            const GridPoint(0, 0): {5}, // Box 0,0 - digit 5 only in row 0
            const GridPoint(0, 1): {5}, // Box 0,0 - digit 5 only in row 0
            const GridPoint(0, 2): {5}, // Box 0,0 - digit 5 only in row 0
            const GridPoint(0, 3): {1, 2, 3, 4, 6, 7, 8, 9}, // 5 eliminated
            const GridPoint(0, 4): {1, 2, 3, 4, 6, 7, 8, 9}, // 5 eliminated
            const GridPoint(0, 5): {1, 2, 3, 4, 6, 7, 8, 9}, // 5 eliminated
            const GridPoint(0, 6): {1, 2, 3, 4, 6, 7, 8, 9}, // 5 eliminated
            const GridPoint(0, 7): {1, 2, 3, 4, 6, 7, 8, 9}, // 5 eliminated
            const GridPoint(0, 8): {1, 2, 3, 4, 6, 7, 8, 9}, // 5 eliminated
          },
          highlightedCells: [const GridPoint(0, 0), const GridPoint(0, 1), const GridPoint(0, 2)],
          affectedCells: [
            const GridPoint(0, 3), const GridPoint(0, 4), const GridPoint(0, 5),
            const GridPoint(0, 6), const GridPoint(0, 7), const GridPoint(0, 8),
          ],
          animationType: 'eliminate',
        ),
      ],
      tips: [
        'Scan each 3x3 box for digits that appear in only one row or column.',
        'Eliminate those digits from the rest of the row or column outside the box.',
        'This technique works both ways: box to row/column and row/column to box.',
      ],
      examples: [
        'If digit 5 only appears in row 0 within the top-left box, eliminate 5 from the rest of row 0.',
        'Pointing pairs help reduce candidates in intersecting units.',
      ],
    ),

    // XY-Wing
    SolvingTechnique(
      name: 'XY-Wing',
      description: 'A pivot cell with two candidates and two pincer cells that share candidates.',
      difficulty: 'Hard',
      category: 'Advanced',
      prerequisites: ['Basic elimination techniques', 'Candidate notation'],
      steps: [
        TechniqueStep(
          description: 'Find a pivot cell with exactly two candidates (e.g., {2,8}).',
          explanation: 'The pivot cell must have exactly two candidates and be connected to two pincer cells.',
          grid: _createEmptyGrid(),
          candidates: {
            const GridPoint(3, 3): {2, 8}, // Pivot cell
            const GridPoint(2, 3): {2, 5}, // Pincer 1
            const GridPoint(4, 5): {8, 5}, // Pincer 2
            const GridPoint(3, 5): {1, 3, 4, 5, 6, 7, 9}, // Target cell
          },
          highlightedCells: [const GridPoint(3, 3)],
          animationType: 'highlight',
        ),
        TechniqueStep(
          description: 'Find two pincer cells that share one candidate each with the pivot.',
          explanation: 'Pincer 1 shares candidate 2 with pivot, pincer 2 shares candidate 8 with pivot. Both pincers share candidate 5.',
          grid: _createEmptyGrid(),
          candidates: {
            const GridPoint(3, 3): {2, 8}, // Pivot cell
            const GridPoint(2, 3): {2, 5}, // Pincer 1
            const GridPoint(4, 5): {8, 5}, // Pincer 2
            const GridPoint(3, 5): {1, 3, 4, 5, 6, 7, 9}, // Target cell
          },
          highlightedCells: [const GridPoint(3, 3), const GridPoint(2, 3), const GridPoint(4, 5)],
          animationType: 'highlight',
        ),
        TechniqueStep(
          description: 'Eliminate the shared candidate from cells that see both pincers.',
          explanation: 'Since 5 must be in one of the pincers, it can be eliminated from any cell that sees both pincers (like the target cell).',
          grid: _createEmptyGrid(),
          candidates: {
            const GridPoint(3, 3): {2, 8}, // Pivot cell
            const GridPoint(2, 3): {2, 5}, // Pincer 1
            const GridPoint(4, 5): {8, 5}, // Pincer 2
            const GridPoint(3, 5): {1, 3, 4, 6, 7, 9}, // Target cell - 5 eliminated
          },
          highlightedCells: [const GridPoint(3, 3), const GridPoint(2, 3), const GridPoint(4, 5)],
          affectedCells: [const GridPoint(3, 5)],
          animationType: 'eliminate',
        ),
      ],
      tips: [
        'Look for a bi-value pivot cell connected to two bi-value pincer cells.',
        'The pincers must share a common candidate that can be eliminated.',
        'The target cell must see both pincers.',
      ],
      examples: [
        'XY-Wing with pivot {2,8}, pincer 1 {2,5}, pincer 2 {8,5} eliminates 5 from cells seeing both pincers.',
        'The key insight is that 5 must be in one of the pincers, so it can be eliminated from their common peers.',
      ],
    ),

    // Swordfish
    SolvingTechnique(
      name: 'Swordfish',
      description: 'A generalization of X-Wing using three rows and three columns.',
      difficulty: 'Hard',
      category: 'Advanced',
      prerequisites: ['X-Wing', 'Advanced elimination techniques'],
      steps: [
        TechniqueStep(
          description: 'Find three rows where a digit appears in exactly three columns.',
          explanation: 'Look for a digit that appears in exactly three cells in three different rows, and these cells are in the same three columns.',
          grid: _createEmptyGrid(),
          candidates: {
            const GridPoint(0, 1): {2}, // Row 0, Column 1
            const GridPoint(0, 4): {2}, // Row 0, Column 4
            const GridPoint(0, 7): {2}, // Row 0, Column 7
            const GridPoint(3, 1): {2}, // Row 3, Column 1
            const GridPoint(3, 4): {2}, // Row 3, Column 4
            const GridPoint(3, 7): {2}, // Row 3, Column 7
            const GridPoint(6, 1): {2}, // Row 6, Column 1
            const GridPoint(6, 4): {2}, // Row 6, Column 4
            const GridPoint(6, 7): {2}, // Row 6, Column 7
          },
          highlightedCells: [const GridPoint(0, 1), const GridPoint(0, 4), const GridPoint(0, 7)],
          animationType: 'highlight',
        ),
        TechniqueStep(
          description: 'Verify the same digit appears in the same columns in the other two rows.',
          explanation: 'Check that the same digit appears in the same three columns in the other two rows, forming a Swordfish pattern.',
          grid: _createEmptyGrid(),
          candidates: {
            const GridPoint(0, 1): {2}, const GridPoint(0, 4): {2}, const GridPoint(0, 7): {2},
            const GridPoint(3, 1): {2}, const GridPoint(3, 4): {2}, const GridPoint(3, 7): {2},
            const GridPoint(6, 1): {2}, const GridPoint(6, 4): {2}, const GridPoint(6, 7): {2},
          },
          highlightedCells: [
            const GridPoint(0, 1), const GridPoint(0, 4), const GridPoint(0, 7),
            const GridPoint(3, 1), const GridPoint(3, 4), const GridPoint(3, 7),
            const GridPoint(6, 1), const GridPoint(6, 4), const GridPoint(6, 7),
          ],
          animationType: 'highlight',
        ),
        TechniqueStep(
          description: 'Eliminate the digit from other cells in the same columns.',
          explanation: 'Since the digit must be in one of the three cells in each row, it can be eliminated from other cells in the same columns.',
          grid: _createEmptyGrid(),
          candidates: {
            const GridPoint(0, 1): {2}, const GridPoint(0, 4): {2}, const GridPoint(0, 7): {2},
            const GridPoint(3, 1): {2}, const GridPoint(3, 4): {2}, const GridPoint(3, 7): {2},
            const GridPoint(6, 1): {2}, const GridPoint(6, 4): {2}, const GridPoint(6, 7): {2},
            // Other cells in columns 1, 4, 7 that had candidate 2
            const GridPoint(1, 1): {1, 3, 4, 5, 6, 7, 8, 9}, // 2 eliminated
            const GridPoint(2, 1): {1, 3, 4, 5, 6, 7, 8, 9}, // 2 eliminated
            const GridPoint(4, 1): {1, 3, 4, 5, 6, 7, 8, 9}, // 2 eliminated
            const GridPoint(5, 1): {1, 3, 4, 5, 6, 7, 8, 9}, // 2 eliminated
            const GridPoint(7, 1): {1, 3, 4, 5, 6, 7, 8, 9}, // 2 eliminated
            const GridPoint(8, 1): {1, 3, 4, 5, 6, 7, 8, 9}, // 2 eliminated
          },
          highlightedCells: [
            const GridPoint(0, 1), const GridPoint(0, 4), const GridPoint(0, 7),
            const GridPoint(3, 1), const GridPoint(3, 4), const GridPoint(3, 7),
            const GridPoint(6, 1), const GridPoint(6, 4), const GridPoint(6, 7),
          ],
          affectedCells: [
            const GridPoint(1, 1), const GridPoint(2, 1), const GridPoint(4, 1),
            const GridPoint(5, 1), const GridPoint(7, 1), const GridPoint(8, 1),
          ],
          animationType: 'eliminate',
        ),
      ],
      tips: [
        'Look for digits that appear in exactly three cells in three rows.',
        'The cells must be in the same three columns to form a Swordfish.',
        'Eliminate the digit from other cells in the same columns.',
        'This technique also works with columns instead of rows.',
      ],
      examples: [
        'Swordfish on digit 2 in rows 0, 3, 6 and columns 1, 4, 7 eliminates 2 from other cells in columns 1, 4, 7.',
        'The pattern forms a 3x3 grid of candidates that creates strong constraints.',
      ],
    ),

    // Add more techniques as needed...
  ];

  static List<List<int>> _createEmptyGrid() {
    return List.generate(9, (_) => List.filled(9, 0));
  }

  static List<List<int>> _createGridWithValue(int row, int col, int value) {
    final grid = _createEmptyGrid();
    grid[row][col] = value;
    return grid;
  }

  static SolvingTechnique? getTechniqueByName(String name) {
    try {
      return techniques.firstWhere((technique) => technique.name == name);
    } catch (e) {
      return null;
    }
  }

  static List<SolvingTechnique> getTechniquesByCategory(String category) {
    return techniques.where((technique) => technique.category == category).toList();
  }

  static List<SolvingTechnique> getTechniquesByDifficulty(String difficulty) {
    return techniques.where((technique) => technique.difficulty == difficulty).toList();
  }
}
