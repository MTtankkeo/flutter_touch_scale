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
            duration: Duration.zero,
            reverseDuration: Duration.zero,
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
}
