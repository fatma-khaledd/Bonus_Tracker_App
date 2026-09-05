import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'core/theme/theme.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const MyApp(),
    ),
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

      // App Theme Configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,

      // DevicePreview Support
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

      home: const LoginScreen(),
    );
  }
}
