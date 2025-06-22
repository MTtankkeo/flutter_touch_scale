import 'package:flutter/material.dart';
import 'package:flutter_touch_scale/components/touch_scale_controller.dart';

/// An abstract class that defines behavior for applying additional
/// visual effects during a touch-based scaling interaction.
abstract class TouchScaleBehavior {
  const TouchScaleBehavior();

  /// Builds the widget with extra visual effects that are applied
  /// alongside the scaling behavior, such as opacity or shadow changes.
  ///
  /// Used to enhance the visual response when a widget scales, based on
  /// the state provided by the [TouchScaleController].
  Widget build(
    BuildContext context,
    Widget child,
    TouchScaleController controller,
  );
}

@protected
class DrivnTouchScaleBehavior extends TouchScaleBehavior {
  const DrivnTouchScaleBehavior();

  @override
  Widget build(
    BuildContext context,
    Widget child,
    TouchScaleController controller,
  ) {
    return child;
  }
}
