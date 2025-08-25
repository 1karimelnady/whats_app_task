import 'package:flutter/material.dart';
import '../models/chat.dart';

class ChatTile extends StatelessWidget {
  final Chat chat;
  final VoidCallback onTap;

  const ChatTile({super.key, required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage(
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTf3hbXeK8w0ezCgtk3DLsksnNnxnRTrvqc4A&s',
        ),
      ),
      title: Text(
        chat.isGroup ? 'Group Chat' : 'Contact Name',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        chat.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Theme.of(context).textTheme.titleSmall?.color),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatTime(chat.lastMessageTime),
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).textTheme.titleSmall?.color,
            ),
          ),
          if (chat.unreadCount > 0) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: Text(
                chat.unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
      onTap: onTap,
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDay = DateTime(time.year, time.month, time.day);

    if (messageDay == today) {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    } else if (messageDay == yesterday) {
      return 'Yesterday';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }
}
