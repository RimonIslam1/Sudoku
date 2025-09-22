import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_app/providers/game_provider.dart';
import 'package:sudoku_app/widgets/sudoku_grid.dart';
import 'package:sudoku_app/widgets/digit_row.dart';
import 'package:sudoku_app/widgets/action_buttons.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int? selectedRow;
  int? selectedCol;
  int? selectedDigit;
  bool notesMode = false;

  @override
  Widget build(BuildContext context) {
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
              // Timer Section
              _buildTimerSection(),
              const SizedBox(height: 16),

              // Sudoku Grid (65% of upper screen)
              Expanded(
                flex: 65,
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

                      // Fill cell with selected digit if available
                      if (selectedDigit != null) {
                        final gameProvider =
                            Provider.of<GameProvider>(context, listen: false);
                        if (notesMode) {
                          gameProvider.toggleCandidate(
                              row, col, selectedDigit!);
                        } else {
                          gameProvider.makeMove(row, col, selectedDigit!);
                        }
                        setState(() {
                          selectedDigit = null; // Clear selection after use
                        });
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Digit Buttons Row
              Container(
                height: 70,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Consumer<GameProvider>(
                  builder: (context, gameProvider, child) => DigitRow(
                    onDigitSelected: (digit) {
                      setState(() {
                        selectedDigit = digit;
                      });
                    },
                    selectedDigit: selectedDigit,
                    digitCounts: gameProvider.digitCounts,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ActionButtons(
                  onUndo: () {
                    final gameProvider =
                        Provider.of<GameProvider>(context, listen: false);
                    gameProvider.undoMove();
                    setState(() {
                      selectedDigit = null;
                    });
                  },
                  onHint: () {
                    final gameProvider =
                        Provider.of<GameProvider>(context, listen: false);
                    if (selectedRow != null && selectedCol != null) {
                      gameProvider.provideHintAt(selectedRow!, selectedCol!);
                    } else {
                      gameProvider.provideRandomHint();
                    }
                    setState(() {
                      selectedDigit = null;
                    });
                  },
                  onNotesToggle: () {
                    setState(() {
                      notesMode = !notesMode;
                      selectedDigit = null;
                    });
                  },
                  onClear: () {
                    if (selectedRow != null && selectedCol != null) {
                      final gameProvider =
                          Provider.of<GameProvider>(context, listen: false);
                      if (notesMode) {
                        gameProvider.clearCandidates(
                            selectedRow!, selectedCol!);
                      } else {
                        gameProvider.makeMove(selectedRow!, selectedCol!, 0);
                      }
                    }
                    setState(() {
                      selectedDigit = null;
                    });
                  },
                  notesMode: notesMode,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimerSection() {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
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
              // Timer
              Row(
                children: [
                  Icon(
                    Icons.timer,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    gameProvider.formattedTime,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),

              // Game Status
              Row(
                children: [
                  Text(
                    'Moves: ${gameProvider.moveHistory.length}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
                  ),
                  if (gameProvider.isGameComplete) ...[
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Complete!',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final gameProvider = Provider.of<GameProvider>(context);
    if (gameProvider.mistakes >= 3) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showGameOverDialog(context);
      });
    }
  }

  void _showGameOverDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: const Text('You made 3 mistakes. The game will restart.'),
        actions: [
          TextButton(
            onPressed: () {
              final gameProvider = Provider.of<GameProvider>(context, listen: false);
              gameProvider.resetGame(); // Reset the game first
              Navigator.of(context).pop(); // Then close the dialog
              // No need for setState or extra logic here
            },
            child: const Text('Restart'),
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
          content:
              const Text('Are you sure you want to reset the current game?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final gameProvider =
                    Provider.of<GameProvider>(context, listen: false);
                gameProvider.resetGame();
                setState(() {
                  selectedRow = null;
                  selectedCol = null;
                  selectedDigit = null;
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
