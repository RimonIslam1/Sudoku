import 'package:flutter/material.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudoku Rules'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section(
            context,
            title: 'Objective',
            body:
                'Fill the 9×9 grid so that every row, column, and 3×3 box contains all digits from 1 to 9 exactly once.',
          ),
          const SizedBox(height: 12),
          _section(
            context,
            title: 'Rules',
            body:
                '1. Each row must contain the digits 1–9 without repetition.\n'
                '2. Each column must contain the digits 1–9 without repetition.\n'
                '3. Each 3×3 subgrid must contain the digits 1–9 without repetition.\n'
                '4. Pre-filled numbers (clues) cannot be changed.',
          ),
          const SizedBox(height: 12),
          _diagramCard(context, 'Valid vs Invalid Placement',
              'Tap a cell to select it. Note how same row/column/box squares are softly highlighted.'),
          const SizedBox(height: 12),
          _section(
            context,
            title: 'Gameplay Tips',
            body: '• Start with easy cells that have many neighbors filled.\n'
                '• Use candidate notes to record possible digits.\n'
                '• Use Undo and Hint when stuck.',
          ),
        ],
      ),
    );
  }

  Widget _section(BuildContext context,
      {required String title, required String body}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: TextStyle(
                fontSize: 15,
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.85),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _diagramCard(BuildContext context, String title, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.grid_on,
                  color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
