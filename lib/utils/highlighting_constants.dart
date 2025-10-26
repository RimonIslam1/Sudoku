import 'package:flutter/material.dart';

class HighlightingConstants {
  // Highlighting colors - optimized for both light and dark modes
  static const Color selectedCellColor =
      Color(0xFF64B5F6); // Blue - works in both modes
  static const Color selectedCellBorderColor = Color(0xFF42A5F5);
  static const Color rowColumnHighlightColor =
      Color(0xFF4FC3F7); // Light blue - visible in dark mode
  static const Color sameDigitHighlightColor =
      Color(0xFFFF9800); // Bright orange - visible in dark mode
  static const Color boxHighlightColor = Color(0xFF4FC3F7);

  // Animation durations
  static const Duration highlightAnimationDuration =
      Duration(milliseconds: 150);
  static const Duration fadeInDuration = Duration(milliseconds: 150);
  static const Duration fadeOutDuration = Duration(milliseconds: 150);

  // Opacity values
  static const double selectedCellOpacity = 1.0;
  static const double rowColumnOpacity = 1.0;
  static const double sameDigitOpacity = 1.0;
  static const double boxOpacity = 1.0;

  // Border widths
  static const double selectedCellBorderWidth = 2.5;
  static const double normalBorderWidth = 1.0;
  static const double thickBorderWidth = 2.0;
}
