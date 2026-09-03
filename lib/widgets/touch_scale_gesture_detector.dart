import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_touch_scale/flutter_touch_scale.dart';

class TouchScaleGestureDetector extends StatefulWidget {
  const TouchScaleGestureDetector({
    super.key,
    this.behavior = HitTestBehavior.opaque,
    required this.context,
    required this.controller,
    required this.onPress,
    this.onPressStart,
    this.onPressEnd,
    required this.child,
  });

  final HitTestBehavior behavior;
  final TouchScaleContext context;
  final TouchScaleController controller;
  final VoidCallback onPress;
  final VoidCallback? onPressStart;
  final VoidCallback? onPressEnd;
  final Widget child;

  @override
  State<TouchScaleGestureDetector> createState() => _TouchScaleGestureDetectorState();
}

class _TouchScaleGestureDetectorState extends State<TouchScaleGestureDetector> {
  /// The instance that defines the [GestureRecognizer] instance
  /// that is currently active and handling pointer events.
  TouchScaleGestureRecognizer? _recognizer;

  void _handlePointerDown(PointerDownEvent event) {
    _recognizer ??= TouchScaleGestureRecognizer(
      context: widget.context,
      onPressStart: widget.onPressStart,
      onPressEnd: widget.onPressEnd,
      onPress: () {
        widget.controller.callback = widget.onPress;
        widget.controller.forward();
      },
      onPressRejectable: () {
        widget.controller.callback = widget.onPress;
        widget.controller.isRejectable = true;
        widget.controller.forward();
      },
      onPressAccept: () {
        widget.controller.accept();
      },
      onPressReject: () => widget.controller.reject(),
      onDispose: () => _recognizer = null,
      previewMinDuration: widget.controller.context.previewDuration,
    );

    _recognizer!.addPointer(event);
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
