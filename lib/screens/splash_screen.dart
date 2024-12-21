import 'package:budget_tracker/screens/home_page.dart';
import 'package:budget_tracker/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeanimation;
  late bool isAlreadyLogin = false;
  late String email = "";

  void getInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    isAlreadyLogin = pref.getBool("isLoggedIn") ?? false;
    email = pref.getString("email") ?? "";
  }

  @override
  void initState() {
    super.initState();
    getInfo();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fadeanimation = Tween<double>(begin: 0.0, end: 1).animate(_controller);
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status.isCompleted) {
        _controller.reverse();
      } else if (status.isDismissed) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) =>
                isAlreadyLogin ? HomePage(email: email) : LoginPage(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeanimation,
        child: Center(
          child: Text(
            "Budget\nTracker",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
