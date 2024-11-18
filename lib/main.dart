import 'package:credential_manager/credential_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mauthn_app/routes.dart';

const String googleClientId = "";
const String rpId = "blogs-deeplink-example.vercel.app";
final CredentialManager credentialManager = CredentialManager();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  if (CredentialManager().isSupportedPlatform) {
    await credentialManager.init(
      preferImmediatelyAvailableCredentials: true,
      googleClientId: googleClientId.isNotEmpty ? googleClientId : null,
    );
  }
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
