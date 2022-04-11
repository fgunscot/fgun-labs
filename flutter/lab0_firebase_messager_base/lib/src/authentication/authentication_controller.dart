import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lab0_firebase_messager_base/src/authentication/authentication_service.dart';

enum AuthViewStates { authComplete, signInView, registerView }

class AuthenticationController with ChangeNotifier {
  AuthenticationController(this.authService) {
    authService.controller = this;
  }

  AuthViewStates _authState = AuthViewStates.signInView;
  set authState(AuthViewStates state) {
    _authState = state;
    notifyListeners();
  }

  AuthViewStates get authState => _authState;

  final AuthenticationService authService;
  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  void signInWithPassword(String email, String password,
      void Function(FirebaseAuthException e) errorCallback) {
    var model = AuthenticationModel(email: email, password: password);
    authService.signInWithPassword(
      model,
      (e) => errorCallback(e),
    );
  }

  void registerWithPassword(String name, String email, String password,
      void Function(FirebaseAuthException e) errorCallback) {
    var model = AuthenticationModel(
        displayName: name, email: email, password: password);
    authService.registerWithPassword(
      model,
      (e) => errorCallback(e),
    );
  }

  void logOutCurrentUser() => authService.logOutCurrentUser();

  void onUserModelChanged(UserModel? model) {
    _userModel = model;
    if (model != null) {
      authState = AuthViewStates.authComplete;
    } else {
      authState = AuthViewStates.signInView;
    }
    notifyListeners();
  }
}
