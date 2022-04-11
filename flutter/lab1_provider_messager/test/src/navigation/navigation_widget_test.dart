import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab1_provider_messager/src/chat/chat_controller.dart';
import 'package:lab1_provider_messager/src/chat/chat_service.dart';
import 'package:lab1_provider_messager/src/chat/chat_view.dart';
import 'package:lab1_provider_messager/src/messager/messager_controller.dart';
import 'package:lab1_provider_messager/src/messager/messager_view.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../authentication/authentication_widget_test.mocks.dart';
import 'navigation_widget_test.mocks.dart';

import 'package:lab1_provider_messager/src/authentication/authentication_view.dart';
import 'package:lab1_provider_messager/src/authentication/authentication_controller.dart';
import 'package:lab1_provider_messager/src/settings/settings_view.dart';
import 'package:lab1_provider_messager/src/settings/settings_controller.dart';
import 'package:lab1_provider_messager/src/settings/settings_service.dart';

class TestApp extends StatelessWidget {
  const TestApp({
    Key? key,
    required this.mockNavigatorObserver,
  }) : super(key: key);

  final MockNavigatorObserver mockNavigatorObserver;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                          signOut: controller.logOutCurrentUser,
                        ));

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
      navigatorObservers: [mockNavigatorObserver],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.mockNavigatorObserver,
    this.settingsController,
  }) : super(key: key);

  final MockNavigatorObserver mockNavigatorObserver;
  final SettingsController? settingsController;

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
            value: settingsController ?? SettingsController(SettingsService())),
        ChangeNotifierProvider<AuthenticationController>(
            create: (context) =>
                AuthenticationController(MockAuthenticationService())),
        ChangeNotifierProvider<MessagerController>.value(
            value: messagerController),
      ],
      child: TestApp(
        mockNavigatorObserver: mockNavigatorObserver,
      ),
    );
  }
}

@GenerateMocks(
  [],
  customMocks: [
    MockSpec<NavigatorObserver>(returnNullOnMissingStub: true),
  ],
)
void main() {
  group('Navigation widget tests, from HomeView() - -', () {
    late MockNavigatorObserver mockNavigatorObserver;
    late SettingsController settingsController;

    setUp(() async {
      mockNavigatorObserver = MockNavigatorObserver();
      settingsController = SettingsController(SettingsService());
      await settingsController.loadSettings();
    });

    Future<void> _buildTestApp(WidgetTester tester) async {
      await tester.pumpWidget(MyApp(
          mockNavigatorObserver: mockNavigatorObserver,
          settingsController: settingsController));

      verify(mockNavigatorObserver.didPush(any, any));
    }

    // testWidgets('-> Building TestApp() filled', (WidgetTester tester) async {
    //   await _buildTestApp(tester);

    //   var homeFinder = find.byType(MessageView);
    //   expect(homeFinder, findsOneWidget);
    // });
  });
}