import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab0_firebase_messager_base/src/settings/settings_controller.dart';
import 'package:lab0_firebase_messager_base/src/settings/settings_service.dart';

void main() {
  group('Settings unit tests - -', () {
    late SettingsController settingsController;

    setUp(() {
      settingsController = SettingsController(SettingsService());
    });

    test('-> load settings', () async {
      await settingsController.loadSettings();
      expect(settingsController, isA<SettingsController>());
    });
    test('-> load theme mode', () async {
      await settingsController.loadSettings();
      expect(settingsController.themeMode, ThemeMode.system);
    });
    test('-> change theme mode', () async {
      await settingsController.loadSettings();
      expect(settingsController.themeMode, ThemeMode.system);
      settingsController.updateThemeMode(ThemeMode.dark);
      expect(settingsController.themeMode, ThemeMode.dark);
    });
  });
}
