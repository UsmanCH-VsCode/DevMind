import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  final String uid;
  final String? email;
  final bool isEmailVerified;


  AppUser({
    required this.uid,
    required this.email,
    required this.isEmailVerified
  });

  // Firebase User → AppUser
  factory AppUser.fromFirebase(User user) {
    return AppUser(
      uid: user.uid,
      email: user.email ?? '',
      isEmailVerified: user.emailVerified,
    );
  }

  // AppUser → JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'isEmailVerified': isEmailVerified, 
    };
  }

  // JSON → AppUser
  factory AppUser.fromJson(Map<String, dynamic> jsonUser) {
    return AppUser(
      uid: jsonUser['uid'],
      email: jsonUser['email'],
      isEmailVerified: jsonUser['isEmailVerified'] ?? false, 
    );
  }
}