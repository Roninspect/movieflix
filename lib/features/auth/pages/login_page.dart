import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieflix/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => ref
            .watch(authControllerProvider.notifier)
            .singInWithGoogle(context),
        child: Center(
          child: Container(
            height: 50,
            width: 200,
            decoration: const BoxDecoration(color: Colors.black26),
            child: const Center(child: Text("Login with Google")),
          ),
        ),
      ),
    );
  }
}
