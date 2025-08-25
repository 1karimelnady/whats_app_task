import 'package:flutter/material.dart';
import 'package:whats_app_task/features/stories/model/story.dart';

class StoryCircle extends StatelessWidget {
  final String userId;
  final List<Story> stories;
  final VoidCallback onTap;

  const StoryCircle({
    super.key,
    required this.userId,
    required this.stories,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasUnviewedStories = stories.any(
      (story) => !story.viewedBy.contains(userId),
    );

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: hasUnviewedStories
              ? const LinearGradient(
                  colors: [Colors.red, Colors.orange, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          border: hasUnviewedStories ? null : Border.all(color: Colors.grey),
        ),
        child: CircleAvatar(
          radius: 28,
          backgroundImage: NetworkImage(
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTf3hbXeK8w0ezCgtk3DLsksnNnxnRTrvqc4A&s',
          ),
        ),
      ),
      title: Text(
        'User Name',
        style: TextStyle(
          fontWeight: hasUnviewedStories ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        _formatTime(stories.first.timestamp),
        style: TextStyle(color: Theme.of(context).textTheme.titleSmall?.color),
      ),
      onTap: onTap,
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
