import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_touch_scale/components/touch_scale_controller.dart';
import 'package:flutter_touch_scale/components/touch_scale_gesture_recognizer.dart';

class TouchScaleGestureDetector extends StatefulWidget {
  const TouchScaleGestureDetector({
    super.key,
    this.behavior = HitTestBehavior.deferToChild,
    required this.controller,
    required this.onPress,
    required this.child,
  });

  final HitTestBehavior behavior;
  final TouchScaleController controller;
  final VoidCallback onPress;
  final Widget child;

  @override
  State<TouchScaleGestureDetector> createState() =>
      _TouchScaleGestureDetectorState();
}

class _TouchScaleGestureDetectorState extends State<TouchScaleGestureDetector> {
  final HoldingGestureRecognizer _holdingRecognizer =
      HoldingGestureRecognizer();

  /// The instance that defines the [GestureRecognizer] instance
  /// that is currently active and handling pointer events.
  TouchScaleGestureRecognizer? _recognizer;

  void _handlePointerDown(PointerDownEvent event) {
    _recognizer ??= TouchScaleGestureRecognizer(
      onPress: () {
        widget.controller.forward();
        widget.onPress.call();
      },
      onPressRejectable: () {
        widget.controller.isRejectable = true;
        widget.controller.forward();
      },
      onPressAccept: () {
        widget.controller.accept();
        widget.onPress.call();
      },
      onPressReject: () => widget.controller.reject(),
      onDispose: () => _recognizer = null,
      previewMinDuration: widget.controller.context.previewDuration,
    );

    _recognizer!.addPointer(event);
    _holdingRecognizer.addPointer(event);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _handlePointerDown,
      behavior: widget.behavior,
      child: widget.child,
    );
  }
}
