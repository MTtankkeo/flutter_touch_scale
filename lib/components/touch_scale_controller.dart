// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_touch_scale/flutter_touch_scale.dart';

/// Controls the scale animation for the TouchScale widget,
/// managing animation state and notifying listeners on changes.
class TouchScaleController extends ChangeNotifier {
  TouchScaleController({required this.context});

  /// Holds configuration and context needed for animation.
  final TouchScaleContext context;

  AnimationController? _animation;
  CurvedAnimation? _curved;

  /// Current animation progress value (0.0 to 1.0) after applying curve.
  double get animValue => _curved?.value ?? 0.0;

  /// Indicates whether the gesture is currently rejectable.
  bool isRejectable = false;

  /// A callback to be invoked when conditions are met.
  VoidCallback? callback;

  /// Calls [callback] if the gesture is not rejectable, then clears it.
  void tryCall() {
    if (isRejectable) return;
    callback?.call();
    callback = null;
  }

  /// Accepts the gesture and notifies listeners of the current animation status.
  void accept() {
    assert(_animation != null);
    assert(callback != null);
    isRejectable = false;
    _animation?.notifyStatusListeners(_animation!.status);
    _whenPhase(TouchScaleCallPhase.onAccepted);
  }

  /// Rejects the gesture and starts reversing the animation.
  void reject() {
    assert(_animation != null);
    _animation?.reverse();
  }

  /// Starts the forward animation, initializing controllers if necessary.
  /// When completed and not rejectable, automatically reverses the animation.
  void forward() {
    assert(!isRejectable ? callback != null : true);
    _whenPhase(TouchScaleCallPhase.onAccepted);

    if (_animation == null) {
      _animation = AnimationController(
        vsync: context.vsync,
        duration: context.duration,
        reverseDuration: context.reverseDuration,
      );

      _animation!.addListener(notifyListeners);
      _animation!.addStatusListener((status) {
        if (status == AnimationStatus.completed && !isRejectable) {
          _animation?.reverse();
          _whenPhase(TouchScaleCallPhase.onScaleDownEnd);
        } else if (status == AnimationStatus.dismissed) {
          isRejectable = false;
          _animation?.dispose();
          _animation = null;
          _whenPhase(TouchScaleCallPhase.onScaleUpEnd);
        }
      });

      _curved = CurvedAnimation(
        parent: _animation!,
        curve: context.curve,
        reverseCurve: context.reverseCurve,
      );
    }

    _animation?.forward();
  }

  @override
  void dispose() {
    _animation?.dispose();
    super.dispose();
  }

  /// Invokes the callback if the current call phase matches [phase].
  /// Ensures the callback triggers only at the specified touch scale call phase.
  void _whenPhase(TouchScaleCallPhase phase) {
    if (context.callPhase == phase) {
      tryCall();
    }
  }
}
