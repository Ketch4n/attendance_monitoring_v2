import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/home.dart';
import 'login.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool showLoginScreen = true;

  @override
  void initState() {
    super.initState();
    checkUserSession();
  }

  // Check if a user session exists in SharedPreferences
  Future<void> checkUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    // If user session exists, navigate to Home; otherwise, show Login
    setState(() {
      showLoginScreen = userId == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showLoginScreen ? const Login() : const Home(),
    );
  }
}
