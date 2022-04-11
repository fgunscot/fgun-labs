import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../authentication/authentication_widget_test.mocks.dart';
import 'navigation_widget_test.mocks.dart';

import 'package:lab0_tested_base/src/home/home_view.dart';
import 'package:lab0_tested_base/src/authentication/authentication_view.dart';
import 'package:lab0_tested_base/src/authentication/authentication_controller.dart';
import 'package:lab0_tested_base/src/settings/settings_view.dart';
import 'package:lab0_tested_base/src/settings/settings_controller.dart';
import 'package:lab0_tested_base/src/settings/settings_service.dart';

class TestApp extends StatelessWidget {
  const TestApp({
    Key? key,
    required this.mockNavigatorObserver,
    this.settingsController,
    this.authController,
  }) : super(key: key);

  final MockNavigatorObserver mockNavigatorObserver;
  final SettingsController? settingsController;
  final AuthenticationController? authController;

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

    setUp(() {
      mockNavigatorObserver = MockNavigatorObserver();
      settingsController = SettingsController(SettingsService());
      authController = AuthenticationController(MockAuthenticationService());
    });

    Future<void> _buildTestAppFilled(WidgetTester tester) async {
      await settingsController.loadSettings();

      await tester.pumpWidget(TestApp(
        mockNavigatorObserver: mockNavigatorObserver,
        settingsController: settingsController,
        authController: authController,
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
