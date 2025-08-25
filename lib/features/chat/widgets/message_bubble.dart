import 'package:flutter/material.dart';
import 'package:whats_app_task/core/utils/colors.dart';
import '../models/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isCurrentUser;

  const MessageBubble({
    super.key,
    required this.message,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isCurrentUser
              ? isDark
                    ? WhatsAppColors.darkOutgoingMessage
                    : WhatsAppColors.lightOutgoingMessage
              : isDark
              ? WhatsAppColors.darkIncomingMessage
              : WhatsAppColors.lightIncomingMessage,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                color: isDark
                    ? WhatsAppColors.darkText
                    : WhatsAppColors.lightText,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                fontSize: 10,
                color: isDark
                    ? WhatsAppColors.darkMessageTime
                    : WhatsAppColors.lightMessageTime,
              ),
              textAlign: TextAlign.end,
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}
