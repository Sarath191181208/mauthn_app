import 'package:mauthn_app/const.dart';
import 'package:mauthn_app/services/api/api.dart';

Future<APIResponse> fetchRegisterOptions(
    ApiService apiHandler, String userName) async {
  return apiHandler.post(registerOptionsEndpoint, {"user_name": userName});
}

