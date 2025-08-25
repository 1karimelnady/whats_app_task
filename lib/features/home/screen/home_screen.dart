import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_app_task/core/services/chat_services.dart';
import 'package:whats_app_task/features/chat/models/chat.dart';
import 'package:whats_app_task/features/chat/screens/chat_screen.dart';
import 'package:whats_app_task/features/chat/widgets/chat_tile.dart';
import 'package:whats_app_task/features/home/widgets/custom_app_bar.dart';
import 'package:whats_app_task/features/stories/screen/stories_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['CHATS', 'STATUS', 'CALLS'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'WhatsApp',
        tabController: _tabController,
        tabs: _tabs,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildChatsTab(), const StoriesScreen(), _buildCallsTab()],
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildChatsTab() {
    final chatService = Provider.of<ChatService>(context);
    final currentUserId = 'current_user_id'; // This should come from auth

    return StreamBuilder<List<Chat>>(
      stream: chatService.getUserChats(currentUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final chats = snapshot.data ?? [];

        return ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index];
            return ChatTile(
              chat: chat,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatScreen(chat: chat)),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCallsTab() {
    return const Center(child: Text('Calls Tab'));
  }

  Widget _buildFAB() {
    switch (_tabController.index) {
      case 0: // Chats tab
        return FloatingActionButton(
          onPressed: () {},
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: const Icon(Icons.chat, color: Colors.white),
        );
      case 1: // Status tab
        return FloatingActionButton(
          onPressed: () {},
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: const Icon(Icons.camera_alt, color: Colors.white),
        );
      case 2: // Calls tab
        return FloatingActionButton(
          onPressed: () {},
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: const Icon(Icons.add_call, color: Colors.white),
        );
      default:
        return const SizedBox();
    }
  }
}
