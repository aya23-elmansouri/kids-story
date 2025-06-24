import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app8/start_screen.dart'; // تأكد من المسار الصحيح للملف

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // قم ببناء التطبيق باستخدام StartScreen
    await tester.pumpWidget(
      const MaterialApp(
        home: StartScreen(),
      ),
    );

    // اختبارات تجريبية (يمكنك حذفها إن لم تكن تستخدم عدادًا)
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });
}
