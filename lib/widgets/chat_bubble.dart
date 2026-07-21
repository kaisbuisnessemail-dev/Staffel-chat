import 'package:flutter/material.dart';
import '../utils/theme.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSent;
  final String time;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isSent,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSent)
            CircleAvatar(
              radius: 14,
              backgroundColor: StaffelTheme.accent.withOpacity(0.2),
              child: Text(
                'U',
                style: TextStyle(
                  color: StaffelTheme.accent,
                  fontSize: 10,
                ),
              ),
            ),
          if (!isSent) const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isSent ? StaffelTheme.accent : StaffelTheme.card,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft: isSent
                      ? const Radius.circular(16)
                      : const Radius.circular(4),
                  bottomRight: isSent
                      ? const Radius.circular(4)
                      : const Radius.circular(16),
                ),
                border: isSent ? null : Border.all(color: StaffelTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: isSent ? Colors.white : StaffelTheme.text,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      color: (isSent ? Colors.white : StaffelTheme.text)
                          .withOpacity(0.4),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isSent) const SizedBox(width: 8),
          if (isSent)
            CircleAvatar(
              radius: 14,
              backgroundColor: StaffelTheme.accent,
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 14,
              ),
            ),
        ],
      ),
    );
  }
}
