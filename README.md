# Introduction
This Flutter package delivers clear visual feedback through scale animations on user touch interactions.

> See Also, If you want the change-log by version for this package. refer to [Change Log](CHANGELOG.md) for details.

## Preview
The gif image below may appear distorted and choppy due to compression.

![preview](https://github.com/user-attachments/assets/87a0a39e-0c51-4bbd-96d9-a24307bfdf29)

## Usage
The following explains the basic usage of this package.

```dart
TouchScale(
  onPress: () => print("Hello, World!"),
  child: ... // <- this your widget
)
```

Use `scale` to choose whether the widget shrinks or expands while pressed.

```dart
TouchScale(
  onPress: () => print("Pressed!"),
  scale: 0.9, // shrink
  child: ...
)

TouchScale(
  onPress: () => print("Pressed!"),
  scale: 1.1, // expand
  child: ...
)
```

### How to define the style globally.
TouchScaleStyle defines the style of its descendant touch scale widgets, similar to how PrimaryScrollController defines the controller for its descendant widgets.

```dart
TouchScaleStyle(
  scale: 1.1,
  child: ...
)
```

Use `TouchScaleResolver` to customize how the `scale` value is resolved.

```dart
TouchScale(
  scale: 0.9,
  resolver: TouchScaleResolver.percent(),
  onPress: () => print("Pressed!"),
  child: ...
)

TouchScale(
  scale: 8.0,
  resolver: TouchScaleResolver.pixels(),
  onPress: () => print("Pressed!"),
  child: ...
)

TouchScale(
  scale: 0.5,
  resolver: TouchScaleResolver.stevens(),
  onPress: () => print("Pressed!"),
  child: ...
)
```

`previewDuration` delays the preview effect only while the gesture is still competing with another gesture. If there is no competing gesture, the touch feedback starts immediately.

## The Properties of TouchScaleCallPhase
The enumeration that defines the phase in which a touch scale callback is triggered.

| Name | Description |
| ---- | ----------- |
| onAccepted | Sets the phase when the gesture is accepted, regardless of whether the animation starts. |
| onScaleDownEnd | Sets the phase when the scale-down animation has completed. |
| onScaleUpEnd | Sets the phase when the scale-up animation has completed. |
