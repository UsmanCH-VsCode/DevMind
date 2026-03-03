import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/features/auth/presentations/auth_controller.dart';
import 'package:reddit_app/features/auth/presentations/pages/home_page.dart';
import 'package:reddit_app/features/auth/presentations/pages/login_page.dart';
import 'package:reddit_app/features/auth/presentations/pages/splash_page.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return authState.when(
      data: (user) {
        if (user != null) return const HomePage();
        return const LoginPage();
      },
      loading: () => const SplashPage(),
      error: (e, _) => const LoginPage(), // Or show error UI
    );
  }
}