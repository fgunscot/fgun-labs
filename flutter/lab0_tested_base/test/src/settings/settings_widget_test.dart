import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab0_tested_base/src/settings/settings_controller.dart';
import 'package:lab0_tested_base/src/settings/settings_service.dart';
import 'package:lab0_tested_base/src/settings/settings_view.dart';

void main() {
  group('Settings widget tests - -', () {
    late SettingsController settingsController;

    setUp(() {
      settingsController = SettingsController(SettingsService());
    });

    Future<MaterialApp> _buildSettingsView(WidgetTester tester) async {
      await settingsController.loadSettings();

      var app = MaterialApp(
        themeMode: settingsController.themeMode,
        home: SettingsView(controller: settingsController),
      );

      await tester.pumpWidget(app);
      return app;
    }

    testWidgets('-> Building settings view', (WidgetTester tester) async {
      await _buildSettingsView(tester);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('-> Set theme mode programmatically',
        (WidgetTester tester) async {
      var app = await _buildSettingsView(tester);

      await tester.pumpWidget(app);
      expect(app.themeMode, ThemeMode.system);

      await settingsController.updateThemeMode(ThemeMode.dark);
      await tester.pumpAndSettle();

      // able to test theme mode has changed in controller
      expect(settingsController.themeMode, ThemeMode.dark);
      // mockito should be able to test if app
      expect(app.themeMode, ThemeMode.system);
    });

    testWidgets('-> Change theme locally', (WidgetTester tester) async {
      var app = await _buildSettingsView(tester);

      expect(app.themeMode, ThemeMode.system);

      expect(
          (tester.widget(find.byKey(SettingsView.themeDropDownButtonKey))
                  as DropdownButton)
              .value,
          equals(ThemeMode.system));

      await tester.tap(find.byKey(SettingsView.themeDropDownButtonKey));
      await tester.pumpAndSettle();

      await tester
          .tap(find.byKey(SettingsView.themeDropDownItemDarkModeKey).last);
      await tester.pumpAndSettle();

      expect(settingsController.themeMode, ThemeMode.dark);
    });
  });
}
