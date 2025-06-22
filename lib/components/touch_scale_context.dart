import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_touch_scale/components/touch_scale_behavior.dart';
import 'package:flutter_touch_scale/flutter_touch_scale.dart';

@protected
mixin TouchScaleContext {
  TickerProvider get vsync;
  Duration get duration;
  Curve get curve;
  Duration get reverseDuration;
  Curve get reverseCurve;
  Duration? get previewDuration;
  TouchScaleCallPhase get callPhase;
  TouchScaleBehavior get behavior;
}
