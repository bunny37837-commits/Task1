import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskremind_pro/main.dart';

void main() {
  testWidgets('app renders title', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: TaskRemindApp()));
    expect(find.text('TaskRemind Pro'), findsOneWidget);
  });
}
