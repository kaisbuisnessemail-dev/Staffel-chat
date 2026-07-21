class User {
  final String jid;
  final String username;
  final String? displayName;
  final String? avatar;
  final String? statusMessage;
  final String statusType;
  final int messageCount;
  final String rank;
  final String? lastSeen;

  User({
    required this.jid,
    required this.username,
    this.displayName,
    this.avatar,
    this.statusMessage,
    this.statusType = 'online',
    this.messageCount = 0,
    this.rank = 'Shadow',
    this.lastSeen,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      jid: json['jid'] ?? '',
      username: json['username'] ?? '',
      displayName: json['display_name'],
      avatar: json['avatar'],
      statusMessage: json['status_message'],
      statusType: json['status_type'] ?? 'online',
      messageCount: json['message_count'] ?? 0,
      rank: json['rank'] ?? 'Shadow',
      lastSeen: json['last_seen'],
    );
  }

  String get displayNameToUse => displayName ?? username;
}
