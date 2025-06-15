## 1.0.2
- Added `TouchScaleCallPhase` enumeration to define the phase in which a touch scale callback is triggered.
  - `onAccepted`: Sets the phase when the gesture is accepted, regardless of whether the animation starts.
  - `onScaleDownEnd`: Sets the phase when the scale-down animation has completed.
  - `onScaleUpEnd`: Sets the phase when the scale-up animation has completed.