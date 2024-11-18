import 'package:mauthn_app/pages/register/replying_party_server.dart';
import 'package:mauthn_app/services/api/api.dart';
import 'package:passkeys/authenticator.dart';

class AuthService {
  AuthService({required this.rps, required this.authenticator});

  final ReplyingPartyServer rps;
  final PasskeyAuthenticator authenticator;

  /*
  Future<void> loginWithPasskey({required String email}) async {
    final rps1 = rps.startPasskeyLogin(name: email);
    final authenticatorRes = await authenticator.authenticate(rps1);
    rps.finishPasskeyLogin(response: authenticatorRes);
  }

  Future<void> loginWithPasskeyConditionalUI() async {
    final rps1 = rps.startPasskeyLoginConditionalU();
    final authenticatorRes = await authenticator.authenticate(rps1);
    rps.finishPasskeyLoginConditionalUI(response: authenticatorRes);
  }
  */

  Future<void> signupWithPasskey(
      {required ApiService apiHandler, required String email}) async {
    final rps1 = await rps.startPasskeyRegister(apiHandler: apiHandler, name: email);
    print(rps1);
    final authenticatorRes = await authenticator.register(rps1);
    print("AUTHN RES: $authenticatorRes");
    // rps.finishPasskeyRegister(response: authenticatorRes);
  }
}
