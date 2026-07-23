import 'package:flutter/widgets.dart';
import 'package:flutter_touch_scale/flutter_touch_scale.dart';

@protected
mixin TouchScaleContext {
  BuildContext get context;
  TickerProvider get vsync;
  Duration get duration;
  Curve get curve;
  Duration get reverseDuration;
  Curve get reverseCurve;
  Duration? get previewDuration;
  TouchScaleCallPhase get callPhase;
  TouchScaleBehavior get behavior;
  TouchScaleRejectBehavior get rejectBehavior;
}
