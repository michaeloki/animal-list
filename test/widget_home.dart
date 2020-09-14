import 'package:animal_inventory/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  testWidgets('Find Widgets', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MainHomeApp());
    expect(find.byType(Container),findsWidgets);

    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump();
  });
}
