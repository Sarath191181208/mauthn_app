import 'dart:convert';

import 'package:mauthn_app/services/api/api.dart';
import 'package:mauthn_app/services/api/auth.dart';
import 'package:passkeys/types.dart';

class ReplyingPartyServer {
  Future<RegisterRequestType> startPasskeyRegister(
      {required ApiService apiHandler, required String name}) async {
    final data =
        jsonDecode((await fetchRegisterOptions(apiHandler, name)).data);
    final rp = RelyingPartyType.fromJson(data["rp"]);
    final user = UserType.fromJson(data["user"]);
    final authType =
        AuthenticatorSelectionType.fromJson(data["authenticatorSelection"]);
    final pubKeyCredParams = [
      for (var item in data["pubKeyCredParams"])
        PubKeyCredParamType.fromJson(item)
    ];
    final req = RegisterRequestType(
      challenge: data["challenge"],
      relyingParty: rp,
      user: user,
      authSelectionType: authType,
      pubKeyCredParams: pubKeyCredParams,
      excludeCredentials: [],
    );
    return req;
  }

  Future<bool> finishPasskeyRegister(
      {required ApiService apiHandler,
      required RegisterResponseType response,
      required UserType user}) async {
    final res = await completeRegister(apiHandler, response, user);
    const httpCreated = 201;
    return res.statusCode == httpCreated;
  }

  Future<AuthenticateRequestType> startPasskeyLogin(
      {required ApiService apiHandler, required String userid}) async {
    final data =
        jsonDecode((await fetchLoginOptions(apiHandler, userid: userid)).data);

    return AuthenticateRequestType(
      relyingPartyId: data["rpId"],
      challenge: data["challenge"],
      userVerification: data["userVerification"],
      timeout: data["timeout"],
      mediation: MediationType.Optional,
      preferImmediatelyAvailableCredentials: false,
    );
  }

  Future<void> finishPasskeyLogin(
      {required ApiService apiHandler,
      required String userid,
      required AuthenticateResponseType response}) async {
    await completeAuthentication(apiHandler, response, userid: userid);
  }
}
