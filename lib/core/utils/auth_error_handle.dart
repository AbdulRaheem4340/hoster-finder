

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hostel_finder/services/auth_service.dart';

class AuthErrorHandler {
  AuthErrorHandler._();

  static String getMessage(Object error) {
    if (error is NoInternetException) {
      return error.message;
    }

    if (error is FirebaseAuthException) {
      return _handleFirebaseError(error);
    }

    return "Something went wrong. Please try again.";
  }

  static String _handleFirebaseError(FirebaseAuthException error) {
    debugPrint('🔥 Firebase Error Code: ${error.code}');
    debugPrint('🔥 Firebase Error Message: ${error.message}');

    switch (error.code) {
      // ===== LOGIN ERRORS =====
      case 'invalid-credential':
        return "Incorrect email or password.\n"
            "If you don't have an account, please register first.";

      case 'invalid-email':
        return "Please enter a valid email address (e.g. user@gmail.com)";

      case 'user-disabled':
        return "This account has been disabled. Please contact support.";

      // ===== SIGNUP ERRORS =====
      case 'email-already-in-use':
        return "This email is already registered. Please login instead.";

      case 'weak-password':
        return "Password is too weak. Use at least 6 characters.";

      case 'operation-not-allowed':
        return "Email/password sign-in is not enabled. Contact support.";

      // ===== FALLBACKS (enumeration protection OFF) =====
      case 'user-not-found':
        return "No account found with this email. Please register first.";

      case 'wrong-password':
        return "Incorrect password. Please try again.";

      // ===== NETWORK =====
      case 'network-request-failed':
        return "No internet connection. Please check your network.";

      case 'too-many-requests':
        return "Too many failed attempts. Please wait a few minutes.";

      // ===== SECURITY =====
      case 'requires-recent-login':
        return "For security, please log in again to continue.";

      default:
        debugPrint(
          'Unhandled Firebase error: ${error.code} - ${error.message}',
        );
        return error.message ?? "Authentication failed. Please try again.";
    }
  }
}
