import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lab1_provider_messager/src/authentication/authentication_service.dart';

import 'package:lab1_provider_messager/src/authentication/authentication_view.dart';
import 'package:lab1_provider_messager/src/authentication/authentication_controller.dart';
import 'package:lab1_provider_messager/src/chat/chat_controller.dart';
import 'package:lab1_provider_messager/src/chat/chat_service.dart';
import 'package:lab1_provider_messager/src/chat/chat_view.dart';
import 'package:lab1_provider_messager/src/messager/messager_controller.dart';
import 'package:lab1_provider_messager/src/messager/messager_view.dart';
import 'package:lab1_provider_messager/src/settings/settings_service.dart';
import 'package:lab1_provider_messager/src/settings/settings_view.dart';
import 'package:lab1_provider_messager/src/settings/settings_controller.dart';
import 'package:provider/provider.dart';

class MessagerApp extends StatelessWidget {
  const MessagerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'app',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
      ],

      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.appTitle,

      // Define a light and dark color theme. Then, read the user's
      // preferred ThemeMode (light, dark, or system default) from the
      // SettingsController to display the correct theme.
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: context.watch<SettingsController>().themeMode,
      // Provider.of<SettingsController>(context, listen: false).themeMode,

      // Define a function to handle named routes in order to support
      // Flutter web url navigation and deep linking.
      onGenerateRoute: (RouteSettings routeSettings) {
        return MaterialPageRoute<void>(
          settings: routeSettings,
          builder: (BuildContext context) {
            switch (routeSettings.name) {
              case SettingsView.routeName:
                return Consumer<SettingsController>(
                    builder: (_, controller, __) => SettingsView(
                        themeMode: controller.themeMode,
                        dropdownOnChange: controller.updateThemeMode));

              case AuthenticationView.routeName:
                return Consumer<AuthenticationController>(
                    builder: (_, controller, __) => AuthenticationView(
                        authState: controller.authState,
                        updateAuthState: controller.updateAuthState,
                        registerWithPassword: controller.registerWithPassword,
                        signInWithPassword: controller.signInWithPassword,
                        signOut: controller.logOutCurrentUser));

              /*
              *     should do some testing into the notifier here, check if it's 
              *     being disposed, or else this could cause memory leaks.
              */
              case ChatView.routeName:
                final args = routeSettings.arguments as int;
                final chat = context.watch<MessagerController>().getChat(args);
                return ChangeNotifierProvider<ChatController>(
                    create: (context) => ChatController(chat),
                    child: const ChatView());

              case MessagerView.routeName:
              default:
                return MessagerView(
                    chats: context.watch<MessagerController>().chats);
            }
          },
        );
      },
    );
  }
}

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    MessagerController messagerController = MessagerController(chat: [
      ChatModel(name: 'steven', messages: []),
      ChatModel(name: 'jeff', messages: []),
      ChatModel(name: 'james', messages: [])
    ]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsController>.value(
            value: settingsController),
        ChangeNotifierProvider<AuthenticationController>(
            create: (context) =>
                AuthenticationController(AuthenticationService())),
        ChangeNotifierProvider<MessagerController>.value(
            value: messagerController),
      ],
      child: const MessagerApp(),
    );
  }
}
