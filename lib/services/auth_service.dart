// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream untuk mendengarkan perubahan auth state
  Stream<User?> get user => _auth.authStateChanges();

  // Check if email exists (optional helper method)
  Future<bool> checkEmailExists(String email) async {
    try {
      final methods = await _auth.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Register dengan email dan password
  Future<AuthResult> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    // Cek apakah email sudah terdaftar
    if (await checkEmailExists(email)) {
      return AuthResult.error(
        'Email ini sudah terdaftar. Silakan gunakan email lain.',
      );
    }

    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult.success(result);
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getErrorMessage(e.code);
      if (kDebugMode) {
        debugPrint('Registration error: ${e.code} - ${e.message}');
      }
      return AuthResult.error(errorMessage);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Unexpected registration error: $e');
      }
      return AuthResult.error('Terjadi kesalahan tidak terduga');
    }
  }

  // Sign in dengan email dan password
  Future<AuthResult> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult.success(result);
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getErrorMessage(e.code);
      if (kDebugMode) {
        debugPrint('Sign in error: ${e.code} - ${e.message}');
      }
      return AuthResult.error(errorMessage);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Unexpected sign in error: $e');
      }
      return AuthResult.error('Terjadi kesalahan tidak terduga');
    }
  }

  // Sign out
  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Sign out error: $e');
      }
      return false;
    }
  }

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Reset password
  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        debugPrint('Reset password error: ${e.code} - ${e.message}');
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Unexpected reset password error: $e');
      }
      return false;
    }
  }

  // Helper method untuk mengonversi error code ke pesan yang user-friendly
  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'Pengguna tidak ditemukan';
      case 'wrong-password':
        return 'Password salah';
      case 'email-already-in-use':
        return 'Email sudah digunakan. Silakan gunakan email lain atau masuk dengan email ini.';
      case 'weak-password':
        return 'Password terlalu lemah. Gunakan minimal 6 karakter.';
      case 'invalid-email':
        return 'Format email tidak valid';
      case 'user-disabled':
        return 'Akun telah dinonaktifkan';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi nanti';
      case 'operation-not-allowed':
        return 'Operasi tidak diizinkan';
      case 'network-request-failed':
        return 'Periksa koneksi internet Anda';
      default:
        return 'Terjadi kesalahan. Silakan coba lagi';
    }
  }
}

// Class untuk menangani hasil operasi auth
class AuthResult {
  final bool isSuccess;
  final String? errorMessage;
  final UserCredential? userCredential;

  AuthResult._({
    required this.isSuccess,
    this.errorMessage,
    this.userCredential,
  });

  factory AuthResult.success(UserCredential userCredential) {
    return AuthResult._(isSuccess: true, userCredential: userCredential);
  }

  factory AuthResult.error(String errorMessage) {
    return AuthResult._(isSuccess: false, errorMessage: errorMessage);
  }
}
