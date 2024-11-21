import 'package:mauthn_app/models/pending_request.dart';
import 'package:mauthn_app/services/api/api.dart';
import 'package:mauthn_app/services/api/validate_requests.dart';

Future<List<VerificationRequest>> fetchPendingRequests(ApiService apiHandler,
    {required String userid}) async {
  final resp = await getPendingValidationRequests(apiHandler, userid: userid);
  final List<dynamic> data = resp.data;

  final res = data
      .map((e) => VerificationRequest.fromJson(e as Map<String, dynamic>))
      .toList();

  return res;
}

Future<void> sendPendingRequestStatus(
    ApiService apiHandler, PendingStatus status,
    {required int requestId}) async {
    await publishRequestStatus(apiHandler, status, requestId: requestId);
}

Future<List<VerificationRequest>> fetchRequestHistory(ApiService apiHandler,
    {required String userid}) async {
  final resp = await getValidationRequestsHistory(apiHandler, userid: userid);
  final List<dynamic> data = resp.data;

  final res = data
      .map((e) => VerificationRequest.fromJson(e as Map<String, dynamic>))
      .toList();

  return res;
}
