//                                                          3
// FIREBASE IS OUR BACKGROUND  -   we can swap out any backend here later

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_app/features/auth/domain/entities/app_user.dart';
import 'package:reddit_app/features/auth/domain/repos/auth_repo.dart';

class FirebaseAuthRepo extends AuthRepo {
  final FirebaseAuth _firebaseAuth =
      FirebaseAuth.instance; // firebase instance is created here

  @override
  Stream<AppUser?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      // this firebase function authStateChanges() updates the value whenever something changes in authentication and map transfer data into streams (Firebase User  →  AppUser)
      if (firebaseUser == null) return null;
      return AppUser.fromFirebase(firebaseUser);
    });
  }

  // DELETE ACC
  @override
  Future<void> deleteAcc() async {
    // getting current user
    final user = _firebaseAuth.currentUser;

    // checking if user is logged in
    if (user == null) throw Exception("no user logged in...");

    await user.reload(); // fresh data before delete

    // deleting acc
    await user.delete();

    // logging out
    // await logout();   // no need to logout, after deletion acc logout automatically
  }

  // LOGIN: email & pass
  @override
  Future<void> loginWithEmailPass(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Reload to get FRESH data from Firebase server
    await userCredential.user!.reload();

    // Get fresh user AFTER reload (userCredential.user stays stale)
    final freshUser = _firebaseAuth.currentUser!;
    print('emailVerified: ${freshUser.emailVerified}');

    if (!freshUser.emailVerified) {
      await _firebaseAuth.signOut();
      throw FirebaseAuthException(
        code: 'email-not-verified',
        message: 'Please verify your email before login.',
      );
    }
  }

  // SIGNING OUT
  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  // REGISTER: email & pass
  @override
  Future<void> registerWithEmailPass(
    String name,
    String email,
    String pass,
  ) async {
    try {
      // Creates the user in firebase
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: pass);

      // Send verification email
      await userCredential.user!.sendEmailVerification();

      // Sign out immediately so user cannot login until verified
      await _firebaseAuth.signOut();

      // 4️⃣ Throw exception to notify UI that verification is required
      throw FirebaseAuthException(
        code: 'email-not-verified',
        message: 'Verification email sent. Please verify before login.',
      );
    } catch (e) {
      rethrow;
    }
  }

  // RESET PASS
  @override
  Future<void> sendPassResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signInWithGmail() async {
    try {
      // Authenticate with Google
      final GoogleSignInAccount gUser = await GoogleSignIn.instance
          .authenticate();

      // Get idToken from authentication
      final String? idToken = gUser.authentication.idToken;

      // Get accessToken via authorization
      final GoogleSignInClientAuthorization? authorization = await gUser
          .authorizationClient
          .authorizationForScopes(['email', 'profile']);

      // Create Firebase credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: authorization?.accessToken,
      );

      // Sign in to Firebase
      await _firebaseAuth.signInWithCredential(credential);

      // ✅ Stream updates automatically
    } on GoogleSignInException catch (e) {
      throw FirebaseAuthException(
        code: 'google-sign-in-failed',
        message: e.toString(),
      );
    } on FirebaseAuthException {
      rethrow;
    }
  }
}





  // GET CURRENT USER

  // @override
  // Future<AppUser?> getCurrentUser() async {
  //   try {
  //     // getting current logged in user from firebase
  //     final currentUser = firebaseAuth.currentUser;

  //     // no logged in user
  //     if (currentUser == null) return null;

  //     // logged in user exists
  //     return AppUser(uid: currentUser.uid, email: currentUser.email!);
  //   } catch (e) {
  //     return null;
  //   }
  // }
