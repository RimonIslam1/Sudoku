import 'package:flutter/material.dart';
import 'package:sudoku_app/models/technique_data.dart';

/// Animated Sudoku grid widget specifically designed for technique demonstrations
class TechniqueGrid extends StatefulWidget {
  final TechniqueStep step;
  final AnimationController controller;
  final bool showCandidates;
  final bool showGridLines;
  final double cellSize;

  const TechniqueGrid({
    super.key,
    required this.step,
    required this.controller,
    this.showCandidates = true,
    this.showGridLines = true,
    this.cellSize = 40.0,
  });

  @override
  State<TechniqueGrid> createState() => _TechniqueGridState();
}

class _TechniqueGridState extends State<TechniqueGrid>
    with TickerProviderStateMixin {
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _highlightAnimation;
  late Animation<double> _eliminateAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: widget.controller,
      curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: widget.controller,
      curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
    ));

    _highlightAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: widget.controller,
      curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
    ));

    _eliminateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: widget.controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = widget.cellSize * 9;

    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CustomPaint(
                painter: _TechniqueGridPainter(
                  step: widget.step,
                  highlightAnimation: _highlightAnimation.value,
                  eliminateAnimation: _eliminateAnimation.value,
                  primaryColor: colorScheme.primary,
                  onSurfaceColor: colorScheme.onSurface,
                  showCandidates: widget.showCandidates,
                  showGridLines: widget.showGridLines,
                  cellSize: widget.cellSize,
                ),
                size: Size(size, size),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TechniqueGridPainter extends CustomPainter {
  final TechniqueStep step;
  final double highlightAnimation;
  final double eliminateAnimation;
  final Color primaryColor;
  final Color onSurfaceColor;
  final bool showCandidates;
  final bool showGridLines;
  final double cellSize;

  _TechniqueGridPainter({
    required this.step,
    required this.highlightAnimation,
    required this.eliminateAnimation,
    required this.primaryColor,
    required this.onSurfaceColor,
    required this.showCandidates,
    required this.showGridLines,
    required this.cellSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (showGridLines) {
      _drawGridLines(canvas, size);
    }

    _drawHighlights(canvas, size);
    _drawAffectedCells(canvas, size);
    _drawDigits(canvas, size);
    
    if (showCandidates) {
      _drawCandidates(canvas, size);
    }
  }

  void _drawGridLines(Canvas canvas, Size size) {
    final lightPaint = Paint()
      ..color = onSurfaceColor.withOpacity(0.3)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final thickPaint = Paint()
      ..color = onSurfaceColor.withOpacity(0.6)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Draw vertical lines
    for (int i = 0; i <= 9; i++) {
      final paint = (i % 3 == 0) ? thickPaint : lightPaint;
      canvas.drawLine(
        Offset(i * cellSize, 0),
        Offset(i * cellSize, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (int i = 0; i <= 9; i++) {
      final paint = (i % 3 == 0) ? thickPaint : lightPaint;
      canvas.drawLine(
        Offset(0, i * cellSize),
        Offset(size.width, i * cellSize),
        paint,
      );
    }
  }

  void _drawHighlights(Canvas canvas, Size size) {
    final highlightPaint = Paint()
      ..color = primaryColor.withOpacity(0.2 + 0.3 * highlightAnimation)
      ..style = PaintingStyle.fill;

    for (final point in step.highlightedCells) {
      final rect = Rect.fromLTWH(
        point.col * cellSize,
        point.row * cellSize,
        cellSize,
        cellSize,
      );
      canvas.drawRect(rect, highlightPaint);
    }
  }

  void _drawAffectedCells(Canvas canvas, Size size) {
    final affectedPaint = Paint()
      ..color = Colors.red.withOpacity(0.2 + 0.3 * eliminateAnimation)
      ..style = PaintingStyle.fill;

    for (final point in step.affectedCells) {
      final rect = Rect.fromLTWH(
        point.col * cellSize,
        point.row * cellSize,
        cellSize,
        cellSize,
      );
      canvas.drawRect(rect, affectedPaint);
    }
  }

  void _drawDigits(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        final value = step.grid[row][col];
        if (value != 0) {
          final isNew = step.newDigits.any((p) => p.row == row && p.col == col);
          final opacity = isNew ? (0.3 + 0.7 * highlightAnimation) : 1.0;
          final fontSize = isNew ? cellSize * 0.6 : cellSize * 0.5;
          
          final style = TextStyle(
            color: onSurfaceColor.withOpacity(opacity),
            fontSize: fontSize,
            fontWeight: isNew ? FontWeight.bold : FontWeight.w600,
          );

          textPainter.text = TextSpan(text: '$value', style: style);
          textPainter.layout();

          final x = col * cellSize + (cellSize - textPainter.width) / 2;
          final y = row * cellSize + (cellSize - textPainter.height) / 2;
          textPainter.paint(canvas, Offset(x, y));
        }
      }
    }
  }

  void _drawCandidates(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (step.grid[row][col] == 0) {
          final point = GridPoint(row, col);
          final candidates = step.candidates[point];
          
          if (candidates != null && candidates.isNotEmpty) {
            for (int digit = 1; digit <= 9; digit++) {
              if (candidates.contains(digit)) {
                final isEliminated = step.eliminatedCandidates.contains(point);
                final opacity = isEliminated 
                    ? (1.0 - eliminateAnimation) 
                    : (0.6 + 0.4 * highlightAnimation);
                
                if (opacity > 0) {
                  final candidateRow = (digit - 1) ~/ 3;
                  final candidateCol = (digit - 1) % 3;
                  
                  final style = TextStyle(
                    color: primaryColor.withOpacity(opacity),
                    fontSize: cellSize * 0.2,
                    fontWeight: FontWeight.w600,
                  );

                  textPainter.text = TextSpan(text: '$digit', style: style);
                  textPainter.layout();

                  final x = col * cellSize + 
                      (candidateCol + 0.5) * (cellSize / 3) - 
                      textPainter.width / 2;
                  final y = row * cellSize + 
                      (candidateRow + 0.5) * (cellSize / 3) - 
                      textPainter.height / 2;
                  
                  textPainter.paint(canvas, Offset(x, y));
                }
              }
            }
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TechniqueGridPainter oldDelegate) {
    return oldDelegate.step != step ||
        oldDelegate.highlightAnimation != highlightAnimation ||
        oldDelegate.eliminateAnimation != eliminateAnimation ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.onSurfaceColor != onSurfaceColor;
  }
}
