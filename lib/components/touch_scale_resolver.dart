import 'dart:math';

import 'package:flutter/rendering.dart';

/// An abstract class that defines how the scale value should be
/// calculated during a touch-based scaling interaction.
abstract class TouchScaleResolver {
  const TouchScaleResolver();

  /// Calculates the scale to apply based on the intrinsic widget size.
  double transform(Size size);
}

enum _ScaleMode { percent, pixels, stevens }

/// A [TouchScaleResolver] that provides a fixed scale value for touch scaling.
///
/// Can be defined either as a percentage of the original size
/// or as a pixel-based offset from the center of the widget.
class DrivenTouchScaleResolver extends TouchScaleResolver {
  DrivenTouchScaleResolver.percent(this._value) : _mode = _ScaleMode.percent;
  DrivenTouchScaleResolver.pixels(this._value) : _mode = _ScaleMode.pixels;

  /// Stevens' Power Law: Perceived intensity = k × (stimulus intensity)^n
  /// For touch feedback, exponent n ≈ 0.3-0.5 is appropriate.
  DrivenTouchScaleResolver.stevens({
    /// Base intensity factor. (0.5-1.2 typical range)
    required double baseIntensity,

    /// Power law exponent for touch perception. (0.4 is scientifically validated)
    double exponent = 0.4,

    /// Reference size in pixels for scaling calculations. (100px typical)
    double referenceSize = 100.0,

    /// Higher minimum scale to prevent over-scaling on small widgets.
    double minScale = 0.0,

    /// Reasonable maximum scale for subtle effects on large widgets.
    double maxScale = 1.0,

    /// Scaling multiplier to control overall effect intensity. (0.1-0.3 range)
    double scalingFactor = 0.15,
  }) : _value = baseIntensity,
       _mode = _ScaleMode.stevens {
    _parameters = {
      'exponent': exponent,
      'referenceSize': referenceSize,
      'minScale': minScale,
      'maxScale': maxScale,
      'scalingFactor': scalingFactor,
    };
  }

  final _ScaleMode _mode;
  final double _value;
  late Map<String, double> _parameters;

  @override
  double transform(Size size) {
    switch (_mode) {
      case _ScaleMode.percent:
        return _value;
      case _ScaleMode.pixels:
        final double longestSide = size.longestSide;
        return 1 - _value / (longestSide / 2);
      case _ScaleMode.stevens:
        return _stevensTransform(size);
    }
  }

  /// Applies Stevens' Power Law for perceptually balanced scaling.
  /// Formula: S = k × I^n (S: perceived intensity, I: stimulus intensity, n: exponent)
  double _stevensTransform(Size size) {
    final double longestSide = size.longestSide;
    final double exponent = _parameters['exponent']!;
    final double referenceSize = _parameters['referenceSize']!;
    final double minScale = _parameters['minScale']!;
    final double maxScale = _parameters['maxScale']!;
    final double scalingFactor = _parameters['scalingFactor']!;

    // Normalize size relative to reference size
    final double normalizedSize = longestSide / referenceSize;

    // Apply Stevens' Power Law
    final double perceivedIntensity = pow(normalizedSize, exponent).toDouble();

    // Correct Stevens formula: smaller widgets get stronger effects
    // Key insight: use inverse of perceived intensity for size-appropriate scaling.
    final double effectMultiplier = 1.0 / perceivedIntensity;
    final double scaleReduction = _value * scalingFactor * effectMultiplier;
    final double scale = 1.0 - scaleReduction;
    final double clampedScale = scale.clamp(minScale, maxScale);

    return clampedScale;
  }
}
