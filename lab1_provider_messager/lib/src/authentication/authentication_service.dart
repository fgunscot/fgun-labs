import 'package:firebase_auth/firebase_auth.dart';
import 'package:lab1_provider_messager/src/authentication/authentication_controller.dart';

class AuthenticationService {
  AuthenticationService() {
    init();
  }

  AuthenticationController? controller;

  Future<void> init() async {
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        controller!.onUserModelChanged(
            UserModel(displayName: user.displayName, email: user.email));
      } else {
        controller!.onUserModelChanged(null);
      }
    });
  }

  Future<void> signInWithPassword(
    AuthenticationModel model,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: model.email, password: model.password);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  Future<void> registerWithPassword(
    AuthenticationModel model,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: model.email, password: model.password);
      await credential.user!.updateDisplayName(model.displayName);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void logOutCurrentUser() async {
    FirebaseAuth.instance.signOut();
  }
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
