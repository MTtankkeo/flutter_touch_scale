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
