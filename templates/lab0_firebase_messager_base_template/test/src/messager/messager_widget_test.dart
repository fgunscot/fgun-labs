import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{REPLACEME}/src/authentication/authentication_view.dart';
import 'package:{REPLACEME}/src/chat/chat_controller.dart';
import 'package:mockito/mockito.dart';

import 'package:{REPLACEME}/src/chat/chat_view.dart';
import 'package:{REPLACEME}/src/chat/chat_service.dart';
import 'package:{REPLACEME}/src/messager/messager_view.dart';
import 'package:{REPLACEME}/src/messager/messager_controller.dart';

import '../navigation/navigation_widget_test.dart';
import '../navigation/navigation_widget_test.mocks.dart';

void main() {
  MessagerController messagerControllerEmpty = MessagerController(chat: []);
  MessagerController messagerController = MessagerController(chat: [
    ChatModel(name: 'steven', messages: []),
    ChatModel(name: 'jeff', messages: []),
    ChatModel(name: 'james', messages: [])
  ]);

  Finder _findKeyByIndex(int i) => find.byKey(Key('chatTileIndex$i'));

  group('Check MessagerView() list is populated - -', () {
    Future<void> _buildMessagerView(
        WidgetTester tester, MessagerController controller) async {
      await tester.pumpWidget(MaterialApp(
        home: MessagerView(controller: controller),
      ));
    }

    testWidgets('-> 3 items being displayed', (WidgetTester tester) async {
      await _buildMessagerView(tester, messagerController);
      expect(_findKeyByIndex(0), findsOneWidget);
      expect(_findKeyByIndex(2), findsOneWidget);
      expect(_findKeyByIndex(3), findsNothing);
    });

    testWidgets('-> 0 items being displayed', (WidgetTester tester) async {
      await _buildMessagerView(tester, messagerControllerEmpty);
      expect(_findKeyByIndex(0), findsNothing);
      expect(_findKeyByIndex(2), findsNothing);
      expect(_findKeyByIndex(3), findsNothing);
    });
  });

  group('Navigation, from MessagerView(), To item in List - -', () {
    late MockNavigatorObserver mockNavigatorObserver;

    setUp(() {
      mockNavigatorObserver = MockNavigatorObserver();
    });

    Future<void> _buildMessagerApp(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case ChatView.routeName:
                    final args = routeSettings.arguments as int;
                    final chatController =
                        ChatController(messagerController.chats[args]);
                    return ChatView(controller: chatController);
                  case MessagerView.routeName:
                  default:
                    return MessagerView(controller: messagerController);
                }
              },
            );
          },
          navigatorObservers: [mockNavigatorObserver],
        ),
      );

      verify(mockNavigatorObserver.didPush(any, any));
    }

    Future<void> _navigateToChatAtIndex1(WidgetTester tester, int index) async {
      await tester.tap(find.byKey(Key('chatTileIndex$index')));
      await tester.pumpAndSettle();
    }

    testWidgets('-> to chat in list at index 0', (WidgetTester tester) async {
      await _buildMessagerApp(tester);
      await _navigateToChatAtIndex1(tester, 0);

      verify(mockNavigatorObserver.didPush(any, any));

      var authFinder = find.byType(ChatView);
      expect(authFinder, findsOneWidget);
    });

    testWidgets('-> to chat in list at index 2', (WidgetTester tester) async {
      await _buildMessagerApp(tester);
      await _navigateToChatAtIndex1(tester, 2);

      verify(mockNavigatorObserver.didPush(any, any));

      var authFinder = find.byType(ChatView);
      expect(authFinder, findsOneWidget);
    });
  });

  group('Navigation, from MessagerView() - -', () {
    late MockNavigatorObserver mockNavigatorObserver;

    setUp(() {
      mockNavigatorObserver = MockNavigatorObserver();
    });

    Future<void> _buildTestApp(WidgetTester tester) async {
      await tester.pumpWidget(TestApp(
        mockNavigatorObserver: mockNavigatorObserver,
        messagerController: messagerController,
      ));

      verify(mockNavigatorObserver.didPush(any, any));
    }

    Future<void> _navigateToAuthenticationView(WidgetTester tester) async {
      await tester.tap(find.byKey(MessagerView.navToAuthIconButtonKey));
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
  });
}
