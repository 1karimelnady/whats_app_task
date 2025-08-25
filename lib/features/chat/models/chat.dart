class Chat {
  final String id;
  final List<String> participants;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isGroup;

  Chat({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.isGroup = false,
  });

  factory Chat.fromMap(Map<String, dynamic> map, String id) {
    return Chat(
      id: id,
      participants: List<String>.from(map['participants'] ?? []),
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: DateTime.fromMillisecondsSinceEpoch(
        map['lastMessageTime'],
      ),
      unreadCount: map['unreadCount'] ?? 0,
      isGroup: map['isGroup'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.millisecondsSinceEpoch,
      'unreadCount': unreadCount,
      'isGroup': isGroup,
    };
  }
}
