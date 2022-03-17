import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:{REPLACEME}/src/authentication/authentication_controller.dart';
import 'package:{REPLACEME}/src/authentication/authentication_service.dart';

import 'authentication_widget_test.mocks.dart';

void main() {
  group('Authentication unit tests - -', () {
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
    final authModel =
        AuthenticationModel(email: user.email!, password: 'hello123');

    test('test sign in with password', () async {
      final auth = MockFirebaseAuth(mockUser: user);
      final result = await auth.signInWithEmailAndPassword(
          email: 'bob@somedomain.com', password: 'hello123');
    });

/*
*   i have a problem here that my mock auth service does NOT listen to changes
*   ideally i would change the mock to respound to mockfirebaseauth signinw/empw()
*   then i can check to see if user model i now different 
*/
    // test('', () {
    //   when(authController.authService.signInWithPassword(authModel, (e) {}))
    //       .thenReturn((model) async {
    //     authController.onUserModelChanged(model);
    //   });
    // });
  });
}
