import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_touch_scale/flutter_touch_scale.dart';

void main() {
  testWidgets('does not call onPress when pointer is canceled', (tester) async {
    int pressCount = 0;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: TouchScale(
            previewDuration: Duration.zero,
            reverseDuration: Duration.zero,
            duration: Duration.zero,
            onPress: () => pressCount++,
            child: const SizedBox(width: 100, height: 100),
          ),
        ),
      ),
    );

    final gesture = await tester.startGesture(tester.getCenter(find.byType(TouchScale)));
    await tester.pump();
    await gesture.cancel();
    await tester.pumpAndSettle();

    expect(pressCount, 0);
  });

  testWidgets('does not start an interaction when onPress is null', (tester) async {
    int pressStartCount = 0;
    int pressEndCount = 0;
    int scaleStartCount = 0;
    int scaleEndCount = 0;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: TouchScale(
            previewDuration: Duration.zero,
            onPressStart: () => pressStartCount++,
            onPressEnd: () => pressEndCount++,
            onScaleStart: () => scaleStartCount++,
            onScaleEnd: () => scaleEndCount++,
            child: const SizedBox(width: 100, height: 100),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TouchScale));
    await tester.pumpAndSettle();

    expect(pressStartCount, 0);
    expect(pressEndCount, 0);
    expect(scaleStartCount, 0);
    expect(scaleEndCount, 0);
  });
}
