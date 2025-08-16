import 'package:flutter/rendering.dart';

/// An abstract class that defines how the scale value should be
/// calculated during a touch-based scaling interaction.
abstract class TouchScaleResolver {
  const TouchScaleResolver();

  /// Calculates the scale to apply based on the intrinsic widget size.
  double transform(Size size);
}

enum _ScaleMode { percent, pixels }

/// A [TouchScaleResolver] that provides a fixed scale value for touch scaling.
///
/// Can be defined either as a percentage of the original size
/// or as a pixel-based offset from the center of the widget.
class DrivenTouchScaleResolver extends TouchScaleResolver {
  const DrivenTouchScaleResolver.percent(this._value)
    : _mode = _ScaleMode.percent;

  const DrivenTouchScaleResolver.pixels(this._value)
    : _mode = _ScaleMode.pixels;

  final _ScaleMode _mode;
  final double _value;

  @override
  double transform(Size size) {
    if (_mode == _ScaleMode.percent) return _value;

    final double longestSide = size.longestSide;
    return 1 - _value / (longestSide / 2);
  }
}
