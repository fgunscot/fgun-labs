import 'package:lab0_tested_base/src/authentication/authentication_controller.dart';

class AuthenticationService {
  AuthenticationService() {
    init();
  }

  AuthenticationController? controller;

  Future<void> init() async {
    // listen to changes on user state
  }

  Future<void> signInWithPassword(
    AuthenticationModel model,
    void Function(Exception e) errorCallback,
  ) async {
    try {} on Exception catch (e) {
      errorCallback(e);
    }
  }

  Future<void> registerWithPassword(
    AuthenticationModel model,
    void Function(Exception e) errorCallback,
  ) async {
    try {} on Exception catch (e) {
      errorCallback(e);
    }
  }

  void logOutCurrentUser() async {}
}

class UserModel {
  UserModel({
    required this.displayName,
    required this.email,
  });
  String? displayName;
  String? email;

  UserModel.fromJson(Map<String, dynamic> json)
      : displayName = json['display_name']!,
        email = json['email']!;

  Map<String, dynamic> toJson() => {
        'display_name': displayName,
        'email': email,
      };
}

class AuthenticationModel {
  AuthenticationModel({
    this.displayName,
    required this.email,
    required this.password,
  });
  String? displayName;
  String email;
  String password;
}
