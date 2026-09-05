import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<String?>? onLogin(LoginData data) {
    return null; //return null mean logged in succesfully
  }

  Future<String?>? onRecoverPassword(String email) {
    // send reset email 
    return null;
  }

  Future<String?>? onSignUp(SignupData data) {
    return null;
  }

  LoginTheme buildTheme() {
    return LoginTheme(
      errorColor: Colors.red,
      primaryColor: Colors.orange[50], //background color
      accentColor: Colors.white, // text color
      cardInitialHeight: 35,
      
      buttonTheme: LoginButtonTheme(
        splashColor: Colors.white,
        backgroundColor: Colors.orange[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100],

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
      buttonStyle: const TextStyle(fontSize: 18),
      pageColorLight: Colors.orange[50],
      pageColorDark: Colors.black,

      titleStyle: GoogleFonts.slabo13px(
        fontSize: 33.5,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        wordSpacing: 0.25,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      onLogin: onLogin,
      onRecoverPassword: onRecoverPassword,
      onSignup: onSignUp,
    );
  }
}
