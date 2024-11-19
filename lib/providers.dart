import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mauthn_app/services/api/api.dart';
import 'package:mauthn_app/services/auth_service.dart';
import 'package:mauthn_app/services/replying_party_server.dart';
import 'package:passkeys/authenticator.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final rps = ReplyingPartyServer();
  final authenticator = PasskeyAuthenticator();

  return AuthService(rps: rps, authenticator: authenticator);
});

final userIdProvider = StateProvider<String>((ref) {
  return 'ZjE0YWEwZGItMjBlMy00OGQwLWIwYTEtYTI5ZjExYmY5ODMy';
});

final apiHandlerProvider = Provider<ApiService>((ref) => ApiService());
