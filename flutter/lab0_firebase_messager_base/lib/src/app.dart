import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:lab0_firebase_messager_base/src/authentication/authentication_view.dart';
import 'package:lab0_firebase_messager_base/src/authentication/authentication_controller.dart';
import 'package:lab0_firebase_messager_base/src/chat/chat_controller.dart';
import 'package:lab0_firebase_messager_base/src/chat/chat_service.dart';
import 'package:lab0_firebase_messager_base/src/chat/chat_view.dart';
import 'package:lab0_firebase_messager_base/src/messager/messager_controller.dart';
import 'package:lab0_firebase_messager_base/src/messager/messager_view.dart';
import 'package:lab0_firebase_messager_base/src/settings/settings_view.dart';
import 'package:lab0_firebase_messager_base/src/settings/settings_controller.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.settingsController,
    required this.authController,
  }) : super(key: key);

  final SettingsController settingsController;
  final AuthenticationController authController;

  @override
  Widget build(BuildContext context) {
    MessagerController messagerController = MessagerController(chat: [
      ChatModel(name: 'steven', messages: []),
      ChatModel(name: 'jeff', messages: []),
      ChatModel(name: 'james', messages: [])
    ]);

    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);

                  case AuthenticationView.routeName:
                    return AuthenticationView(controller: authController);

                  case ChatView.routeName:
                    final args = routeSettings.arguments as int;
                    final chatController =
                        ChatController(messagerController.getChat(args));
                    return ChatView(controller: chatController);

                  case MessagerView.routeName:
                  default:
                    return MessagerView(controller: messagerController);
                  // case HomeView.routeName:
                  // default:
                  //   return const HomeView();
                }
              },
            );
          },
        );
      },
    );
  }
}
