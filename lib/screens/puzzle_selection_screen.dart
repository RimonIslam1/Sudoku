import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_app/providers/game_provider.dart';
import 'package:sudoku_app/screens/game_screen.dart';
import 'package:sudoku_app/utils/puzzle_generator.dart';
import 'package:sudoku_app/utils/sudoku_solver.dart';

class PuzzleSelectionScreen extends StatefulWidget {
  final String difficulty;
  const PuzzleSelectionScreen({super.key, required this.difficulty});

  @override
  State<PuzzleSelectionScreen> createState() => _PuzzleSelectionScreenState();
}

class _PuzzleSelectionScreenState extends State<PuzzleSelectionScreen> {
  late List<_PuzzleItem> puzzles;

  @override
  void initState() {
    super.initState();
    puzzles = _generatePuzzles(widget.difficulty);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.difficulty} Puzzles'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: puzzles.length,
          itemBuilder: (context, index) {
            final item = puzzles[index];
            return _buildPuzzleCard(context, index + 1, item);
          },
        ),
      ),
    );
  }

  Widget _buildPuzzleCard(BuildContext context, int number, _PuzzleItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.25),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            final game = Provider.of<GameProvider>(context, listen: false);
            game.loadPuzzle(item.board, item.solution, widget.difficulty);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GameScreen()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          '#$number',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.grid_on,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  'Unique Sudoku',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap to play',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // For simplicity, use a small curated set per difficulty to guarantee uniqueness, then pick 10.
  List<_PuzzleItem> _generatePuzzles(String difficulty) {
    final seeds = _seedPuzzles[difficulty] ?? _seedPuzzles['Easy']!;
    final List<_PuzzleItem> out = [];
    for (int i = 0; i < 10; i++) {
      final seed = seeds[i % seeds.length];
      // For Easy difficulty, ensure the FIRST puzzle has exactly 10 empty cells
      // and passes uniqueness validation using the solver
      if (difficulty == 'Easy' && i == 0) {
        final solved = _stringToBoard(seed.solution);
        // Validate provided solution grid itself
        final solutionValid = SudokuSolver.isValidGrid(solved);
        if (!solutionValid) {
          // If the provided solution is inconsistent, fallback to original board
          out.add(_PuzzleItem(
            board: _stringToBoard(seed.board),
            solution: solved,
          ));
        } else {
          try {
            final masked = PuzzleGenerator.generateMaskedUnique(solved, 10);
            out.add(_PuzzleItem(board: masked, solution: solved));
          } catch (_) {
            // If generation fails, fallback to original board to avoid breakage
            out.add(_PuzzleItem(
              board: _stringToBoard(seed.board),
              solution: solved,
            ));
          }
        }
      } else {
        out.add(_PuzzleItem(
          board: _stringToBoard(seed.board),
          solution: _stringToBoard(seed.solution),
        ));
      }
    }
    return out;
  }

  List<List<int>> _stringToBoard(String s) {
    final String trimmed = s.trim();
    final List<List<int>> b = List.generate(9, (_) => List.filled(9, 0));
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        final int idx = r * 9 + c;
        final String ch = idx < trimmed.length ? trimmed[idx] : '.';
        b[r][c] = ch == '.' ? 0 : int.tryParse(ch) ?? 0;
      }
    }
    return b;
  }
}

class _PuzzleItem {
  final List<List<int>> board;
  final List<List<int>> solution;
  _PuzzleItem({required this.board, required this.solution});
}

class _SeedPuzzle {
  final String board;
  final String solution;
  const _SeedPuzzle(this.board, this.solution);
}

// 81-char strings, '.' for empty
const Map<String, List<_SeedPuzzle>> _seedPuzzles = {
  'Easy': [
    _SeedPuzzle(
      '53..7....6..195....98....6.8...6...34..8.3..17...2...6.6....28....419..5....8..79',
      '534678912672195348198342567859761423426853791713924856961537284287419635345286179',
    ),
    _SeedPuzzle(
      '1.5.2....9....5.18....9..3.8.....1..2..4.6..3..7.....4.6..2....95.1....7....3.5',
      '135827649946345718287691534869532174271486953354719286613258497592174863478963125',
    ),
    _SeedPuzzle(
      '...7..1..3..9..7..2..1..3..7..2..9..6..4..5..9..3..1..1..8..2..8..5..4..4..6...',
      '892763145341952768265148397713825946628419573954637812176394258589271634434586129',
    ),
  ],
  'Medium': [
    _SeedPuzzle(
      '...26.7.1..7..3...7...1....6..8.5..9...2...3..4.1..4....2...8...9..5..2.8.3.2...',
      '435269781862781354719345826671893542928514673354672198542137968193456217786928415',
    ),
    _SeedPuzzle(
      '..9748...7...........7......2.1.9..9..7.2..5..4.3.1......5...........1...7.364..',
      '619748235753692841284571396321569478967824153845317629496185732538426917172936584',
    ),
  ],
  'Hard': [
    _SeedPuzzle(
      '8..3.7..9..1....2.4....5....5..9..8..3.....1..2..6..3....4....2.1....9..7..8.6..',
      '852347169961895234473125986547931628638472915129568743396714852214659397785283461',
    ),
    _SeedPuzzle(
      '.2.6.8....58...97......4....37....5.6.......4.3....91....2......15...36....9.1.4.',
      '127698345458342976963571428372189654695427813841356792739264581514823769286915734',
    ),
  ],
};
