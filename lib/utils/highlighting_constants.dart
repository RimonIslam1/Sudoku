import 'package:flutter/material.dart';

class HighlightingConstants {
  // Highlighting colors
  static const Color selectedCellColor =
      Color(0xFFFFEE58); // Slightly darker yellow
  static const Color selectedCellBorderColor = Color(0xFFFFEE58);
  static const Color rowColumnHighlightColor = Color(0xFFFFF59D); // Soft yellow
  static const Color sameDigitHighlightColor = Color(0xFFFFF59D);
  static const Color boxHighlightColor = Color(0xFFFFF59D);

  // Animation durations
  static const Duration highlightAnimationDuration =
      Duration(milliseconds: 180);
  static const Duration fadeInDuration = Duration(milliseconds: 180);
  static const Duration fadeOutDuration = Duration(milliseconds: 180);

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
