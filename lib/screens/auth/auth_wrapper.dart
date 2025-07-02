// lib/screens/auth/auth_wrapper.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas1/providers/auth_provider.dart';
import 'package:uas1/screens/main_screen.dart'; // Akan dibuat nanti
import 'package:uas1/screens/auth/login_screen.dart';
import 'package:uas1/screens/auth/register.screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool showLoginPage = true;

  void toggleScreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.user != null) {
      // User sudah login, tampilkan MainScreen
      return const MainScreen();
    } else {
      // User belum login, tampilkan halaman login/register
      if (showLoginPage) {
        return LoginScreen(showRegisterPage: toggleScreens);
      } else {
        return RegisterScreen(showLoginPage: toggleScreens);
      }
    }
  }
}
