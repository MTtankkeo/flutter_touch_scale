// ignore_for_file: deprecated_member_use

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_touch_scale/flutter_touch_scale.dart';

/// A widget that applies a touch-based scaling effect to its child.
class RenderTouchScale extends SingleChildRenderObjectWidget {
  const RenderTouchScale({
    super.key,
    required this.scale,
    required this.resolver,
    required this.controller,
    required super.child,
  });

  final double scale;
  final TouchScaleResolver resolver;
  final TouchScaleController controller;

  @override
  RenderObject createRenderObject(BuildContext _) {
    return _TouchScaleRenderBox(
      scale: scale,
      resolver: resolver,
      controller: controller,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderObject renderObject,
  ) {
    (renderObject as _TouchScaleRenderBox)
      ..controller = controller
      ..resolver = resolver
      ..scale = scale;
  }
}

class _TouchScaleRenderBox extends RenderProxyBox {
  _TouchScaleRenderBox({
    required this.resolver,
    required double scale,
    required TouchScaleController controller,
  }) {
    _scale = scale;
    _controller = controller;
    _controller.addListener(markNeedsPaint);
  }

  late TouchScaleResolver resolver;

  late double _scale;
  double get scale => _scale;
  set scale(double newScale) {
    if (_scale == newScale) return;
    _scale = newScale;
    markNeedsPaint();
  }

  late TouchScaleController _controller;
  TouchScaleController get controller => _controller;
  set controller(TouchScaleController newController) {
    if (_controller == newController) return;
    _controller.removeListener(markNeedsPaint);
    _controller = newController;
    _controller.addListener(markNeedsPaint);
    markNeedsPaint();
  }

  @override
  RenderBox get child => super.child!;

  @override
  void dispose() {
    _controller.removeListener(markNeedsPaint);
    super.dispose();
  }

  @override
  void performLayout() {
    child.layout(constraints, parentUsesSize: true);
    size = child.size;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final double targetScale = resolver.transform(size, this.scale);
    final double scale = Tween(
      begin: 1.0,
      end: targetScale,
    ).transform(_controller.animValue);

    final double dx = size.width / 2;
    final double dy = size.height / 2;

    final Matrix4 transform = Matrix4.identity()
      ..translate(dx, dy)
      ..scale(scale, scale)
      ..translate(-dx, -dy);

    // If the child has its own layer, always use pushTransform.
    if (child.needsCompositing) {
      context.pushTransform(needsCompositing, offset, transform, (
        PaintingContext ctx,
        Offset off,
      ) {
        ctx.paintChild(child, off);
      });
    } else {
      // If the child has no layer, canvas transformation is sufficient.
      final Canvas canvas = context.canvas;
      canvas.save();
      canvas.transform(transform.storage);
      context.paintChild(child, offset);
      canvas.restore();
    }
  }
}
