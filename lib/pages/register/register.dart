import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mauthn_app/providers.dart';
import 'package:mauthn_app/services/api/api.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final authService = ref.watch(authServiceProvider);
    final apiHandler = ApiService();

    var errorProv = Provider<String?>((ref) {
      return null;
    });

    String? error = ref.watch(errorProv);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Text(
              'Tired of passwords?',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'Sign up using your biometrics like fingerprint or face.',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'email address',
              ),
            ),
          ),
          if (error != null)
            Text(
              error,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            )
          else
            Container(),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                final email = emailController.value.text;
                try {
                  await authService.signupWithPasskey(
                      apiHandler: apiHandler, email: email);
                } catch (e) {
                  errorProv.overrideWithValue(e.toString());
                  log("ERROR: $e");
                }
              },
              child: const Text('sign up'),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
