/// The enumeration that defines how a touch scale gesture
/// is rejected based on pointer movement.
enum TouchScaleRejectBehavior {
  /// Does not reject the gesture based on pointer movement.
  none,

  /// Rejects the gesture when the pointer moves beyond the touch slop.
  touchSlop,

  /// Rejects the gesture when the pointer leaves the widget bounds.
  leave,
}
