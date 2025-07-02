// lib/providers/auth_provider.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uas1/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;

  AuthProvider() {
    _authService.user.listen((user) {
      _user = user;
      notifyListeners(); // Beri tahu listener (UI) bahwa status user berubah
    });
  }

  User? get user => _user;

  Future<bool> register(String email, String password) async {
    try {
      dynamic newUser = await _authService.registerWithEmailAndPassword(
        email,
        password,
      );
      return newUser != null;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      dynamic signedInUser = await _authService.signInWithEmailAndPassword(
        email,
        password,
      );
      return signedInUser != null;
    } catch (e) {
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}
