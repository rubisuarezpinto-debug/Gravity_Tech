import 'package:flutter_test/flutter_test.dart';
import 'package:gravity_tech/app.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const GravityTechApp());
    expect(find.byType(GravityTechApp), findsOneWidget);
  });
}
