import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mauthn_app/providers.dart';
import 'package:mauthn_app/routes.dart';
import 'package:mauthn_app/services/api/api.dart';

import 'package:go_router/go_router.dart';

final errorProvider = StateProvider<String?>((ref) => null);

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final authService = ref.watch(authServiceProvider);
    final apiHandler = ApiService();
    final error = ref.watch(errorProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.fingerprint_rounded,
                    size: 80,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Tired of passwords?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Sign up using your biometrics like fingerprint or face.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      hintText: 'Email address',
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
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final email = emailController.value.text.trim();
                        if (email.isEmpty) {
                          ref.read(errorProvider.notifier).state =
                              'Email address cannot be empty.';
                          return;
                        }

                        try {
                          final userId = await authService.signupWithPasskey(
                            apiHandler: apiHandler,
                            email: email,
                          );
                          ref.read(errorProvider.notifier).state =
                              null; // Clear error
                          ref.read(userIdProvider.notifier).state = userId;
                          context.go(Routes.logIn);
                          log("Signup successful for $email");
                        } catch (e) {
                          ref.read(errorProvider.notifier).state = e.toString();
                          log("ERROR: $e");
                        }
                      },
                      icon: const Icon(Icons.lock_open_rounded),
                      label: const Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () {
                      // Navigate to login or other actions
                      context.go(Routes.logIn);
                      log("Navigate to login");
                    },
                    icon: const Icon(Icons.login_rounded),
                    label: const Text('Already have an account? Log in'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
