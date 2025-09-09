import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_app/providers/game_provider.dart';

class DigitRow extends StatelessWidget {
  final Function(int) onDigitSelected;
  final int? selectedDigit;

  const DigitRow({
    super.key,
    required this.onDigitSelected,
    this.selectedDigit,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final digitCounts = gameProvider.digitCounts;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Calculate button size based on available width
              final availableWidth = constraints.maxWidth;
              final buttonSpacing = 2.0;
              final totalSpacing =
                  buttonSpacing * 8; // 8 spaces between 9 buttons
              final buttonWidth = (availableWidth - totalSpacing) / 9;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(9, (index) {
                  final digit = index + 1;
                  return Container(
                    width: buttonWidth,
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: buttonSpacing / 2),
                    child: _buildDigitButton(
                      context,
                      digit,
                      digitCounts[digit] ?? 0,
                    ),
                  );
                }),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDigitButton(
    BuildContext context,
    int digit,
    int count,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () => onDigitSelected(digit),
        child: Container(
          decoration: BoxDecoration(
            color: selectedDigit == digit
                ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                : Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: selectedDigit == digit
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.primary.withOpacity(0.3),
              width: selectedDigit == digit ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                digit.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
