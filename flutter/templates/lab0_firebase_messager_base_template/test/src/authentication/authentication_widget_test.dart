// ignore_for_file: avoid_returning_null_for_void

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

import 'package:{REPLACEME}/src/authentication/authentication_controller.dart';
import 'package:{REPLACEME}/src/authentication/authentication_service.dart';
import 'package:{REPLACEME}/src/authentication/authentication_view.dart';

import 'authentication_widget_test.mocks.dart';

@GenerateMocks([AuthenticationService])
void main() {
  late AuthenticationController authController;
  setUp(() {
    authController = AuthenticationController(MockAuthenticationService());
  });

  final user = MockUser(
    isAnonymous: false,
    uid: 'someuid',
    email: 'bob@somedomain.com',
    displayName: 'Bob',
  );

  final auth = MockFirebaseAuth();

  test('-> test sign in with password', () async {
    final result = await auth.signInWithEmailAndPassword(
        email: 'bob@somedomain.com', password: 'hello123');
  });

  group('Test Sign In Auth view - -', () {
    Future<void> _buildSignInForm(
      WidgetTester tester,
      void Function(String, String) signInWithPassword,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
              body: SignInForm(
                  signInWithPassword: (email, password) =>
                      signInWithPassword(email, password),
                  controller: authController)),
        ),
      );
    }

    testWidgets('-> use Sign in form', (WidgetTester tester) async {
      AuthenticationModel? cbModel;
      await _buildSignInForm(
          tester,
          (String email, String password) =>
              cbModel = AuthenticationModel(email: email, password: password));

      await tester.enterText(
          find.byKey(SignInForm.signInFormEmailTextFieldKey), 'test@test.com');
      await tester.enterText(
          find.byKey(SignInForm.signInFormPasswordTextFieldKey), 'Hello123');
      await tester.tap(find.byKey(SignInForm.signInFormSendButtonKey));

      var expectedModel =
          AuthenticationModel(email: 'test@test.com', password: 'Hello123');

      expect(cbModel!.email, expectedModel.email);
      expect(cbModel!.password, expectedModel.password);
    });
  });

  group('Test Register Auth View - -', () {
    Future<void> _buildRegisterForm(
      WidgetTester tester,
      void Function(String, String, String) registerWithPassword,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
              body: RegisterForm(
                  registerWithPassword: (name, email, password) =>
                      registerWithPassword(name, email, password),
                  controller: authController)),
        ),
      );
    }

    testWidgets('-> use register form', (WidgetTester tester) async {
      AuthenticationModel? cbModel;
      await _buildRegisterForm(
          tester,
          (name, email, password) => cbModel = AuthenticationModel(
              displayName: name, email: email, password: password));

      await tester.enterText(
          find.byKey(RegisterForm.registerFormNameTextFieldKey), 'tester1');
      await tester.enterText(
          find.byKey(RegisterForm.registerFormEmailTextFieldKey),
          'test@test.com');
      await tester.enterText(
          find.byKey(RegisterForm.registerFormPasswordTextFieldKey),
          'Hello123');
      await tester.tap(find.byKey(RegisterForm.registerFormSendButtonKey));
      var expectedModel = AuthenticationModel(
          displayName: 'tester1', email: 'test@test.com', password: 'Hello123');

      expect(cbModel!.email, expectedModel.email);
      expect(cbModel!.password, expectedModel.password);
    });
  });

  group('Switch Auth Views - -', () {
    Future<void> _buildAuthView(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AuthenticationView(controller: authController),
        ),
      );
    }

    Future<void> _switchForms(WidgetTester tester) async {
      await tester.tap(find.byKey(AuthenticationView.authSwitchFormsButtonKey));
      await tester.pumpAndSettle();
    }

    testWidgets('-> on correct creditals change screens',
        (WidgetTester tester) async {
      await _buildAuthView(tester);
      expect(find.byType(SignInForm), findsOneWidget);

      auth.userChanges().listen((user) {
        if (user != null) {
          authController.onUserModelChanged(
              UserModel(displayName: user.displayName, email: user.email));
        }
      });

      await auth.signInWithEmailAndPassword(
          email: user.email!, password: 'hello123');
      await tester.pumpAndSettle();

      expect(find.byType(SignInForm), findsNothing);
    });

    testWidgets('-> switch forms, from sign in to register',
        (WidgetTester tester) async {
      await _buildAuthView(tester);
      expect(find.byType(RegisterForm), findsNothing);
      expect(find.byType(SignInForm), findsOneWidget);

      await _switchForms(tester);
      expect(find.byType(RegisterForm), findsOneWidget);
      expect(find.byType(SignInForm), findsNothing);
    });

    testWidgets('-> switch forms, from sign in to register back to sign in',
        (WidgetTester tester) async {
      await _buildAuthView(tester);
      expect(find.byType(RegisterForm), findsNothing);
      expect(find.byType(SignInForm), findsOneWidget);

      await _switchForms(tester);
      expect(find.byType(RegisterForm), findsOneWidget);
      expect(find.byType(SignInForm), findsNothing);

      await _switchForms(tester);
      expect(find.byType(RegisterForm), findsNothing);
      expect(find.byType(SignInForm), findsOneWidget);
    });
  });
}
