import 'package:budget_tracker/classes/dbhelper.dart';
import 'package:budget_tracker/screens/home_page.dart';
import 'package:budget_tracker/screens/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  Future<void> saveLoginState(
      {required bool isLoggedIn, required String email}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
    await prefs.setString("email", email);
  }

  Future<void> _submit() async {
    final bool isValid = _key.currentState!.validate();
    if (!isValid) {
      return;
    }
    _key.currentState!.save();
    String email = _emailController.text.trim().toString();
    String password = _passwordController.text.trim().toString();
    bool isLogin = await DBHelper.getInstance()
        .loginUser(email: email, password: password);
    if (isLogin) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => HomePage(
                    email: email,
                  )));
      saveLoginState(isLoggedIn: true, email: email);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Invalid email or password")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _key,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                style: Theme.of(context).textTheme.titleSmall,
                cursorColor: Colors.amber,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter a email";
                  }
                  if (!value.contains("@gmail.com")) {
                    return "Enter a valid email (e.g., example@gmail.com)";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  label: Text(
                    "Enter email",
                  ),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                style: Theme.of(context).textTheme.titleSmall,
                cursorColor: Colors.amber,
                keyboardType: TextInputType.visiblePassword,
                controller: _passwordController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter Password";
                  }
                  if (value.length < 6) {
                    return "Password must be at least 6 characters long";
                  }
                  return null;
                },
                obscureText: true,
                decoration: InputDecoration(
                  label: Text(
                    "Enter password",
                  ),
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(
                  "Sign In",
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.transparent,
                      side: BorderSide(color: Colors.transparent),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => SignUpPage(),
                        ),
                      );
                    },
                    child: Text(
                      "Sign Up",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
