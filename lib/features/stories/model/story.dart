class Story {
  final String id;
  final String userId;
  final String? imageUrl;
  final String? videoUrl;
  final DateTime timestamp;
  final Duration duration;
  final List<String> viewedBy;

  Story({
    required this.id,
    required this.userId,
    this.imageUrl,
    this.videoUrl,
    required this.timestamp,
    this.duration = const Duration(seconds: 5),
    this.viewedBy = const [],
  });

  bool get isImage => imageUrl != null;
  bool get isVideo => videoUrl != null;

  factory Story.fromMap(Map<String, dynamic> map, String id) {
    return Story(
      id: id,
      userId: map['userId'] ?? '',
      imageUrl: map['imageUrl'],
      videoUrl: map['videoUrl'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      duration: Duration(seconds: map['duration'] ?? 5),
      viewedBy: List<String>.from(map['viewedBy'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'duration': duration.inSeconds,
      'viewedBy': viewedBy,
    };
  }
}
