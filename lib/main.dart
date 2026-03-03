import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_app/features/auth/presentations/pages/home_page.dart';
import 'package:reddit_app/features/auth/presentations/pages/login_page.dart';
import 'package:reddit_app/features/auth/presentations/pages/sign_up_page.dart';
import 'package:reddit_app/features/auth/presentations/pages/splash_page.dart';
// import 'package:reddit_app/features/auth/presentations/themes/dark_theme.dart';   // themes
// import 'package:reddit_app/features/auth/presentations/themes/light_theme.dart';
import 'package:reddit_app/firebase_options.dart';

void main() async {
  //firebase setup
  WidgetsFlutterBinding.ensureInitialized(); // Connects Flutter engine to platform (Android / iOS).
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Google sign-in instance creation
  await GoogleSignIn.instance.initialize(
    serverClientId: '286945614620-4jimmi712fqc7rr8s8hrutitj1s0siof.apps.googleusercontent.com',
  );

  //run app
  runApp(
    const ProviderScope(child: MyApp()),
  ); // All providers (authControllerProvider, authRepoProvider) lives in ProviderScpoe.

}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,

      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
