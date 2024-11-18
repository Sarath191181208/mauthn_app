import 'dart:convert';

import 'package:mauthn_app/services/api/api.dart';
import 'package:mauthn_app/services/api/auth.dart';
import 'package:passkeys/types.dart';

class LocalUser {
  LocalUser({required this.name, required this.id, this.credentialID});

  final String name;
  final String id;
  String? credentialID;
}

class ReplyingPartyServer {
  Future<RegisterRequestType> startPasskeyRegister(
      {required ApiService apiHandler, required String name}) async {
    final data = jsonDecode((await fetchRegisterOptions(apiHandler, name)).data);
    final rp = RelyingPartyType.fromJson(data["rp"]);
    final user = UserType.fromJson(data["user"]);
    final authType = AuthenticatorSelectionType.fromJson(data["authenticatorSelection"]);
    final req =  RegisterRequestType(
      challenge: data["challenge"],
      relyingParty: rp,
      user: user,
      authSelectionType: authType,
      excludeCredentials: [],
    );
    return req;
  }
}

