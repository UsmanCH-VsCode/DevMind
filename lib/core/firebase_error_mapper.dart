import 'package:firebase_auth/firebase_auth.dart';

// This is a helper function that takes a FirebaseAuthException and converts it into a friendly, readable message for your app users.

String mapFirebaseAuthError(FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-credential':
    case 'wrong-password':
    case 'user-not-found':
      return 'Invalid email or password';

    case 'email-already-in-use':
      return 'Email already registered';

    case 'weak-password':
      return 'Password too weak';

    case 'too-many-requests':
      return 'Too many attempts. Try later';

    case 'invalid-email':
      return 'Invalid email format';

    case 'requires-recent-login':
      return 'Please login again before deleting your account';

    case 'email-not-verified':
      return 'Please verify your email before login';

    case 'google-sign-in-failed':
      return 'Google sign in failed. Try again';

    default:
      return e.message ?? 'Authentication failed';
  }
}
