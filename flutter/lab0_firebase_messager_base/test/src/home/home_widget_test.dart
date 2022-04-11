import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab0_firebase_messager_base/src/authentication/authentication_view.dart';
import 'package:lab0_firebase_messager_base/src/home/home_view.dart';
import 'package:lab0_firebase_messager_base/src/settings/settings_controller.dart';
import 'package:lab0_firebase_messager_base/src/settings/settings_service.dart';
import 'package:lab0_firebase_messager_base/src/settings/settings_view.dart';
import 'package:mockito/mockito.dart';

import '../navigation/navigation_widget_test.dart';
import '../navigation/navigation_widget_test.mocks.dart';

void main() {
  group('Navigation, from HomeView() - -', () {
    late MockNavigatorObserver mockNavigatorObserver;
    late SettingsController settingsController;

    setUp(() {
      mockNavigatorObserver = MockNavigatorObserver();
      settingsController = SettingsController(SettingsService());
    });

    Future<void> _buildTestApp(WidgetTester tester) async {
      await settingsController.loadSettings();

      await tester.pumpWidget(TestApp(
        mockNavigatorObserver: mockNavigatorObserver,
        settingsController: settingsController,
      ));

      verify(mockNavigatorObserver.didPush(any, any));
    }

    Future<void> _navigateToAuthenticationView(WidgetTester tester) async {
      await tester.tap(find.byKey(HomeView.navToAuthIconButtonKey));
      await tester.pumpAndSettle();
    }

    Future<void> _navigateToDrawer(WidgetTester tester) async {
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
    }

    Future<void> _navigateToSettings(WidgetTester tester) async {
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();
    }

    testWidgets('-> to AuthenticationView()', (WidgetTester tester) async {
      await _buildTestApp(tester);
      await _navigateToAuthenticationView(tester);

      verify(mockNavigatorObserver.didPush(any, any));

      var authFinder = find.byType(AuthenticationView);
      expect(authFinder, findsOneWidget);

      var titleFinder = find.text('Sign In').first;
      var strictMatch = find.descendant(of: authFinder, matching: titleFinder);
      expect(strictMatch, findsOneWidget);
    });

    testWidgets(
        '-> to AuthenticationView(), then pop w/res "sign in cancelled!"',
        (WidgetTester tester) async {
      await _buildTestApp(tester);
      await _navigateToAuthenticationView(tester);

      final Route pushedRoute =
          verify(mockNavigatorObserver.didPush(captureAny, any))
              .captured
              .single;

      String? popResult;
      pushedRoute.popped.then((value) => popResult = value);

      await tester.tap(find.byKey(AuthenticationView.authCancelButtonKey));
      await tester.pumpAndSettle();

      expect(popResult, 'sign in cancelled!');
    });

    testWidgets('-> to Drawer()', (WidgetTester tester) async {
      await _buildTestApp(tester);

      var drawerFinder = find.byType(Drawer);
      expect(drawerFinder, findsNothing);

      await _navigateToDrawer(tester);
      expect(drawerFinder, findsOneWidget);

      var titleFinder = find.text('Drawer Header');
      var strictMatch =
          find.descendant(of: drawerFinder, matching: titleFinder);
      expect(strictMatch, findsOneWidget);
    });

    testWidgets('-> to Drawer(), then to SettingsView()',
        (WidgetTester tester) async {
      await _buildTestApp(tester);
      await _navigateToDrawer(tester);
      var drawerFinder = find.byType(Drawer);
      expect(drawerFinder, findsOneWidget);

      await _navigateToSettings(tester);
      verify(mockNavigatorObserver.didPush(any, any));

      var settingsFinder = find.byType(SettingsView);
      expect(settingsFinder, findsOneWidget);

      var settingsTitleFinder = find.text('Settings');
      var strictSettingsMatch =
          find.descendant(of: settingsFinder, matching: settingsTitleFinder);
      expect(strictSettingsMatch, findsOneWidget);
    });
  });
}
