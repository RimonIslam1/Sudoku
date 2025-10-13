import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_app/providers/game_provider.dart';
import 'package:sudoku_app/utils/highlighting_constants.dart';

class SudokuGrid extends StatefulWidget {
  final Function(int, int) onCellSelected;

  const SudokuGrid({
    super.key,
    required this.onCellSelected,
  });

  @override
  State<SudokuGrid> createState() => _SudokuGridState();
}

class _SudokuGridState extends State<SudokuGrid> {
  @override
  void initState() {
    super.initState();
  }

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
    final isSelected = gameProvider.isCellSelected(row, col);
    final isInSelectedRow = gameProvider.isInSelectedRow(row);
    final isInSelectedCol = gameProvider.isInSelectedColumn(col);
    final isInSelectedBox = gameProvider.isInSelectedBox(row, col);
    final hasSameDigit = gameProvider.hasSameDigit(row, col);
    final cellCandidates = gameProvider.getCandidates(row, col);

    // Determine background color priority:
    // selected > same-digit > row/col/box > default
    Color backgroundColor = Colors.white;
    if (isSelected) {
      backgroundColor = HighlightingConstants.selectedCellColor;
    } else if (hasSameDigit) {
      backgroundColor = HighlightingConstants.sameDigitHighlightColor;
    } else if (isInSelectedRow || isInSelectedCol || isInSelectedBox) {
      backgroundColor = HighlightingConstants.rowColumnHighlightColor;
    }

    final bool valid = gameProvider.isCellValid(row, col);
    Color cellColor = backgroundColor;
    if (!valid && gameProvider.board[row][col] != 0) {
      cellColor = Colors.red.withOpacity(0.5); // Invalid move
    }

    return AnimatedContainer(
      duration: HighlightingConstants.highlightAnimationDuration,
      curve: Curves.easeInOut,
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
            width: (col + 1) % 3 == 0
                ? HighlightingConstants.thickBorderWidth
                : HighlightingConstants.normalBorderWidth,
          ),
          bottom: BorderSide(
            color: (row + 1) % 3 == 0
                ? Colors.black
                : Colors.grey.withOpacity(0.3),
            width: (row + 1) % 3 == 0
                ? HighlightingConstants.thickBorderWidth
                : HighlightingConstants.normalBorderWidth,
          ),
          left: BorderSide(
            color: isSelected
                ? HighlightingConstants.selectedCellBorderColor
                : Colors.transparent,
            width:
                isSelected ? HighlightingConstants.selectedCellBorderWidth : 0,
          ),
          top: BorderSide(
            color: isSelected
                ? HighlightingConstants.selectedCellBorderColor
                : Colors.transparent,
            width:
                isSelected ? HighlightingConstants.selectedCellBorderWidth : 0,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            gameProvider.selectCell(row, col);
            widget.onCellSelected(row, col);
          },
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
