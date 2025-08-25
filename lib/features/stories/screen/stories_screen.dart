import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_app_task/core/animations/story_animations.dart';
import 'package:whats_app_task/core/services/story_services.dart';
import 'package:whats_app_task/features/stories/model/story.dart';
import 'package:whats_app_task/features/stories/widgets/story_circle.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({super.key});

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  @override
  Widget build(BuildContext context) {
    final storyService = Provider.of<StoryService>(context);

    return StreamBuilder<List<Story>>(
      stream: storyService.getAllStories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final stories = snapshot.data ?? [];
        final groupedStories = _groupStoriesByUser(stories);

        return ListView(
          children: [
            _buildMyStatus(),
            const Divider(height: 1),
            ...groupedStories.entries.map((entry) {
              return StoryCircle(
                userId: entry.key,
                stories: entry.value,
                onTap: () => _openStoryViewer(context, entry.value),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildMyStatus() {
    return ListTile(
      leading: Stack(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTf3hbXeK8w0ezCgtk3DLsksnNnxnRTrvqc4A&s',
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, size: 16, color: Colors.white),
            ),
          ),
        ],
      ),
      title: const Text('My Status'),
      subtitle: const Text('Tap to add status update'),
      onTap: () {},
    );
  }

  Map<String, List<Story>> _groupStoriesByUser(List<Story> stories) {
    final Map<String, List<Story>> grouped = {};

    for (final story in stories) {
      if (!grouped.containsKey(story.userId)) {
        grouped[story.userId] = [];
      }
      grouped[story.userId]!.add(story);
    }

    return grouped;
  }

  void _openStoryViewer(BuildContext context, List<Story> stories) {
    Navigator.push(
      context,
      StoryAnimations.createRoute(StoryViewerScreen(stories: stories)),
    );
  }
}

class StoryViewerScreen extends StatefulWidget {
  final List<Story> stories;

  const StoryViewerScreen({super.key, required this.stories});

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController =
        AnimationController(
          vsync: this,
          duration: widget.stories[_currentIndex].duration,
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _nextStory();
          }
        });

    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextStory() {
    if (_currentIndex < widget.stories.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _previousStory() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _animationController.reset();
    _animationController.duration = widget.stories[index].duration;
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (_) => _animationController.stop(),
        onTapUp: (_) => _animationController.forward(),
        onLongPressStart: (_) => _animationController.stop(),
        onLongPressEnd: (_) => _animationController.forward(),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.stories.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                final story = widget.stories[index];
                return story.isImage
                    ? Image.network(story.imageUrl!, fit: BoxFit.cover)
                    : const Placeholder();
              },
            ),
            _buildProgressIndicator(),
            _buildTopBar(),
            _buildNavigationAreas(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Positioned(
      top: 40,
      left: 16,
      right: 16,
      child: Row(
        children: List.generate(widget.stories.length, (index) {
          return Expanded(
            child: Container(
              height: 3,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  if (index == _currentIndex) {
                    return LinearProgressIndicator(
                      value: _animationController.value,
                      backgroundColor: Colors.grey[600],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    );
                  } else if (index < _currentIndex) {
                    return Container(color: Colors.white);
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 60,
      left: 16,
      right: 16,
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTf3hbXeK8w0ezCgtk3DLsksnNnxnRTrvqc4A&s',
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'User Name',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationAreas() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: _previousStory,
            child: Container(color: Colors.transparent),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: _nextStory,
            child: Container(color: Colors.transparent),
          ),
        ),
      ],
    );
  }
}
