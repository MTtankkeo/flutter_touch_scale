import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// The gesture recognizer that initiates a press effect early and determines later
/// whether the gesture should be accepted or rejected.
///
/// Designed to preview a visual or behavioral effect immediately on touch down,
/// and cancel it later if the gesture is rejected or disqualified due to movement.
///
/// Useful when you want to show feedback early, but still leave room for rejection.
@protected
class TouchScaleGestureRecognizer extends OneSequenceGestureRecognizer {
  TouchScaleGestureRecognizer({
    required this.onPress,
    required this.onPressRejectable,
    required this.onPressAccept,
    required this.onPressReject,
    required this.onDispose,
    this.previewMinDuration,
  });

  final VoidCallback onPress;
  final VoidCallback onPressRejectable;
  final VoidCallback onPressAccept;
  final VoidCallback onPressReject;
  final VoidCallback onDispose;
  final Duration? previewMinDuration;

  Timer? _timer;

  bool isRejectable = false;

  Offset? _pointerDownPosition;
  Offset? _pointerMovePosition;

  Offset get movedPosition {
    return (_pointerDownPosition ?? Offset.zero) -
        (_pointerMovePosition ?? Offset.zero);
  }

  @override
  void acceptGesture(int pointer) {
    super.acceptGesture(pointer);

    isRejectable ? onPressAccept.call() : onPress.call();

    // Since the gesture was accepted, call the function below to allow it to be disposed.
    didStopTrackingLastPointer(pointer);
  }

  @override
  void rejectGesture(int pointer) {
    super.rejectGesture(pointer);

    if (isRejectable) {
      onPressReject.call();
    }

    // Since the gesture was rejected, call the function below to allow it to be disposed.
    didStopTrackingLastPointer(pointer);
  }

  @override
  void didStopTrackingLastPointer(int pointer) {
    _timer?.cancel();
    onDispose.call();
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerDownEvent) {
      _pointerDownPosition = event.localPosition;

      if (previewMinDuration != null) {
        _timer = Timer(previewMinDuration!, _onRejectable);
      }
    }

    if (event is PointerMoveEvent) {
      _pointerMovePosition = event.localPosition;

      if (movedPosition.dx.abs() > kTouchSlop ||
          movedPosition.dy.abs() > kTouchSlop) {
        resolve(GestureDisposition.rejected);
      }
    }
  }

  void _onRejectable() {
    isRejectable = true;
    onPressRejectable.call();
  }

  @override
  String get debugDescription => "press by touch scale";
}

/// The gesture recognizer that tracks holding gestures, defined as when a pointer
/// is pressed but not yet released. It resolves the gesture if the pointer
/// is lifted.
///
/// Primarily used to prevent a tap gesture from being immediately
/// recognized on pointer down when there are no competing gestures.
@protected
class HoldingGestureRecognizer extends OneSequenceGestureRecognizer {
  @override
  String get debugDescription => "holding";

  /// Called when the recognizer stops tracking the last pointer.
  /// This method is empty since no specific action is needed when the last pointer is stopped.
  @override
  void didStopTrackingLastPointer(int pointer) {}

  /// Handles the incoming pointer events. If a [PointerUpEvent] is detected,
  /// the gesture is rejected for the acceptance of other gestures. (e.g. tap)
  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerUpEvent) resolve(GestureDisposition.rejected);
  }
}
