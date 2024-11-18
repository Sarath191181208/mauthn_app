import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mauthn_app/pages/register/auth_service.dart';
import 'package:mauthn_app/pages/register/replying_party_server.dart';
import 'package:passkeys/authenticator.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final rps = ReplyingPartyServer();
  final authenticator = PasskeyAuthenticator();

  return AuthService(rps: rps, authenticator: authenticator);
});
