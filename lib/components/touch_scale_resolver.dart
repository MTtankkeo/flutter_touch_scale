import 'dart:math';

import 'package:flutter/rendering.dart';

/// An abstract class that defines how the scale value should be
/// calculated during a touch-based scaling interaction.
abstract class TouchScaleResolver {
  const TouchScaleResolver();

  /// Creates a resolver that always returns the given scale factor.
  ///
  /// Values below 1.0 shrink the widget, and values above 1.0 expand it.
  const factory TouchScaleResolver.percent() = PercentTouchScaleResolver;

  /// Creates a resolver from a pixel-based offset from the widget center.
  const factory TouchScaleResolver.pixels() = PixelsTouchScaleResolver;

  /// Stevens' Power Law: Perceived intensity = k * (stimulus intensity)^n.
  /// For touch feedback, exponent n ~= 0.3-0.5 is appropriate.
  const factory TouchScaleResolver.stevens({
    double exponent,
    double referenceSize,
    double scalingFactor,
  }) = StevensTouchScaleResolver;

  /// Calculates the scale to apply based on the intrinsic widget size.
  double transform(Size size, double value);
}

/// A [TouchScaleResolver] that provides a fixed scale value.
class PercentTouchScaleResolver extends TouchScaleResolver {
  const PercentTouchScaleResolver();

  @override
  double transform(Size size, double scale) => scale;
}

/// A [TouchScaleResolver] that derives scale from a pixel offset.
class PixelsTouchScaleResolver extends TouchScaleResolver {
  const PixelsTouchScaleResolver();

  @override
  double transform(Size size, double pixelOffset) {
    final double longestSide = size.longestSide;
    return 1.0 - (-pixelOffset) / (longestSide / 2);
  }
}

/// A [TouchScaleResolver] that applies Stevens' Power Law for
/// perceptually balanced scaling.
class StevensTouchScaleResolver extends TouchScaleResolver {
  const StevensTouchScaleResolver({
    this.exponent = 0.4,
    this.referenceSize = 100.0,
    this.scalingFactor = 0.15,
  });

  /// Power law exponent for touch perception.
  final double exponent;

  /// Reference size in pixels for scaling calculations.
  final double referenceSize;

  /// Scaling multiplier to control overall effect intensity.
  final double scalingFactor;

  @override
  double transform(Size size, double scale) {
    final double longestSide = size.longestSide;
    final double normalizedSize = longestSide / referenceSize;
    final double perceivedIntensity = pow(normalizedSize, exponent).toDouble();
    final double effectMultiplier = 1.0 / perceivedIntensity;
    final double scaleOffset = (scale - 1.0) * scalingFactor * effectMultiplier;

    return 1.0 + scaleOffset;
  }
}
