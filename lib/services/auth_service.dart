import 'package:mauthn_app/services/api/api.dart';
import 'package:mauthn_app/services/replying_party_server.dart';
import 'package:passkeys/authenticator.dart';

class AuthService {
  AuthService({required this.rps, required this.authenticator});

  final ReplyingPartyServer rps;
  final PasskeyAuthenticator authenticator;

  Future<void> loginWithPasskey(
      {required ApiService apiHandler, required String userid}) async {
    final rps1 =
        await rps.startPasskeyLogin(apiHandler: apiHandler, userid: userid);
    final authRes = await authenticator.authenticate(rps1);
    await rps.finishPasskeyLogin(
        apiHandler: apiHandler, userid: userid, response: authRes);
  }

  Future<String> signupWithPasskey(
      {required ApiService apiHandler, required String email}) async {
    final rps1 =
        await rps.startPasskeyRegister(apiHandler: apiHandler, name: email);
    final authenticatorRes = await authenticator.register(rps1);
    await rps.finishPasskeyRegister(
      apiHandler: apiHandler,
      response: authenticatorRes,
      user: rps1.user,
    );
    return rps1.user.id;
  }
}
