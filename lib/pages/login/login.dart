import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mauthn_app/pages/basepage.dart';
import 'package:mauthn_app/providers.dart';
import 'package:mauthn_app/routes.dart';
import 'package:mauthn_app/services/api/api.dart';
import 'package:passkeys/types.dart';

class LoginPage extends StatefulHookConsumerWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final error = useState<String?>(null);
    final userid = ref.watch(userIdProvider);
    final authService = ref.watch(authServiceProvider);
    final apiHandler = ApiService();

    return BasePage(
      child: Column(
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
              'Sign in using your biometrics like fingerprint or face.',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          if (error.value != null)
            Text(
              error.value!,
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

                  error.value = e.toString();
                  debugPrint('error: $e');
                }
              },
              child: const Text('sign in'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                side:
                    BorderSide(width: 2, color: Theme.of(context).primaryColor),
              ),
              onPressed: () => context.go(Routes.register),
              child: const Text('I want to create a new account'),
            ),
          ),
        ],
      ),
    );
  }
}
