//                                                     2
//  AUTH REPOSITORY  -  Outlines the possible auth operation for this app.

import 'package:reddit_app/features/auth/domain/entities/app_user.dart';

abstract class AuthRepo {
  Stream<AppUser?> authStateChanges();
  Future<void> loginWithEmailPass(String email, String pass);
  Future<void> registerWithEmailPass(String name, String email, String pass);
  Future<void> logout();
  Future<void> sendPassResetEmail(String email);
  Future<void> deleteAcc();
  Future<void> signInWithGmail();
}

// Future-based:   login → return user → set state manually
// Stream-based:   login → Firebase updates → stream emits → UI rebuilds


// throw: Creates a new error and throws it. If catched in same try-catch block, catch block will handle it. After catch, code continues normally.
// rethrow: Doesn’t create a new error; resends the same error upward to whoever called your function. The current function stops execution after rethrow.