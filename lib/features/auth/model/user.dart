class UserModel {
  final String id;
  final String name;
  final String phoneNumber;
  final String? profileImageUrl;
  final DateTime lastSeen;

  UserModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.profileImageUrl,
    required this.lastSeen,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      lastSeen: DateTime.fromMillisecondsSinceEpoch(map['lastSeen']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'lastSeen': lastSeen.millisecondsSinceEpoch,
    };
  }
}
