# Introduction
This Flutter package delivers clear visual feedback through scale animations on user touch interactions.

> See Also, If you want the change-log by version for this package. refer to [Change Log](CHANGELOG.md) for details.

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