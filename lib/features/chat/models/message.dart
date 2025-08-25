class Message {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  final MessageStatus status;

  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.timestamp,
    this.type = MessageType.text,
    this.status = MessageStatus.sent,
  });

  factory Message.fromMap(Map<String, dynamic> map, String id) {
    return Message(
      id: id,
      chatId: map['chatId'] ?? '',
      senderId: map['senderId'] ?? '',
      content: map['content'] ?? '',
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      type: MessageType.values[map['type'] ?? 0],
      status: MessageStatus.values[map['status'] ?? 0],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'senderId': senderId,
      'content': content,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'type': type.index,
      'status': status.index,
    };
  }
}

enum MessageType { text, image, video, audio, document }

enum MessageStatus { sent, delivered, read }
