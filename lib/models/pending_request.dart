class PendingRequest {
  final int id;
  final String userId;
  final String requesterIp;
  final String requesterName;
  final PendingStatus authenticationStatus;
  final DateTime createdAt;

  PendingRequest({
    required this.id,
    required this.userId,
    required this.requesterIp,
    required this.requesterName,
    required this.authenticationStatus,
    required this.createdAt,
  });

  // Factory constructor to create an AuthRequest from JSON
  factory PendingRequest.fromJson(Map<String, dynamic> json) {
    var reqStatus = json['authentication_status'].toLowerCase();
    var authStatus = PendingStatus.values.firstWhere(
        (e) => e.toString().split(".").last.toLowerCase() == reqStatus);
    return PendingRequest(
      id: json['id'],
      userId: json['user_id'],
      requesterIp: json['requester_ip'],
      requesterName: json['requester_name'],
      authenticationStatus: authStatus,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // Convert an AuthRequest instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'requester_ip': requesterIp,
      'requester_name': requesterName,
      'authentication_status': authenticationStatus.toString().split('.').last,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

// Enum for AuthStatus
enum PendingStatus { pending, approved, rejected }
