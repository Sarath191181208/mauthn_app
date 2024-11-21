import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mauthn_app/components/request_card.dart';
import 'package:mauthn_app/models/pending_request.dart';
import 'package:mauthn_app/providers.dart';
import 'package:mauthn_app/services/api/api.dart';
import 'package:mauthn_app/services/pending_requests_service.dart';

class PendingRequestsPage extends ConsumerStatefulWidget {
  const PendingRequestsPage({super.key});

  @override
  ConsumerState<PendingRequestsPage> createState() => _PendingRequestsPageState();
}

class _PendingRequestsPageState extends ConsumerState<PendingRequestsPage> {
  late Future<List<VerificationRequest>> _pendingRequests;
  late ApiService apiHandler;

  @override
  void initState() {
    super.initState();
    final userId = ref.read(userIdProvider);
    apiHandler = ref.read(apiHandlerProvider);
    _pendingRequests = fetchPendingRequests(apiHandler, userid: userId);
  }

  Future<void> _refresh() async {
    setState(() {
      final userId = ref.read(userIdProvider);
      _pendingRequests = fetchPendingRequests(apiHandler, userid: userId);
    });
  }

  Future<bool> sendRequest(
      {required int requestId, required PendingStatus status}) async {
    try {
      await sendPendingRequestStatus(
        apiHandler,
        status,
        requestId: requestId,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  handleRequestAction(int requestId, List<VerificationRequest> requests,
      PendingStatus status) async {
    bool isRequestSent =
        await sendRequest(requestId: requestId, status: status);

    if (isRequestSent) {
      setState(() {
        requests.removeWhere((element) => element.id == requestId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<VerificationRequest>>(
          future: _pendingRequests,
          builder: (context, snapshot) {
            // Show the loading page
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // If any error occured
            else if (snapshot.hasError) {
              return ErrorText(
                error: snapshot.error,
              );
            }

            // If snapshot has no data
            else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return NoRequestsFoundWidget(reload: _refresh);
            }

            // show the list ui
            else {
              final requests = snapshot.data!;
              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 2.0),
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final request = requests[index];
                  return RequestCard(
                    card: request,
                    onAccept: () async => handleRequestAction(
                        request.id, requests, PendingStatus.approved),
                    onReject: () async => handleRequestAction(
                        request.id, requests, PendingStatus.rejected),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class ErrorText extends StatelessWidget {
  final Object? error;
  const ErrorText({
    super.key,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 8),
          Text(
            "Error: $error",
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class NoRequestsFoundWidget extends StatelessWidget {
  final Function() reload;
  const NoRequestsFoundWidget({
    super.key,
    required this.reload,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox, size: 64, color: Colors.grey),
          const SizedBox(height: 8),
          const Text(
            "No pending requests found.",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text("Reload"),
            onPressed: reload,
          )
        ],
      ),
    );
  }
}
