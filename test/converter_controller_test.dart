import 'package:flutter_test/flutter_test.dart';

import 'package:assignment_m_30/models/converter_controller.dart';

void main() {
  group('ConverterController', () {
    test('converts the requested length and weight pairs', () {
      expect(
        ConverterController.convert(10, Unit.kilometer, Unit.meter),
        10000,
      );
      expect(ConverterController.convert(2500, Unit.gram, Unit.kilogram), 2.5);
      expect(ConverterController.convert(3, Unit.kilogram, Unit.gram), 3000);
    });

    test('converts temperatures in both directions', () {
      expect(ConverterController.convert(0, Unit.celsius, Unit.fahrenheit), 32);
      expect(
        ConverterController.convert(212, Unit.fahrenheit, Unit.celsius),
        100,
      );
    });

    test('updates result when input or units change and swaps units', () {
      final controller = ConverterController();
      addTearDown(controller.dispose);

      expect(controller.formattedResult, '0.001');
      controller.setInput('10');
      expect(controller.formattedResult, '0.01');
      controller.setFromUnit(Unit.kilometer);
      controller.setToUnit(Unit.meter);
      expect(controller.formattedResult, '10000');

      controller.swapUnits();
      expect(controller.fromUnit, Unit.meter);
      expect(controller.toUnit, Unit.kilometer);
      expect(controller.formattedResult, '0.01');
    });

    test('category changes select units from the new category', () {
      final controller = ConverterController();
      addTearDown(controller.dispose);

      controller.setCategory(UnitCategory.temperature);

      expect(controller.fromUnit, Unit.celsius);
      expect(controller.toUnit, Unit.fahrenheit);
      expect(controller.formattedResult, '33.8');
    });

    test('shows a placeholder for invalid input', () {
      final controller = ConverterController();
      addTearDown(controller.dispose);

      controller.setInput('not a number');

      expect(controller.formattedResult, '—');
    });
  });
}
