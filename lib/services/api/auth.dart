import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mauthn_app/const.dart';
import 'package:mauthn_app/services/api/api.dart';
import 'package:passkeys/types.dart';

Future<APIResponse> fetchRegisterOptions(
    ApiService apiHandler, String userName) async {
  return apiHandler.post(registerOptionsEndpoint, {"user_name": userName});
}

Future<APIResponse> completeRegister(
    ApiService apiHandler, RegisterResponseType response, UserType user) async {
  final data = {
    "solved_response": jsonEncode({
      "id": response.id,
      "rawId": response.rawId,
      "response": {
        "clientDataJSON": response.clientDataJSON,
        "attestationObject": response.attestationObject,
      },
      "type": "public-key",
    }),
    "user_id": user.id,
    "user_name": user.name,
    "user_email": user.name,
  };
  return apiHandler.post(registerEndEndpoint, data);
}
