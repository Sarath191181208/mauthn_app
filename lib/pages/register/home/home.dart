import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mauthn_app/models/pending_request.dart';
import 'package:mauthn_app/providers.dart';
import 'package:mauthn_app/services/api/api.dart';
import 'package:mauthn_app/services/pending_requests_service.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late Future<List<PendingRequest>> _pendingRequests;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<PendingRequest>>(
          future: _pendingRequests,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 64, color: Colors.red),
                    const SizedBox(height: 8),
                    Text(
                      "Error: ${snapshot.error}",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 64, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      "No pending requests found.",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              );
            } else {
              final requests = snapshot.data!;
              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 2.0),
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final request = requests[index];
                  return PendingRequestCard(
                    request: request,
                    apiHandler: apiHandler,
                    onAPISuccess: (id) => {
                      setState(() {
                        requests.removeWhere((element) => element.id == id);
                      })
                    },
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

class PendingRequestCard extends StatelessWidget {
  final PendingRequest request;
  final ApiService apiHandler;
  final Function(int) onAPISuccess;

  const PendingRequestCard(
      {super.key, required this.request, required this.apiHandler, required this.onAPISuccess});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const UserIcon(),
                const SizedBox(width: 12),
                Expanded(
                  child: RequesterName(request: request),
                ),
                Chip(
                  side: BorderSide(
                    color: Colors.grey[350]!,
                  ),
                  label: const Row(
                    children: [
                      Icon(Icons.pending_rounded,
                          size: 18, color: Colors.orange),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        "Pending",
                        style: TextStyle(color: Colors.orange),
                      ),
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
            const Divider(thickness: 1, height: 20),
            IconText(
              icon: Icons.access_time_outlined,
              text: "Created: ${request.createdAt.toLocal()}",
            ),
            const SizedBox(height: 8),
            IconText(
              icon: Icons.public,
              text: "IP: ${request.requesterIp}",
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  onPressed: () async {
                    await sendPendingRequestStatus(
                      apiHandler,
                      PendingStatus.rejected,
                      requestId: request.id,
                    );
                    onAPISuccess(request.id);
                  },
                  icon: const Icon(Icons.close, size: 18),
                  label: const Text("Reject"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await sendPendingRequestStatus(
                      apiHandler,
                      PendingStatus.rejected,
                      requestId: request.id,
                    );
                  },
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text("Accept"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.green,
                    side: const BorderSide(color: Colors.green),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RequesterName extends StatelessWidget {
  const RequesterName({
    super.key,
    required this.request,
  });

  final PendingRequest request;

  @override
  Widget build(BuildContext context) {
    return Text(
      request.requesterName,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}

class UserIcon extends StatelessWidget {
  const UserIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      backgroundColor: Colors.blueAccent,
      radius: 22,
      child: Icon(
        Icons.person,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}

class IconText extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? iconColor;

  const IconText({
    super.key,
    required this.icon,
    required this.text,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: iconColor ?? Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
