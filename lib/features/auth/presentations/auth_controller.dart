//                                                      4
// Controller is responsible for state management
// This authentication implementation talks directly to Firebase Auth and converts Firebase users into your own AppUser object.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/firebase_error_mapper.dart';
import 'package:reddit_app/features/auth/data/firebase_auth_repo.dart';
import 'package:reddit_app/features/auth/domain/entities/app_user.dart';
import 'package:reddit_app/features/auth/domain/repos/auth_repo.dart';

final authRepoProvider = Provider<AuthRepo>((ref) {
  // asking for AuthRepo, returning firebaseAuthRepo
  return FirebaseAuthRepo(); // This replaces dependency injection in Bloc. FirebaseAuthRepo extends AuthRepo thats why <AuthRepo> is used.
});

final authControllerProvider = StreamNotifierProvider<AuthController, AppUser?>(
  AuthController.new,
);

class AuthController extends StreamNotifier<AppUser?> {
  late final AuthRepo _authRepo;

  @override
  Stream<AppUser?> build() {
    _authRepo = ref.read(authRepoProvider); // FirebaseAuthRepo() instance into _authRepo and when this happens, Riverpod build
    return _authRepo.authStateChanges(); // Converts Firebase user → AppUser
  }

  // LOGIN
  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    try {
      await _authRepo.loginWithEmailPass(
        email,
        password,
      ); // Here we await the repo, but method says Future<void> → so the result of loginWithEmailPass is ignored.
      // state = AsyncData(user);    No need to manually set state, the stream from authStateChanges() will handle this automatically
    } on FirebaseAuthException catch (e, st) {
      state = AsyncError(
        mapFirebaseAuthError(e),
        st,
      ); // the helper class that we created to handle firebase exception is being used here
    } catch (e, st) {
      state = AsyncError("Something went wrong!", st);
    }
  }

  // REGISTER
  Future<void> register(String name, String email, String pass) async {
    try {
      await _authRepo.registerWithEmailPass(name, email, pass);
      // ✅ Stream will update automatically
    } on FirebaseAuthException catch (e, st) {
      state = AsyncError(
        mapFirebaseAuthError(e),
        st,
      ); // the helper class that we created to handle firebase exception is being used here
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await _authRepo.logout();
    // state = const AsyncData(null);   // ✅ Stream emits null automatically, no need to do it manually
  }

  // FORGOT PASSWORD
  Future<void> forgotPass(String email) async {
    try {
      await _authRepo.sendPassResetEmail(email);
    } on FirebaseAuthException catch (e, st) {
      state = AsyncError(
        mapFirebaseAuthError(e),
        st,
      ); // the helper class that we created to handle firebase exception is being used here
    }
  }

  // DELETE ACCOUNT
  Future<void> deleteAcc() async {
    try {
      await _authRepo.deleteAcc();
    } on FirebaseAuthException catch (e, st) {
      state = AsyncError(mapFirebaseAuthError(e), st);
    } catch (e, st) {
      state = AsyncError("Something went wrong", st);
    }
  }

  // GOOGLE SIGN IN
  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    try {
      await _authRepo.signInWithGmail();
    } on FirebaseAuthException catch (e, st) {
      state = AsyncError(mapFirebaseAuthError(e), st);
    } catch (e, st) {
      state = AsyncError("Google sign in failed", st);
    }
  }
}




 // // CURRENT USER
  // Future<AppUser?> currentUser() async {
  //   return await _authRepo.getCurrentUser();
  // }