import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab1_provider_messager/src/settings/settings_controller.dart';
import 'package:lab1_provider_messager/src/settings/settings_service.dart';
import 'package:lab1_provider_messager/src/settings/settings_view.dart';
import 'package:provider/provider.dart';

class TestSettings extends StatelessWidget {
  const TestSettings({
    Key? key,
    required this.materialApp,
    required this.settingsController,
  }) : super(key: key);
  final MaterialApp materialApp;
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsController>.value(
      value: settingsController,
      child: materialApp,
    );
  }
}

void main() {
  group('Settings widget tests - -', () {
    late SettingsController settingsController;

    setUp(() async {
      settingsController = SettingsController(SettingsService());
    });

    Future<void> _buildSettingsView(
      WidgetTester tester,
    ) async {
      await settingsController.loadSettings();

      await tester.pumpWidget(
        TestSettings(
          settingsController: settingsController,
          materialApp: MaterialApp(
            home: Consumer<SettingsController>(
              builder: (_, controller, __) => SettingsView(
                themeMode: controller.themeMode,
                dropdownOnChange: (item) async =>
                    controller.updateThemeMode(item),
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('-> Building settings view', (WidgetTester tester) async {
      await _buildSettingsView(tester);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('-> Change theme locally', (WidgetTester tester) async {
      await _buildSettingsView(tester);

      expect(settingsController.themeMode, ThemeMode.system);

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
