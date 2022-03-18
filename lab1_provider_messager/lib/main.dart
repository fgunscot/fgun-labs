import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lab1_provider_messager/firebase_options.dart';

import 'package:lab1_provider_messager/src/app.dart';
// import 'package:lab1_provider_messager/src/authentication/authentication_controller.dart';
// import 'package:lab1_provider_messager/src/authentication/authentication_service.dart';
import 'package:lab1_provider_messager/src/settings/settings_controller.dart';
import 'package:lab1_provider_messager/src/settings/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());
  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // final AuthenticationController authController =
  //     AuthenticationController(AuthenticationService());

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(
    settingsController: settingsController,
    // authController: authController,
  ));
}
