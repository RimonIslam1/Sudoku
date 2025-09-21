import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_app/providers/game_provider.dart';

class SudokuGrid extends StatelessWidget {
  final int? selectedRow;
  final int? selectedCol;
  final Function(int, int) onCellSelected;

  const SudokuGrid({
    super.key,
    this.selectedRow,
    this.selectedCol,
    required this.onCellSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        // Debug: Check if board has data
        bool hasData =
            gameProvider.board.any((row) => row.any((cell) => cell != 0));
        print('SudokuGrid - Board has data: $hasData');

        // If no data, show a test grid
        if (!hasData) {
          print('No data in board, showing test grid');
        }

        return Container(
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
          child: AspectRatio(
            aspectRatio: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: List.generate(9, (row) {
                  return Expanded(
                    child: Row(
                      children: List.generate(9, (col) {
                        return Expanded(
                          child: _buildCell(context, row, col, gameProvider),
                        );
                      }),
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCell(
      BuildContext context, int row, int col, GameProvider gameProvider) {
    final value = gameProvider.board[row][col];
    final isOriginal = gameProvider.isOriginalCell(row, col);
    final isSelected = selectedRow == row && selectedCol == col;
    final isInSameRow = selectedRow == row;
    final isInSameCol = selectedCol == col;
    final isInSameBox = _isInSameBox(row, col, selectedRow, selectedCol);
    final cellCandidates = gameProvider.getCandidates(row, col);

    Color backgroundColor = Colors.white;
    if (isSelected) {
      backgroundColor = Theme.of(context).colorScheme.primary.withOpacity(0.3);
    } else if (isInSameRow || isInSameCol || isInSameBox) {
      backgroundColor = Theme.of(context).colorScheme.primary.withOpacity(0.1);
    }

    final bool valid = gameProvider.isCellValid(row, col);
    Color cellColor;
    if (!valid && gameProvider.board[row][col] != 0) {
      cellColor = Colors.red.withOpacity(0.5); // Invalid move
    } else if (valid && gameProvider.board[row][col] != 0) {
      cellColor = Colors.green.withOpacity(0.3); // Valid move
    } else {
      cellColor = Colors.white; // Default
    }

    return Container(
      margin: EdgeInsets.only(
        right: (col + 1) % 3 == 0 ? 2 : 0,
        bottom: (row + 1) % 3 == 0 ? 2 : 0,
      ),
      decoration: BoxDecoration(
        color: cellColor,
        border: Border(
          right: BorderSide(
            color: (col + 1) % 3 == 0
                ? Colors.black
                : Colors.grey.withOpacity(0.3),
            width: (col + 1) % 3 == 0 ? 2 : 1,
          ),
          bottom: BorderSide(
            color: (row + 1) % 3 == 0
                ? Colors.black
                : Colors.grey.withOpacity(0.3),
            width: (row + 1) % 3 == 0 ? 2 : 1,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onCellSelected(row, col),
          child: Center(
            child: value == 0
                ? _buildCandidatesView(context, cellCandidates)
                : Text(
                    value.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                          isOriginal ? FontWeight.bold : FontWeight.normal,
                      color: isOriginal
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  bool _isInSameBox(int row1, int col1, int? row2, int? col2) {
    if (row2 == null || col2 == null) return false;

    int boxRow1 = row1 ~/ 3;
    int boxCol1 = col1 ~/ 3;
    int boxRow2 = row2 ~/ 3;
    int boxCol2 = col2 ~/ 3;

    return boxRow1 == boxRow2 && boxCol1 == boxCol2;
  }

  Widget _buildCandidatesView(BuildContext context, Set<int> candidates) {
    // 3x3 tiny grid of candidate digits 1-9
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (r) {
          return Expanded(
            child: Row(
              children: List.generate(3, (c) {
                final digit = r * 3 + c + 1;
                final present = candidates.contains(digit);
                return Expanded(
                  child: Center(
                    child: present
                        ? Text(
                            '$digit',
                            style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                );
              }),
            ),
          );
        }),
      ),
    );
  }
}
