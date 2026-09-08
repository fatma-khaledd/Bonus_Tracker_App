import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<String?>? onLogin(LoginData data) {
    // FirebaseAuth.instance
    return null; //return null mean logged in succesfully
  }

  Future<String?>? onRecoverPassword(String email) {
    // send reset email
    return null;
  }

  LoginTheme buildTheme() {
    return LoginTheme(
      errorColor: AppColors.error,
      primaryColor: AppColors.loginScreenBackground, //background color
      bodyStyle: AppTextStyles.loginbodySecondary, //"forgot password" style
      cardTheme: CardTheme(
        color: AppColors.loginCardBackground,
        surfaceTintColor: AppColors.chipUnselected,
      ),
      buttonTheme: LoginButtonTheme(
        splashColor: AppColors.textOnPrimary,
        backgroundColor: AppColors.loginAccentText,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      inputTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.background,
        labelStyle: AppTextStyles.loginInputLabel,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.loginInputBorder),
        ),
      ),
      buttonStyle: AppTextStyles.button,

      titleStyle: AppTextStyles.loginScreenTitle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterLogin(
          title: 'LOGIN',
          theme: buildTheme(),
          onLogin: onLogin,
          onRecoverPassword: onRecoverPassword,
          onSubmitAnimationCompleted: () {
            //will handeled with Navigation
          },
        ),
        //use stack so i can add the Penguin and the Crescent moon , osc logo and so on...
      ],
    );
  }
}
