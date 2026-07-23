import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_touch_scale/flutter_touch_scale.dart';

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
    required this.context,
    required this.onPress,
    required this.onPressRejectable,
    required this.onPressAccept,
    required this.onPressReject,
    required this.onDispose,
    this.previewMinDuration,
  });

  final TouchScaleContext context;
  final VoidCallback onPress;
  final VoidCallback onPressRejectable;
  final VoidCallback onPressAccept;
  final VoidCallback onPressReject;
  final VoidCallback onDispose;
  final Duration? previewMinDuration;

  Timer? _timer;

  bool isRejectable = false;
  bool _isAccepted = false;
  bool _isRejected = false;
  bool _isCanceled = false;
  bool _isPointerDown = false;

  Offset? _pointerDownPosition;
  Offset? _pointerMovePosition;

  /// Returns the render box corresponding to the initialized build context.
  RenderBox? get _renderBox => context.context.findRenderObject() as RenderBox?;

  /// Returns the distance the pointer has moved since it was detected.
  Offset get _pointerMoveDistance => (_pointerDownPosition ?? Offset.zero) - (_pointerMovePosition ?? Offset.zero);

  /// Returns whether to reject the gesture based on the given pointer offset.
  bool rejectByPosition(Offset offset) {
    if (_isRejected) return false;
    if (context.rejectBehavior == TouchScaleRejectBehavior.none) return false;
    if (context.rejectBehavior == TouchScaleRejectBehavior.leave) {
      return !(_renderBox?.hitTest(BoxHitTestResult(), position: offset) ?? false);
    }

    // is TouchScaleRejectBehavior.touchSlop
    return _pointerMoveDistance.dx.abs() > kTouchSlop || _pointerMoveDistance.dy.abs() > kTouchSlop;
  }

  @override
  void acceptGesture(int pointer) {
    super.acceptGesture(pointer);

    _timer?.cancel();
    _isAccepted = true;

    if (_isCanceled) {
      didStopTrackingLastPointer(pointer);
      return;
    }

    if (_isPointerDown) {
      _onRejectable();
      return;
    }

    _acceptPress();
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
    final currentPosition = event.localPosition;

    if (event is PointerDownEvent) {
      _isPointerDown = true;
      _pointerDownPosition = currentPosition;

      if (previewMinDuration != null) {
        _timer = Timer(previewMinDuration!, _onRejectable);
      }
    }

    if (event is PointerMoveEvent) {
      _pointerMovePosition = currentPosition;

      if (rejectByPosition(currentPosition)) {
        _isCanceled = true;

        if (_isAccepted && isRejectable) {
          _isRejected = true;
          onPressReject.call();
          didStopTrackingLastPointer(event.pointer);
          return;
        }

        resolve(GestureDisposition.rejected);
      }
    }

    if (event is PointerUpEvent) {
      _isPointerDown = false;
      _timer?.cancel();

      if (_isAccepted && !_isCanceled) {
        _acceptPress();
        didStopTrackingLastPointer(event.pointer);
      }
    }

    if (event is PointerCancelEvent) {
      _isPointerDown = false;
      _isCanceled = true;
      _timer?.cancel();

      if (isRejectable) {
        onPressReject.call();
      }

      didStopTrackingLastPointer(event.pointer);
    }
  }

  void _onRejectable() {
    if (isRejectable || _isCanceled) return;

    isRejectable = true;
    onPressRejectable.call();
  }

  void _acceptPress() {
    isRejectable ? onPressAccept.call() : onPress.call();
  }

  @override
  String get debugDescription => "press by touch scale";
}
