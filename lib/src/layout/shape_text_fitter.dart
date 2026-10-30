import 'dart:math' as math;
import 'package:flutter/painting.dart';

/// Detailed result of dynamic text fitting within shape bounds.
class TextFitResult {
  /// Optimal font size that best utilizes the available geometry.
  final double fontSize;

  /// Whether the text successfully fit inside the bounded area without truncation.
  final bool didFit;

  /// Rendered size of the text at [fontSize].
  final Size renderedSize;

  /// Number of lines required to display the text.
  final int lineCount;

  /// Whether the text had to be truncated or ellipsis-clipped.
  final bool wasTruncated;

  /// Effective text style at the computed [fontSize].
  final TextStyle effectiveStyle;

  const TextFitResult({
    required this.fontSize,
    required this.didFit,
    required this.renderedSize,
    required this.lineCount,
    required this.wasTruncated,
    required this.effectiveStyle,
  });

  @override
  String toString() =>
      'TextFitResult(fontSize: $fontSize, didFit: $didFit, lines: $lineCount, size: $renderedSize)';
}

/// Smart text layout, measurement, and accessible auto-fitting engine for dynamic shapes.
///
/// Ensures text (including complex scripts such as Bengali and RTL Arabic/Hebrew)
/// fits comfortably inside safe shape bounds without accidental clipping,
/// truncation, or unreadable scale reduction.
class ShapeTextFitter {
  const ShapeTextFitter._();

  /// Default minimum accessible font size according to WCAG 2.1 AAA mobile criteria.
  static const double accessibleMinFontSize = 11.0;

  /// Measures rendered [Size] of [text] with given [style] within [maxWidth].
  static Size measureText({
    required String text,
    TextStyle? style,
    double maxWidth = double.infinity,
    int? maxLines,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    if (text.isEmpty) return Size.zero;

    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: textDirection,
      maxLines: maxLines,
    )..layout(maxWidth: maxWidth);

    final size = textPainter.size;
    textPainter.dispose();
    return size;
  }

  /// Measures multi-line text metrics including line count and unconstrained width.
  static ({Size size, int lineCount, bool didExceedMaxLines}) measureMultilineText({
    required String text,
    TextStyle? style,
    required double maxWidth,
    int? maxLines,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    if (text.isEmpty) {
      return (size: Size.zero, lineCount: 0, didExceedMaxLines: false);
    }

    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: textDirection,
      maxLines: maxLines,
    )..layout(maxWidth: maxWidth);

    final lineMetrics = textPainter.computeLineMetrics();
    final count = lineMetrics.isNotEmpty ? lineMetrics.length : 1;
    final exceeded = textPainter.didExceedMaxLines;
    final size = textPainter.size;
    textPainter.dispose();

    return (size: size, lineCount: count, didExceedMaxLines: exceeded);
  }

  /// Calculates the optimal font size to fit [text] within [targetSize].
  ///
  /// Searches between [minFontSize] and [maxFontSize].
  /// Never scales below [minFontSize] to guarantee accessibility readability.
  static double computeOptimalFontSize({
    required String text,
    required Size targetSize,
    TextStyle? baseStyle,
    double minFontSize = accessibleMinFontSize,
    double maxFontSize = 32.0,
    int? maxLines,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    if (text.isEmpty || targetSize.width <= 0 || targetSize.height <= 0) {
      return minFontSize;
    }

    // Accessible safety floor: font sizes below minFontSize are forbidden
    final safeMin = math.max(8.0, minFontSize);
    final safeMax = math.max(safeMin, maxFontSize);

    double low = safeMin;
    double high = safeMax;
    double bestFit = safeMin;

    for (int i = 0; i < 8; i++) {
      final mid = (low + high) / 2.0;
      final style = (baseStyle ?? const TextStyle()).copyWith(fontSize: mid);
      final textSpan = TextSpan(text: text, style: style);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: textDirection,
        maxLines: maxLines,
      )..layout(maxWidth: targetSize.width);

      final fitsWidth = maxLines == 1
          ? textPainter.maxIntrinsicWidth <= targetSize.width + 0.1
          : textPainter.width <= targetSize.width + 0.1;
      final fitsHeight = textPainter.height <= targetSize.height + 0.1;
      final linesOk = !textPainter.didExceedMaxLines;

      textPainter.dispose();

      if (fitsWidth && fitsHeight && linesOk) {
        bestFit = mid;
        low = mid; // Try larger font
      } else {
        high = mid; // Too big
      }
    }

    return bestFit;
  }

  /// Analyzes text and calculates the complete [TextFitResult] within [bounds].
  static TextFitResult fitText({
    required String text,
    required Rect bounds,
    TextStyle? baseStyle,
    int? maxLines,
    double minFontSize = accessibleMinFontSize,
    double maxFontSize = 28.0,
    bool allowScaling = true,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    final startStyle = baseStyle ?? const TextStyle();
    final requestedSize = startStyle.fontSize ?? 16.0;

    double effectiveFontSize = requestedSize;
    if (allowScaling) {
      effectiveFontSize = computeOptimalFontSize(
        text: text,
        targetSize: bounds.size,
        baseStyle: startStyle,
        minFontSize: minFontSize,
        maxFontSize: math.max(requestedSize, maxFontSize),
        maxLines: maxLines,
        textDirection: textDirection,
      );
    }

    final finalStyle = startStyle.copyWith(fontSize: effectiveFontSize);
    final metrics = measureMultilineText(
      text: text,
      style: finalStyle,
      maxWidth: bounds.width,
      maxLines: maxLines,
      textDirection: textDirection,
    );

    final fits = metrics.size.width <= bounds.width + 0.1 &&
        metrics.size.height <= bounds.height + 0.1 &&
        !metrics.didExceedMaxLines;

    return TextFitResult(
      fontSize: effectiveFontSize,
      didFit: fits,
      renderedSize: metrics.size,
      lineCount: metrics.lineCount,
      wasTruncated: metrics.didExceedMaxLines,
      effectiveStyle: finalStyle,
    );
  }

  /// Determines whether [text] fits within [bounds] without overflow.
  static bool fitsWithin({
    required String text,
    required Rect bounds,
    TextStyle? style,
    int? maxLines,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    if (text.isEmpty) return true;
    if (bounds.width <= 0 || bounds.height <= 0) return false;

    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: textDirection,
      maxLines: maxLines,
    )..layout(maxWidth: bounds.width);

    try {
      if (textPainter.didExceedMaxLines) return false;
      if (textPainter.height > bounds.height + 0.1) return false;
      if (maxLines == 1 && textPainter.maxIntrinsicWidth > bounds.width + 0.1) {
        return false;
      }
      return true;
    } finally {
      textPainter.dispose();
    }
  }
}
