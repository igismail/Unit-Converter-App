# Unit Converter

A Flutter app for converting length, weight, and temperature values in real
time. Choose a category, enter a value, select the source and destination
units, or swap the selected units.

The conversion state and calculations are kept in
`lib/models/converter_controller.dart`; the interface is in
`lib/screens/unit_converter_screen.dart`. The app uses Flutter's built-in
`ChangeNotifier` and `ListenableBuilder` for state management.

Run the app with `flutter run` and run the tests with `flutter test`.
