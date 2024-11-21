import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mauthn_app/models/pending_request.dart';

class RequestCard extends StatelessWidget {
  final PendingRequest card;
  final Function() onAccept;
  final Function() onReject;

  const RequestCard(
      {super.key,
      required this.card,
      required this.onAccept,
      required this.onReject});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  card.requesterName,
                  style: textTheme.headlineMedium,
                ),
                Icon(
                  getStatusIcon(card.authenticationStatus),
                  color: getStatusColor(card.authenticationStatus),
                ),
              ],
            ),
            const SizedBox(height: 16),
            IconText(
              label: "ID",
              content: card.id.toString(),
              icon: Icons.fingerprint_rounded,
              iconColor: Colors.teal.shade800.withOpacity(0.7),
            ),
            const SizedBox(height: 8),
            IconText(
                label: "User ID",
                content: card.userId,
                icon: Icons.person_rounded,
                iconColor: Colors.green.shade800.withOpacity(0.7)),
            const SizedBox(height: 8),
            IconText(
                label: "IP",
                content: card.requesterIp,
                icon: Icons.language_rounded,
                iconColor: Colors.orange.shade900.withOpacity(0.6)),
            const SizedBox(height: 8),
            IconText(
                label: "Created",
                content: DateFormat.yMd().add_jm().format(card.createdAt),
                icon: Icons.date_range_rounded,
                iconColor: Colors.purple.shade800.withOpacity(0.7)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (card.authenticationStatus == PendingStatus.pending)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[900],
                      foregroundColor: Colors.greenAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: onAccept,
                    icon: const Icon(Icons.check),
                    label: const Text("Accept"),
                  ),
                if (card.authenticationStatus == PendingStatus.pending)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[900],
                      foregroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: onReject,
                    icon: const Icon(Icons.cancel),
                    label: const Text("Reject"),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class IconText extends StatelessWidget {
  final String label;
  final String content;
  final IconData icon;
  final Color iconColor;

  const IconText(
      {super.key,
      required this.label,
      required this.content,
      required this.icon,
      required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor,
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 200,
          child: Text.rich(
            TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                  text: "$label: ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: content,
                ),
              ],
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}

class LabelledText extends StatelessWidget {
  final String label;
  final String content;

  const LabelledText({
    super.key,
    required this.label,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: [
          TextSpan(
            text: "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: content,
          ),
        ],
      ),
    );
  }
}

IconData getStatusIcon(PendingStatus status) {
  switch (status) {
    case PendingStatus.pending:
      return Icons.access_time;
    case PendingStatus.approved:
      return Icons.check_circle;
    case PendingStatus.rejected:
      return Icons.cancel;
    default:
      return Icons.help_outline;
  }
}

Color getStatusColor(PendingStatus status) {
  switch (status) {
    case PendingStatus.pending:
      return Colors.yellow;
    case PendingStatus.approved:
      return Colors.green;
    case PendingStatus.rejected:
      return Colors.red;
    default:
      return Colors.grey;
  }
}
