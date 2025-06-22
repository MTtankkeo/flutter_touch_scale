## 1.0.2
- Added `TouchScaleCallPhase` enumeration to define the phase in which a touch scale callback is triggered.
  - `onAccepted`: Sets the phase when the gesture is accepted, regardless of whether the animation starts.
  - `onScaleDownEnd`: Sets the phase when the scale-down animation has completed.
  - `onScaleUpEnd`: Sets the phase when the scale-up animation has completed.

## 1.1.0
- Added `TouchScaleBehavior` to allow applying additional visual effects alongside the touch scaling interaction, such as opacity or shadow changes.

- Modified `reverseDuration` from 300ms to 250ms to create a more natural scale-up animation.