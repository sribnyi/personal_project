import 'package:flutter_test/flutter_test.dart';
import 'package:personal_project/firebase/firestore-controller.dart';
import 'package:personal_project/screens/home.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FuelApp());
  });
}
