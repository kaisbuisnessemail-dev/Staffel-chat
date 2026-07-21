class Message {
  final String id;
  final String text;
  final bool isSent;
  final DateTime timestamp;
  final String? fileUrl;
  final String? fileName;
  final bool isVoice;
  final int? voiceDuration;

  Message({
    required this.id,
    required this.text,
    required this.isSent,
    required this.timestamp,
    this.fileUrl,
    this.fileName,
    this.isVoice = false,
    this.voiceDuration,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id']?.toString() ?? '',
      text: json['message'] ?? '',
      isSent: json['is_sent'] ?? false,
      timestamp: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      fileUrl: json['file_url'],
      fileName: json['file_name'],
      isVoice: json['is_voice'] ?? false,
      voiceDuration: json['voice_duration'],
    );
  }

  String get timeString {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
