import 'package:audioplayers/audioplayers.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whats_app_task/features/chat/models/chat.dart';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:record/record.dart';

class ChatScreen extends StatefulWidget {
  final Chat chat;
  final String receiverId;

  const ChatScreen({Key? key, required this.chat, required this.receiverId})
    : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _recorder = AudioRecorder();
  final _audioPlayer = AudioPlayer();

  bool _isRecording = false;
  bool _showEmojiPicker = false;

  late String receiverId;

  void _playVoice(String url) async {
    await _audioPlayer.play(UrlSource(url));
  }

  void initState() {
    super.initState();
    final currentUserId = _auth.currentUser!.uid;
    receiverId = widget.chat.participants.firstWhere(
      (id) => id != currentUserId,
    );
  }

  // إرسال رسالة نصية
  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final message = _messageController.text.trim();
    _messageController.clear();

    await _firestore
        .collection('chats')
        .doc(widget.chat.id)
        .collection('messages')
        .add({
          'senderId': _auth.currentUser!.uid,
          'receiverId': widget.receiverId,
          'text': message,
          'type': 'text',
          'timestamp': FieldValue.serverTimestamp(),
        });
  }

  // إرسال رسالة صوتية
  Future<void> _toggleRecording() async {
    if (_isRecording) {
      final path = await _recorder.stop();
      setState(() => _isRecording = false);

      if (path != null) {
        final file = File(path);
        final ref = FirebaseStorage.instance
            .ref()
            .child('voice_messages')
            .child('${DateTime.now().millisecondsSinceEpoch}.m4a');

        await ref.putFile(file);
        final url = await ref.getDownloadURL();

        await _firestore
            .collection('chats')
            .doc(widget.chat.id)
            .collection('messages')
            .add({
              'senderId': _auth.currentUser!.uid,
              'receiverId': widget.receiverId,
              'voiceUrl': url,
              'type': 'voice',
              'timestamp': FieldValue.serverTimestamp(),
            });
      }
    } else {
      if (await _recorder.hasPermission()) {
        await _recorder.start(const RecordConfig(), path: 'voice_messages');
        setState(() => _isRecording = true);
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .doc(widget.chat.id)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs; // غيرت اسمها بدل messages

                return ListView.builder(
                  reverse: true,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final msg = docs[index].data() as Map<String, dynamic>;

                    if (msg['type'] == 'text') {
                      return ListTile(
                        title: Text(msg['text']),
                        subtitle: Text(msg['senderId']),
                      );
                    } else if (msg['type'] == 'image') {
                      return ListTile(
                        title: Image.network(msg['fileUrl']),
                        subtitle: Text(msg['senderId']),
                      );
                    } else if (msg['type'] == 'voice') {
                      return ListTile(
                        leading: const Icon(Icons.play_arrow),
                        title: const Text("Voice Message"),
                        subtitle: Text(msg['senderId']),
                        onTap: () => _playVoice(msg['voiceUrl']),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                );
              },
            ),
          ),

          if (_showEmojiPicker)
            SizedBox(
              height: 250,
              child: EmojiPicker(
                onEmojiSelected: (cat, emoji) {
                  _messageController.text += emoji.emoji;
                },
              ),
            ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.emoji_emotions_outlined),
                onPressed: () {
                  setState(() => _showEmojiPicker = !_showEmojiPicker);
                },
              ),
              IconButton(icon: const Icon(Icons.attach_file), onPressed: () {}),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: "Type a message...",
                  ),
                ),
              ),
              IconButton(icon: const Icon(Icons.send), onPressed: _sendMessage),
              IconButton(
                icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                onPressed: _toggleRecording,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// class ChatScreen extends StatefulWidget {
//   final Chat chat;

//   const ChatScreen({super.key, required this.chat});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen>
//     with SingleTickerProviderStateMixin {
//   final TextEditingController _messageController = TextEditingController();
//   late AnimationController _animationController;
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _messageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _sendMessage() {
//     final message = _messageController.text.trim();
//     if (message.isEmpty) return;

//     final chatService = Provider.of<ChatService>(context, listen: false);
//     final currentUserId = FirebaseAuth.instance.currentUser!.uid;

//     final newMessage = Message(
//       id: '',
//       chatId: widget.chat.id,
//       senderId: currentUserId,
//       content: message,
//       timestamp: DateTime.now(),
//       type: MessageType.text,
//       status: MessageStatus.sent,
//     );

//     chatService.sendMessage(newMessage);
//     _messageController.clear();

//     _scrollController.animateTo(
//       _scrollController.position.maxScrollExtent,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeOut,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final chatService = Provider.of<ChatService>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(widget.chat.isGroup ? 'Group Name' : 'Contact Name'),
//             const Text(
//               'last seen today at 12:00',
//               style: TextStyle(fontSize: 12),
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(icon: const Icon(Icons.call), onPressed: () {}),
//           IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
//           IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<List<Message>>(
//               stream: chatService.getChatMessages(widget.chat.id),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 }

//                 final messages = snapshot.data ?? [];

//                 return ListView.builder(
//                   controller: _scrollController,
//                   padding: const EdgeInsets.all(8),
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final message = messages[index];
//                     return ChatAnimations.messageBubble(
//                       animationController: _animationController,
//                       index: index,
//                       child: MessageBubble(message: message),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           _buildMessageInput(),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessageInput() {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.background,
//         border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
//       ),
//       child: Row(
//         children: [
//           IconButton(
//             icon: const Icon(Icons.emoji_emotions_outlined),
//             onPressed: () {},
//           ),
//           IconButton(icon: const Icon(Icons.attach_file), onPressed: () {}),
//           Expanded(
//             child: TextField(
//               controller: _messageController,
//               decoration: const InputDecoration(
//                 hintText: 'Type a message',
//                 border: InputBorder.none,
//                 contentPadding: EdgeInsets.symmetric(horizontal: 16),
//               ),
//               onSubmitted: (_) => _sendMessage(),
//             ),
//           ),
//           IconButton(icon: const Icon(Icons.mic), onPressed: () {}),
//           IconButton(icon: const Icon(Icons.send), onPressed: _sendMessage),
//         ],
//       ),
//     );
//   }
// }
