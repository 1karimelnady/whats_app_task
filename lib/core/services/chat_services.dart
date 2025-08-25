import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whats_app_task/features/chat/models/chat.dart';
import 'package:whats_app_task/features/chat/models/message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all chats for a user
  Stream<List<Chat>> getUserChats(String userId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Chat.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // Get messages for a chat
  Stream<List<Message>> getChatMessages(String chatId) {
    return _firestore
        .collection('messages')
        .where('chatId', isEqualTo: chatId)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Message.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // Send a message
  Future<void> sendMessage(Message message) async {
    await _firestore.collection('messages').add(message.toMap());

    // Update the chat's last message and timestamp
    await _firestore.collection('chats').doc(message.chatId).update({
      'lastMessage': message.content,
      'lastMessageTime': message.timestamp.millisecondsSinceEpoch,
    });
  }

  // Create a new chat
  Future<String> createChat(List<String> participants, bool isGroup) async {
    final docRef = await _firestore.collection('chats').add({
      'participants': participants,
      'lastMessage': '',
      'lastMessageTime': DateTime.now().millisecondsSinceEpoch,
      'unreadCount': 0,
      'isGroup': isGroup,
    });

    return docRef.id;
  }
}
