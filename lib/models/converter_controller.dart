import 'package:flutter/foundation.dart';

enum UnitCategory {
  length('Length'),
  weight('Weight'),
  temperature('Temperature');

  const UnitCategory(this.label);

  final String label;
}

enum Unit {
  meter('Meter', 'm', UnitCategory.length),
  kilometer('Kilometer', 'km', UnitCategory.length),
  gram('Gram', 'g', UnitCategory.weight),
  kilogram('Kilogram', 'kg', UnitCategory.weight),
  celsius('Celsius', '°C', UnitCategory.temperature),
  fahrenheit('Fahrenheit', '°F', UnitCategory.temperature);

  const Unit(this.label, this.symbol, this.category);

  final String label;
  final String symbol;
  final UnitCategory category;

  static List<Unit> forCategory(UnitCategory category) =>
      Unit.values.where((unit) => unit.category == category).toList();
}

class ConverterController extends ChangeNotifier {
  UnitCategory _category = UnitCategory.length;
  Unit _fromUnit = Unit.meter;
  Unit _toUnit = Unit.kilometer;
  String _input = '1';

  UnitCategory get category => _category;
  Unit get fromUnit => _fromUnit;
  Unit get toUnit => _toUnit;
  String get input => _input;

  double? get result {
    final value = double.tryParse(_input);
    if (value == null || !value.isFinite) return null;
    return convert(value, _fromUnit, _toUnit);
  }

  String get formattedResult {
    final value = result;
    if (value == null) return '—';
    if (value == value.roundToDouble()) return value.toStringAsFixed(0);
    return value.toStringAsFixed(6).replaceFirst(RegExp(r'\.?0+$'), '');
  }

  void setCategory(UnitCategory category) {
    if (_category == category) return;
    final units = Unit.forCategory(category);
    _category = category;
    _fromUnit = units.first;
    _toUnit = units.last;
    notifyListeners();
  }

  void setInput(String input) {
    _input = input;
    notifyListeners();
  }

  void setFromUnit(Unit unit) {
    if (unit.category != _category) {
      throw ArgumentError.value(unit, 'unit', 'Unit must match the category');
    }
    if (_fromUnit == unit) return;
    _fromUnit = unit;
    notifyListeners();
  }

  void setToUnit(Unit unit) {
    if (unit.category != _category) {
      throw ArgumentError.value(unit, 'unit', 'Unit must match the category');
    }
    if (_toUnit == unit) return;
    _toUnit = unit;
    notifyListeners();
  }

  void swapUnits() {
    final previousFrom = _fromUnit;
    _fromUnit = _toUnit;
    _toUnit = previousFrom;
    notifyListeners();
  }

  static double convert(double value, Unit from, Unit to) {
    if (from.category != to.category) {
      throw ArgumentError('Units must belong to the same category');
    }
    if (from == to) return value;

    return switch ((from, to)) {
      (Unit.meter, Unit.kilometer) => value / 1000,
      (Unit.kilometer, Unit.meter) => value * 1000,
      (Unit.gram, Unit.kilogram) => value / 1000,
      (Unit.kilogram, Unit.gram) => value * 1000,
      (Unit.celsius, Unit.fahrenheit) => value * 9 / 5 + 32,
      (Unit.fahrenheit, Unit.celsius) => (value - 32) * 5 / 9,
      _ => throw ArgumentError('Unsupported unit conversion'),
    };
  }
}
