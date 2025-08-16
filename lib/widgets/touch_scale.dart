import 'package:flutter/widgets.dart';
import 'package:flutter_touch_scale/components/touch_scale_behavior.dart';
import 'package:flutter_touch_scale/components/touch_scale_context.dart';
import 'package:flutter_touch_scale/components/touch_scale_controller.dart';
import 'package:flutter_touch_scale/components/touch_scale_resolver.dart';
import 'package:flutter_touch_scale/widgets/render_touch_scale.dart';
import 'package:flutter_touch_scale/widgets/touch_scale_gesture_detector.dart';
import 'package:flutter_touch_scale/widgets/touch_scale_style.dart';

/// The enumeration that defines the phase in which
/// a touch scale callback is triggered.
enum TouchScaleCallPhase {
  /// Sets the phase when the gesture is accepted,
  /// regardless of whether the animation starts.
  onAccepted,

  /// Sets the phase when the scale-down animation has completed.
  onScaleDownEnd,

  /// Sets the phase when the scale-up animation has completed.
  onScaleUpEnd,
}

/// A widget that scales down its child when pressed and triggers a callback on tap.
/// Commonly used to enhance tap interactions with visual responsiveness.
///
/// ### Example
///
/// ```dart
/// TouchScale(
///   onPress: () => print("Pressed!"),
///   child: Text("Hello, World!"),
/// )
/// ```
class TouchScale extends StatefulWidget {
  const TouchScale({
    super.key,
    this.previewDuration,
    this.duration,
    this.curve,
    this.reverseDuration,
    this.reverseCurve,
    this.resolver,
    this.callPhase,
    this.behavior,
    required this.onPress,
    required this.child,
  });

  /// The duration to wait before showing the scale preview effect.
  /// If the gesture is rejected before this duration passes,
  /// the effect will not appear.
  final Duration? previewDuration;

  /// The duration of the forward (scale-down) animation.
  final Duration? duration;

  /// The curve of the forward animation when scaling down.
  final Curve? curve;

  /// The duration of the reverse (scale-up) animation.
  final Duration? reverseDuration;

  /// The curve of the reverse animation when scaling back to original size.
  final Curve? reverseCurve;

  /// Defines the phase in which a touch scale callback is triggered.
  final TouchScaleCallPhase? callPhase;

  /// The scale factor to apply when pressed. For example,
  /// 0.9 means 90% of the original size.
  final TouchScaleResolver? resolver;

  /// Resolves the scale factor to apply during a press interaction.
  /// e.g. a value of 0.9 scales the widget to 90% of its original size.
  final TouchScaleBehavior? behavior;

  /// Called when the gesture is accepted and the press is confirmed.
  final VoidCallback onPress;

  /// The widget below this widget in the tree that will be scaled.
  final Widget child;

  @override
  State<TouchScale> createState() => _TouchScaleState();
}

class _TouchScaleState extends State<TouchScale>
    with TickerProviderStateMixin, TouchScaleContext {
  late final TouchScaleController _controller = TouchScaleController(
    context: this,
  );

  /// Returns the instance of the current [TouchScaleStyle] widget.
  TouchScaleStyle? get style => TouchScaleStyle.maybeOf(context);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TouchScaleGestureDetector(
      controller: _controller,
      onPress: widget.onPress,
      child: RenderTouchScale(
        controller: _controller,
        resolver: resolver,
        child: behavior.build(context, widget.child, _controller),
      ),
    );
  }

  TouchScaleResolver get resolver {
    return widget.resolver ??
        style?.resolver ??
        DrivenTouchScaleResolver.stevens(baseIntensity: 0.6);
  }

  @override
  TickerProvider get vsync => this;

  @override
  Duration get duration {
    return widget.duration ?? style?.duration ?? Duration(milliseconds: 100);
  }

  @override
  Curve get curve {
    return widget.curve ?? style?.curve ?? const Cubic(0.4, 0.0, 0.2, 1.0);
  }

  @override
  Duration get reverseDuration {
    return widget.reverseDuration ??
        style?.reverseDuration ??
        Duration(milliseconds: 250);
  }

  @override
  Curve get reverseCurve {
    return widget.reverseCurve ?? style?.reverseCurve ?? curve.flipped;
  }

  @override
  Duration get previewDuration {
    return widget.previewDuration ??
        style?.previewDuration ??
        Duration(milliseconds: 50);
  }

  @override
  TouchScaleCallPhase get callPhase {
    return widget.callPhase ??
        style?.callPhase ??
        TouchScaleCallPhase.onAccepted;
  }

  @override
  TouchScaleBehavior get behavior {
    return widget.behavior ??
        style?.behavior ??
        const DrivenTouchScaleBehavior();
  }
}
