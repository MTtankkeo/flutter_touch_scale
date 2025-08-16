import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_touch_scale/flutter_touch_scale.dart';

/// A widget that applies a touch-based scaling effect to its child.
class RenderTouchScale extends SingleChildRenderObjectWidget {
  const RenderTouchScale({
    super.key,
    required this.resolver,
    required this.controller,
    required super.child,
  });

  final TouchScaleResolver resolver;
  final TouchScaleController controller;

  @override
  RenderObject createRenderObject(BuildContext _) {
    return _TouchScaleRenderBox(resolver: resolver, controller: controller);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderObject renderObject,
  ) {
    (renderObject as _TouchScaleRenderBox)
      ..controller = controller
      ..resolver = resolver;
  }
}

class _TouchScaleRenderBox extends RenderProxyBox {
  _TouchScaleRenderBox({
    required this.resolver,
    required TouchScaleController controller,
  }) {
    _controller = controller;
    _controller.addListener(markNeedsPaint);
  }

  late TouchScaleResolver resolver;

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
  void detach() {
    _controller.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void performLayout() {
    child.layout(constraints, parentUsesSize: true);
    size = child.size;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final double minScale = resolver.transform(size);
    final double scale = Tween(
      begin: 1.0,
      end: minScale,
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
