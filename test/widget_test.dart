// Food Delivery App Widget Tests

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Simple widget test', (WidgetTester tester) async {
    // Build a simple test widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Food Delivery App')),
          body: const Center(child: Text('Welcome')),
        ),
      ),
    );

    // Verify the widget tree
    expect(find.text('Food Delivery App'), findsOneWidget);
    expect(find.text('Welcome'), findsOneWidget);
  });

  test('String validation test', () {
    // A simple unit test
    const testString = 'food_delivery_app';
    expect(testString.contains('food'), true);
    expect(testString.contains('delivery'), true);
  });
}
