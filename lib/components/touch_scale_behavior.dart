import 'package:flutter/widgets.dart';
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
  ///
  /// If you override this method to customize the effects, consider
  /// wrapping the child in a RepaintBoundary to optimize performance.
  Widget build(
    BuildContext context,
    Widget child,
    TouchScaleController controller,
  );
}

@protected
class DrivenTouchScaleBehavior extends TouchScaleBehavior {
  const DrivenTouchScaleBehavior();

  @override
  Widget build(
    BuildContext context,
    Widget child,
    TouchScaleController controller,
  ) {
    return RepaintBoundary(child: child);
  }
}
