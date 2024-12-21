import 'package:budget_tracker/classes/dbhelper.dart';
import 'package:budget_tracker/screens/login_page.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  Future<void> _submit() async {
    final bool isValid = _key.currentState!.validate();
    if (!isValid) {
      return;
    }
    _key.currentState!.save();

    String username = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    bool isUserAdded = await DBHelper.getInstance()
        .addUser(username: username, email: email, password: password);

    if (isUserAdded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User registered successfully!")),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email is already registered!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _key,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                style: Theme.of(context).textTheme.titleSmall,
                cursorColor: Colors.amber,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter fullname";
                  }
                  return null;
                },
                controller: _nameController,
                decoration: InputDecoration(
                  label: Text(
                    "Enter fullname",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                style: Theme.of(context).textTheme.titleSmall,
                cursorColor: Colors.amber,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter a valid email";
                  }
                  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
                    return "Enter a valid email address";
                  }
                  return null;
                },
                controller: _emailController,
                decoration: InputDecoration(
                  label: Text(
                    "Enter email",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                style: Theme.of(context).textTheme.titleSmall,
                cursorColor: Colors.amber,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter password";
                  }
                  if (value.length < 6) {
                    return "Password must be at least 6 characters long";
                  }
                  return null;
                },
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  label: Text(
                    "Enter password",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                style: Theme.of(context).textTheme.titleSmall,
                cursorColor: Colors.amber,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Confirm your password";
                  }
                  if (value != _passwordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  label: Text(
                    "Confirm password",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text("Sign Up"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
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
                        MaterialPageRoute(builder: (_) => LoginPage()),
                      );
                    },
                    child: Text(
                      "Sign In",
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
