import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{REPLACEME}/src/chat/chat_controller.dart';
import 'package:{REPLACEME}/src/chat/chat_view.dart';
import 'package:{REPLACEME}/src/messager/messager_controller.dart';
import 'package:{REPLACEME}/src/messager/messager_view.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../authentication/authentication_widget_test.mocks.dart';
import 'navigation_widget_test.mocks.dart';

import 'package:{REPLACEME}/src/home/home_view.dart';
import 'package:{REPLACEME}/src/authentication/authentication_view.dart';
import 'package:{REPLACEME}/src/authentication/authentication_controller.dart';
import 'package:{REPLACEME}/src/settings/settings_view.dart';
import 'package:{REPLACEME}/src/settings/settings_controller.dart';
import 'package:{REPLACEME}/src/settings/settings_service.dart';

class TestApp extends StatelessWidget {
  const TestApp({
    Key? key,
    required this.mockNavigatorObserver,
    this.settingsController,
    this.authController,
    this.messagerController,
  }) : super(key: key);

  final MockNavigatorObserver mockNavigatorObserver;
  final SettingsController? settingsController;
  final AuthenticationController? authController;
  final MessagerController? messagerController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (RouteSettings routeSettings) {
        return MaterialPageRoute<void>(
          settings: routeSettings,
          builder: (BuildContext context) {
            switch (routeSettings.name) {
              case SettingsView.routeName:
                return SettingsView(
                    controller: settingsController ??
                        SettingsController(SettingsService()));

              case AuthenticationView.routeName:
                return AuthenticationView(
                    controller: authController ??
                        AuthenticationController(MockAuthenticationService()));

              case MessagerView.routeName:
                return MessagerView(
                    controller:
                        messagerController ?? MessagerController(chat: []));

              case ChatView.routeName:
                final args = routeSettings.arguments as int;
                final chatController =
                    ChatController(messagerController!.chats[args]);
                return ChatView(controller: chatController);

              case HomeView.routeName:
              default:
                return const HomeView();
            }
          },
        );
      },
      navigatorObservers: [mockNavigatorObserver],
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
    late AuthenticationController authController;
    late MessagerController messagerController;

    setUp(() {
      mockNavigatorObserver = MockNavigatorObserver();
      settingsController = SettingsController(SettingsService());
      authController = AuthenticationController(MockAuthenticationService());
      messagerController = MessagerController(chat: []);
    });

    Future<void> _buildTestAppFilled(WidgetTester tester) async {
      await settingsController.loadSettings();

      await tester.pumpWidget(TestApp(
        mockNavigatorObserver: mockNavigatorObserver,
        settingsController: settingsController,
        authController: authController,
        messagerController: messagerController,
      ));

      verify(mockNavigatorObserver.didPush(any, any));
    }

    Future<void> _buildTestAppEmpty(WidgetTester tester) async {
      await tester.pumpWidget(TestApp(
        mockNavigatorObserver: mockNavigatorObserver,
      ));

      verify(mockNavigatorObserver.didPush(any, any));
    }

    testWidgets('-> Building TestApp() filled', (WidgetTester tester) async {
      await _buildTestAppFilled(tester);

      var homeFinder = find.byType(HomeView);
      expect(homeFinder, findsOneWidget);
    });

    testWidgets('-> Building TestApp() empty', (WidgetTester tester) async {
      await _buildTestAppEmpty(tester);

      var homeFinder = find.byType(HomeView);
      expect(homeFinder, findsOneWidget);
    });
  });
}
