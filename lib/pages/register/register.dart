import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mauthn_app/pages/basepage.dart';
import 'package:mauthn_app/providers.dart';
import 'package:mauthn_app/routes.dart';
import 'package:mauthn_app/services/api/api.dart';

import 'package:go_router/go_router.dart';
import 'package:mauthn_app/services/auth_service.dart';

final errorProvider = StateProvider<String?>((ref) => null);

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  Future<void> register(String email, ApiService apiHandler,
      AuthService authService, WidgetRef ref, BuildContext context) async {
    email = email.trim();
    if (email.isEmpty) {
      ref.read(errorProvider.notifier).state = 'Email address cannot be empty.';
      return;
    }

    try {
      final userId = await authService.signupWithPasskey(
        apiHandler: apiHandler,
        email: email,
      );
      ref.read(errorProvider.notifier).state = null;
      ref.read(userIdProvider.notifier).state = userId;
      context.go(Routes.logIn);
      log("Signup successful for $email");
    } catch (e) {
      if (kDebugMode) {
        ref.read(errorProvider.notifier).state = e.toString();
      } else {
        ref.read(errorProvider.notifier).state =
            'An error occurred. Please try again.';
      }
      log("ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final authService = ref.watch(authServiceProvider);
    final apiHandler = ApiService();
    final error = ref.watch(errorProvider);

    return BasePage(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 128),
          const Icon(
            Icons.fingerprint,
            size: 80,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          const Text(
            "Tired of passwords?",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Sign up using your biometrics like fingerprint or face.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                error,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 14,
                ),
              ),
            ),
          const SizedBox(height: 32),
          TextField(
            controller: emailController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
              hintText: "Enter your email",
              hintStyle: const TextStyle(color: Colors.white70),
              prefixIcon: const Icon(Icons.mail, color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => register(
              emailController.text,
              apiHandler,
              authService,
              ref,
              context,
            ),
            icon: const Icon(Icons.fingerprint),
            label: const Text("Sign Up with Biometrics"),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              minimumSize: const Size.fromHeight(50),
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 24,
              ),
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              // Navigate to login or other actions
              context.go(Routes.logIn);
              log("Navigate to login");
            },
            icon: const Icon(Icons.login_rounded),
            label: const Text('Already have an account? Log in'),
          ),
          const SizedBox(height: 32),
          Text(
            "Secure • Fast • Convenient",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.smartphone, color: Colors.white, size: 24),
              SizedBox(width: 16),
              Icon(Icons.shield, color: Colors.white, size: 24),
              SizedBox(width: 16),
              Icon(Icons.lock, color: Colors.white, size: 24),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Icon(
        icon,
        size: 32,
        color: Colors.white,
      ),
    );
  }
}
