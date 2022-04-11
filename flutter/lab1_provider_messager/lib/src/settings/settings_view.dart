import 'package:flutter/material.dart';

import 'package:lab1_provider_messager/src/settings/settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  static const routeName = '/settings';
  const SettingsView({
    Key? key,
    required this.themeMode,
    required this.dropdownOnChange,
  }) : super(key: key);

  final Future<void> Function(ThemeMode?) dropdownOnChange;
  final ThemeMode themeMode;

  static const themeDropDownButtonKey = Key('themeDropDownButton');
  static const themeDropDownItemDarkModeKey = Key('themeDropDownItemDarkMode');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // Glue the SettingsController to the theme selection DropdownButton.
        //
        // When a user selects a theme from the dropdown list, the
        // SettingsController is updated, which rebuilds the MaterialApp.
        child: DropdownButton<ThemeMode>(
          key: themeDropDownButtonKey,
          // Read the selected themeMode from the controller
          value: themeMode,
          // Call the updateThemeMode method any time the user selects a theme.
          onChanged: dropdownOnChange,
          items: const [
            DropdownMenuItem(
              value: ThemeMode.system,
              child: Text('System Theme'),
            ),
            DropdownMenuItem(
              value: ThemeMode.light,
              child: Text('Light Theme'),
            ),
            DropdownMenuItem(
              key: themeDropDownItemDarkModeKey,
              value: ThemeMode.dark,
              child: Text('Dark Theme'),
            )
          ],
        ),
      ),
    );
  }
}
