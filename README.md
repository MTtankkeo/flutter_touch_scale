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

### How to define the style globally.
TouchScaleStyle defines the style of its descendant touch scale widgets, similar to how PrimaryScrollController defines the controller for its descendant widgets.

```dart
TouchScaleStyle(
  scale: 1.1,
  child: ...
)
```

## The Properties of TouchScaleCallPhase
The enumeration that defines the phase in which a touch scale callback is triggered.

| Name | Description |
| ---- | ----------- |
| onAccepted | Sets the phase when the gesture is accepted, regardless of whether the animation starts. |
| onScaleDownEnd | Sets the phase when the scale-down animation has completed. |
| onScaleUpEnd | Sets the phase when the scale-up animation has completed. |
