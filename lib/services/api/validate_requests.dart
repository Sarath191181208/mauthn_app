import 'package:mauthn_app/const.dart';
import 'package:mauthn_app/models/pending_request.dart';
import 'package:mauthn_app/services/api/api.dart';

Future<APIResponse> getPendingValidationRequests(ApiService apiHandler,
    {required String userid}) async {
  return apiHandler.get(getUserLoginRequests(userId: userid));
}

 Future<APIResponse> getValidationRequestsHistory(ApiService apiHandler,
    {required String userid}) async{
  return apiHandler.get(historyEndpoint);
}

Future<APIResponse> publishRequestStatus(
    ApiService apiHandler, PendingStatus status,
    {required int requestId}) async {
  final data = {
    "request_id": requestId,
    "request_status": status.name.toUpperCase(),
  };
  
  return apiHandler.post(requestValidateEnpoint, data);
}
