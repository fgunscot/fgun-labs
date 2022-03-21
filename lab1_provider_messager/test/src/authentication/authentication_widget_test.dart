// ignore_for_file: avoid_returning_null_for_void

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

import 'package:lab1_provider_messager/src/authentication/authentication_controller.dart';
import 'package:lab1_provider_messager/src/authentication/authentication_service.dart';
import 'package:lab1_provider_messager/src/authentication/authentication_view.dart';
import 'package:provider/provider.dart';

import 'authentication_widget_test.mocks.dart';

class TestAuthentication extends StatelessWidget {
  const TestAuthentication({
    Key? key,
    required this.controller,
    required this.materialApp,
  }) : super(key: key);
  final AuthenticationController controller;
  final MaterialApp materialApp;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthenticationController>.value(
      value: controller,
      child: materialApp,
    );
  }
}

@GenerateMocks([AuthenticationService])
void main() {
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
    late AuthenticationController authController;

    setUp(() async {
      authController = AuthenticationController(MockAuthenticationService());
    });

    Future<void> _buildSignInForm(WidgetTester tester) async {
      await tester.pumpWidget(
        TestAuthentication(
          controller: authController,
          materialApp: MaterialApp(
            home: Consumer<AuthenticationController>(
              builder: (_, controller, __) => Scaffold(
                  body: SignInForm(
                      signInWithPassword: (email, password) => controller
                          .signInWithPassword(email, password, ((e) {})),
                      updateAuthState: controller.updateAuthState)),
            ),
          ),
        ),
      );
    }

    testWidgets('-> use Sign in form', (WidgetTester tester) async {
      await _buildSignInForm(tester);
      final testModel =
          AuthenticationModel(email: 'test@test.com', password: 'Hello123');
      AuthenticationModel? cbModel;

      when(authController.authService.signInWithPassword(testModel, (e) {}))
          .thenAnswer((anwser) async => print(anwser.positionalArguments));

      await tester.enterText(
          find.byKey(SignInForm.signInFormEmailTextFieldKey), 'test@test.com');
      await tester.enterText(
          find.byKey(SignInForm.signInFormPasswordTextFieldKey), 'Hello123');
      await tester.tap(find.byKey(SignInForm.signInFormSendButtonKey));
      await tester.pumpAndSettle();

      // expect(cbModel!.email, 'test@test.com');
      // expect(cbModel!.password, 'Hello123');
    });
  });

  group('Test Register Auth View - -', () {
    late AuthenticationController authController;

    setUp(() async {
      authController = AuthenticationController(MockAuthenticationService());
    });

    Future<void> _buildRegisterForm(WidgetTester tester) async {
      await tester.pumpWidget(
        TestAuthentication(
          controller: authController,
          materialApp: MaterialApp(
            home: Consumer<AuthenticationController>(
              builder: (_, controller, __) => Scaffold(
                  body: RegisterForm(
                      registerWithPassword: (name, email, password) =>
                          controller.registerWithPassword(
                              name, email, password, ((e) {})),
                      updateAuthState: controller.updateAuthState)),
            ),
          ),
        ),
      );
    }

    testWidgets('-> use register form', (WidgetTester tester) async {
      AuthenticationModel? cbModel;
      await _buildRegisterForm(tester);

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

      // expect(cbModel!.email, expectedModel.email);
      // expect(cbModel!.password, expectedModel.password);
    });
  });

  group('Switch Auth Views - -', () {
    late AuthenticationController authController;

    setUp(() async {
      authController = AuthenticationController(MockAuthenticationService());
    });

    Future<void> _buildAuthView(WidgetTester tester) async {
      await tester.pumpWidget(
        TestAuthentication(
          controller: authController,
          materialApp: MaterialApp(
            home: Consumer<AuthenticationController>(
              builder: (_, controller, __) => Scaffold(
                  body: AuthenticationView(
                      authState: controller.authState,
                      updateAuthState: controller.updateAuthState,
                      registerWithPassword: controller.registerWithPassword,
                      signInWithPassword: controller.signInWithPassword,
                      signOut: controller.logOutCurrentUser)),
            ),
          ),
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
