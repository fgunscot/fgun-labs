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
