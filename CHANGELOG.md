## 1.0.2
- Added `TouchScaleCallPhase` enumeration to define the phase in which a touch scale callback is triggered.
  - `onAccepted`: Sets the phase when the gesture is accepted, regardless of whether the animation starts.
  - `onScaleDownEnd`: Sets the phase when the scale-down animation has completed.
  - `onScaleUpEnd`: Sets the phase when the scale-up animation has completed.

## 1.1.0
- Added `TouchScaleBehavior` to allow applying additional visual effects alongside the touch scaling interaction, such as opacity or shadow changes.

- Modified `reverseDuration` from 300ms to 250ms to create a more natural scale-up animation.

## 1.1.1
- Modified the default hit test behavior from `deferToChild` to `opaque` in `TouchScaleGestureDetector`.

## 1.2.0
- Modifyed the default `previewDuration` from 25ms to 50ms.

- Added `TouchScaleResolver` class to provide customizable touch-based scaling for widgets.

- Added `DrivenTouchScaleBehavior` class that wraps child widgets with `RepaintBoundary` to improve rendering performance.

## 1.2.2
- Fixed an issue about the dependency.

## 1.2.3
- Fixed an issue where removeListener was called after disposal, causing the effect not to apply.

## 1.3.0
- Added `DrivenTouchScaleResolver.stevens()` constructor for perceptually balanced touch scaling based on Stevens' Power Law Stevens scaling provides consistent visual feedback across different widget sizes. (smaller widgets get stronger effects, larger widgets get subtle effects)

## 1.3.1
- Modifyed the default `baseIntensity` of `DrivenTouchScaleResolver.stevens` from 0.8 to 0.6 in `TouchScale` widget.

## 1.4.0
- Added `scale` property to `TouchScale` and `TouchScaleStyle`.
  - Values below `1.0` shrink the widget.
  - Values above `1.0` expand the widget.

- Reworked `TouchScaleResolver` with const factory constructors:
  - `TouchScaleResolver.percent()`
  - `TouchScaleResolver.pixels()`
  - `TouchScaleResolver.stevens()`

- Fixed `StevensTouchScaleResolver` so scale values below and above `1.0` produce opposite visual directions correctly.

- Improved `previewDuration` behavior so delayed preview is only used while the gesture is still competing in the gesture arena.
  - Touch feedback now starts immediately when there is no competing gesture.
  - `onPress` still waits until the pointer interaction is confirmed.

## 1.4.1
- Fixed an issue where `onPress` could be called after a pointer cancellation.
