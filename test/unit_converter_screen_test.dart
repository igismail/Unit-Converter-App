import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:assignment_m_30/main.dart';

void main() {
  testWidgets('updates the displayed result as the user types', (tester) async {
    await tester.pumpWidget(const UnitConverterApp());

    await tester.enterText(
      find.byKey(const ValueKey('conversion-input')),
      '10',
    );
    await tester.pump();

    expect(find.text('0.01'), findsOneWidget);
  });

  testWidgets('swaps units and converts the example value', (tester) async {
    await tester.pumpWidget(const UnitConverterApp());

    await tester.ensureVisible(find.byKey(const ValueKey('swap-units')));
    await tester.tap(find.byKey(const ValueKey('swap-units')));
    await tester.pump();
    await tester.ensureVisible(find.byKey(const ValueKey('conversion-input')));
    await tester.enterText(
      find.byKey(const ValueKey('conversion-input')),
      '10',
    );
    await tester.pump();

    expect(find.text('10000'), findsOneWidget);
    expect(find.text('10 Kilometer = 10000 Meter'), findsOneWidget);
  });

  testWidgets('switches categories and updates the conversion', (tester) async {
    await tester.pumpWidget(const UnitConverterApp());

    await tester.tap(find.text('Temperature'));
    await tester.pump();

    expect(find.text('33.8'), findsOneWidget);
    expect(find.text('1 Celsius = 33.8 Fahrenheit'), findsOneWidget);
  });
}
