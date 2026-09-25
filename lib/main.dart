// import 'package:bonus_tracker_app/features/auth/screens/home/home_screen.dart';
import 'package:bonus_tracker_app/features/auth/screens/home/home_screen.dart';
import 'package:bonus_tracker_app/features/auth/screens/login_screen.dart';
import 'package:bonus_tracker_app/firebase_options.dart';
import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'core/theme/theme.dart';
// import 'features/auth/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    DevicePreview(enabled: !kReleaseMode, builder: (context) => const MyApp()),
  );
}

/// Root application widget configuring global themes and preview settings.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mohsens Tracker',
      debugShowCheckedModeBanner: false,

      //Device Preview
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

      // App Theme Configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,

      home: const LoginScreen(),
    );
  }
}
