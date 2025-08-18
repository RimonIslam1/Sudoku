import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_app/providers/game_provider.dart';
import 'package:sudoku_app/widgets/sudoku_grid.dart';
import 'package:sudoku_app/widgets/number_pad.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int? selectedRow;
  int? selectedCol;

  @override
  Widget build(BuildContext context) {
    // Debug: Print current game state
    final gameProvider = Provider.of<GameProvider>(context);
    print('Game Screen - Difficulty: ${gameProvider.difficulty}');
    print('Game Screen - Board has data: ${gameProvider.board.any((row) => row.any((cell) => cell != 0))}');
    
    return Scaffold(
      appBar: AppBar(
        title: Consumer<GameProvider>(
          builder: (context, gameProvider, child) {
            return Text('${gameProvider.difficulty} Sudoku');
          },
        ),
        centerTitle: true,
        actions: [
          Consumer<GameProvider>(
            builder: (context, gameProvider, child) {
              return IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  _showResetDialog(context);
                },
                tooltip: 'Reset Game',
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.primary.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Game Info
              _buildGameInfo(),
              const SizedBox(height: 20),
              // Sudoku Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SudokuGrid(
                    selectedRow: selectedRow,
                    selectedCol: selectedCol,
                    onCellSelected: (row, col) {
                      setState(() {
                        selectedRow = row;
                        selectedCol = col;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Number Pad
              NumberPad(
                onNumberSelected: (number) {
                  if (selectedRow != null && selectedCol != null) {
                    final gameProvider = Provider.of<GameProvider>(context, listen: false);
                    gameProvider.makeMove(selectedRow!, selectedCol!, number);
                  }
                },
                onClear: () {
                  if (selectedRow != null && selectedCol != null) {
                    final gameProvider = Provider.of<GameProvider>(context, listen: false);
                    gameProvider.makeMove(selectedRow!, selectedCol!, 0);
                  }
                },
              ),
              const SizedBox(height: 20),
              // Action Buttons
              _buildActionButtons(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameInfo() {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Difficulty: ${gameProvider.difficulty}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Moves: ${gameProvider.moveHistory.length}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              if (gameProvider.isGameComplete)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 16,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Complete!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Consumer<GameProvider>(
              builder: (context, gameProvider, child) {
                return ElevatedButton.icon(
                  onPressed: gameProvider.moveHistory.isEmpty
                      ? null
                      : () => gameProvider.undoMove(),
                  icon: const Icon(Icons.undo),
                  label: const Text('Undo'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  selectedRow = null;
                  selectedCol = null;
                });
              },
              icon: const Icon(Icons.clear),
              label: const Text('Clear Selection'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Game'),
          content: const Text('Are you sure you want to reset the current game?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final gameProvider = Provider.of<GameProvider>(context, listen: false);
                gameProvider.resetGame();
                setState(() {
                  selectedRow = null;
                  selectedCol = null;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }
}
