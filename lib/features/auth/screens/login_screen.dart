import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/repositories/authentication/firebase_authentication.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

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
          onLogin: FirebaseAuthentication.onLogin,
          onRecoverPassword: FirebaseAuthentication.onRecover,
          onSubmitAnimationCompleted: () {
            //will handeled with Navigation
          },
        ),
        //use stack so i can add the Penguin and the Crescent moon , osc logo and so on...
      ],
    );
  }
}
