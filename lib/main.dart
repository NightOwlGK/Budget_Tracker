import 'package:budget_tracker/classes/theme_own.dart';
import 'package:budget_tracker/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeOwn.lightTheme,
      darkTheme: ThemeOwn.darkTheme,
      home: SplashScreen(),
    ),
  );
}
