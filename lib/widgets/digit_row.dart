import 'package:flutter/material.dart';

class DigitRow extends StatelessWidget {
  final Function(int) onDigitSelected;
  final int? selectedDigit;
  final Map<int, int> digitCounts;

  const DigitRow({
    Key? key,
    required this.onDigitSelected,
    required this.selectedDigit,
    required this.digitCounts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final isCompact = availableWidth < 360; // e.g., very narrow devices
        final circleSize = isCompact ? 32.0 : 36.0;
        final labelFontSize = isCompact ? 12.0 : 14.0;

        // Force a single horizontal row. If space is tight, allow horizontal
        // scrolling instead of wrapping to multiple lines.
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(9, (index) {
              final digit = index + 1;
              final isSelected = selectedDigit == digit;
              final count = digitCounts[digit] ?? 0;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => onDigitSelected(digit),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: circleSize,
                        height: circleSize,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.surface,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outline,
                            width: 2,
                          ),
                          boxShadow: [
                            if (isSelected)
                              BoxShadow(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$digit',
                          style: TextStyle(
                            fontSize: isCompact ? 18 : 20,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$count',
                      style: TextStyle(
                        fontSize: labelFontSize,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
