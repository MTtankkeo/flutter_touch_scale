import 'package:flutter/widgets.dart';
import 'package:flutter_touch_scale/flutter_touch_scale.dart';

/// A inherited widget globally provides the style information for
/// a touch scale effect to all descendant widgets in the widget tree.
class TouchScaleStyle extends InheritedWidget {
  const TouchScaleStyle({
    super.key,
    this.duration,
    this.curve,
    this.reverseDuration,
    this.reverseCurve,
    this.previewDuration,
    this.callPhase,
    this.resolver,
    this.behavior,
    required super.child,
  });

  /// The duration of the forward (scale-down) animation.
  final Duration? duration;

  /// The curve of the forward animation when scaling down.
  final Curve? curve;

  /// The duration of the reverse (scale-up) animation.
  final Duration? reverseDuration;

  /// The curve of the reverse animation when scaling back to original size.
  final Curve? reverseCurve;

  /// The duration to wait before showing the scale preview effect.
  /// If the gesture is rejected before this duration passes,
  /// the effect will not appear.
  final Duration? previewDuration;

  /// Defines the phase in which a touch scale callback is triggered.
  final TouchScaleCallPhase? callPhase;

  /// The scale factor to apply when pressed. For example,
  /// 0.9 means 90% of the original size.
  final TouchScaleResolver? resolver;

  /// The behavior used to apply additional visual effects during
  /// the scaling interaction, such as opacity or shadow changes.
  final TouchScaleBehavior? behavior;

  @override
  bool updateShouldNotify(TouchScaleStyle oldWidget) {
    return duration != oldWidget.duration ||
        curve != oldWidget.curve ||
        reverseDuration != oldWidget.reverseDuration ||
        reverseCurve != oldWidget.reverseCurve ||
        previewDuration != oldWidget.previewDuration ||
        callPhase != oldWidget.callPhase ||
        resolver != oldWidget.resolver ||
        behavior != oldWidget.behavior;
  }

  /// Returns the [TouchScaleStyle] most closely associated with the given
  /// context, and returns null if there is no [TouchScaleStyle] associated
  /// with the given context.
  static TouchScaleStyle? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TouchScaleStyle>();
  }
}
