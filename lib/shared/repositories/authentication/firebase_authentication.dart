import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login/flutter_login.dart';

class FirebaseAuthentication {
  static Future<String?> onLogin(LoginData data) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  // static Future<String?> onSignup(SignupData data) async {
  //   String? userEmail = data.name;
  //   String? password = data.password;
  //   String? username = data.additionalSignupData?['username'];
  //   if (userEmail != null && password != null) {
  //     try {
  //       await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //         email: data.name!,
  //         password: data.password!,
  //       );
  //       await FirebaseAuth.instance.currentUser?.updateDisplayName(username);
  //       return null;
  //     } on FirebaseAuthException catch (e) {
  //       return e.code;
  //     }
  //   } else {
  //     return 'Username and Password Required';
  //   }
  // }

  //when recover password
  static Future<String?> onRecover(String email) async {
    return null;
  }
}
