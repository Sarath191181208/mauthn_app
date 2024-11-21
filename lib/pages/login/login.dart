import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mauthn_app/pages/basepage.dart';
import 'package:mauthn_app/providers.dart';
import 'package:mauthn_app/routes.dart';
import 'package:mauthn_app/services/api/api.dart';
import 'package:mauthn_app/services/auth_service.dart';
import 'package:passkeys/types.dart';

final errorProvider = StateProvider<String?>((ref) => null);

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  Future<void> login(AuthService authService, ApiService apiHandler,
      String userid, BuildContext context, WidgetRef ref) async {
    try {
      await authService.loginWithPasskey(
          apiHandler: apiHandler, userid: userid);
      context.go(Routes.home);
    } catch (e) {
      if (e is PasskeyAuthCancelledException) {
        debugPrint(
            'user cancelled authentication. This is not a problem. It can just be started again.');
        return;
      }
      if (kDebugMode) {
        ref.read(errorProvider.notifier).state = e.toString();
      } else {
        ref.read(errorProvider.notifier).state =
            'An error occurred. Please try again.';
      }

      debugPrint('error: $e');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final error = ref.watch(errorProvider);
    final userid = ref.watch(userIdProvider);
    final authService = ref.watch(authServiceProvider);
    final apiHandler = ref.watch(apiHandlerProvider);

    return BasePage(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 128),
          const Icon(
            Icons.login,
            size: 80,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          const Text(
            "Welcome Back!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Log in securely using your biometrics.",
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
          ElevatedButton.icon(
            onPressed: () =>
                login(authService, apiHandler, userid, context, ref),
            icon: const Icon(Icons.fingerprint),
            label: const Text("Log In with Biometrics"),
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
            onPressed: () => context.go(Routes.register),
            icon: const Icon(Icons.app_registration),
            label: const Text("Not registered yet? Sign Up"),
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
}

/*



*/
