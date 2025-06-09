import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

@protected
mixin TouchScaleContext {
  TickerProvider get vsync;
  Duration get duration;
  Curve get curve;
  Duration get reverseDuration;
  Curve get reverseCurve;
  Duration? get previewDuration;
}
