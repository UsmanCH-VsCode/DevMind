import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/features/auth/presentations/auth_controller.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              final authController = ref.read(authControllerProvider.notifier);
              authController.logout();

              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false, // This removes all previous routes
                );
              }
            },
            icon: Icon(Icons.logout),
          ),
          IconButton(
            onPressed: () {
              ref.read(authControllerProvider.notifier).deleteAcc();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false, // This removes all previous routes
                );
              }
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
