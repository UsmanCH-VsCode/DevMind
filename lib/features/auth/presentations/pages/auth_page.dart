// //                                                   7
// // AUTH PAGE -  this toggles between sign up and login pages. Determines whether to show login page or sign page.
// import 'package:flutter/material.dart';
// import 'package:reddit_app/features/auth/presentations/pages/login_page.dart';
// import 'package:reddit_app/features/auth/presentations/pages/sign_up_page.dart';

// class AuthPage extends StatefulWidget {
//   const AuthPage({super.key});

//   @override
//   State<AuthPage> createState() => _AuthPageState();
// }

// class _AuthPageState extends State<AuthPage> {
//   // initially show login page
//   bool showLoginPage = true;

//   // toggles between pages
//   void togglePages() {
//     setState(() {
//       showLoginPage = !showLoginPage;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (showLoginPage) {
//       return LoginPage(togglePages: togglePages);
//     } else {
//       return SignUpPage(togglePages: togglePages);
//     }
//   }
// }
