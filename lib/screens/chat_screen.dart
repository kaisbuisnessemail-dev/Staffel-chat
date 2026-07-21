import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/theme.dart';
import '../widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String jid;
  final String name;
  final String? avatar;

  const ChatScreen({
    super.key,
    required this.jid,
    required this.name,
    this.avatar,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    // TODO: Load messages from API
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _messages.addAll([
        {'text': 'Hey! Welcome to Staffel Chat', 'sent': false, 'time': '10:30'},
        {'text': 'This is a private and encrypted chat', 'sent': false, 'time': '10:31'},
        {'text': 'That\'s great!', 'sent': true, 'time': '10:32'},
      ]);
      _isLoading = false;
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'text': text,
        'sent': true,
        'time': _getCurrentTime(),
      });
      _messageController.clear();
    });

    // TODO: Send message to API/XMPP
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add({
          'text': 'Message delivered',
          'sent': false,
          'time': _getCurrentTime(),
        });
      });
    });
  }

  String _getCurrentTime() {
    return DateTime.now().toLocal().toString().substring(11, 16);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StaffelTheme.background,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: StaffelTheme.accent.withOpacity(0.2),
              child: widget.avatar != null
                  ? ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: widget.avatar!,
                        fit: BoxFit.cover,
                        width: 36,
                        height: 36,
                        placeholder: (context, url) => const SizedBox(),
                        errorWidget: (context, url, error) => Text(
                          widget.name[0].toUpperCase(),
                          style: const TextStyle(color: StaffelTheme.accent),
                        ),
                      ),
                    )
                  : Text(
                      widget.name[0].toUpperCase(),
                      style: const TextStyle(color: StaffelTheme.accent),
                    ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                    color: StaffelTheme.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Text(
                  'online',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: StaffelTheme.text,
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[_messages.length - 1 - index];
                      return ChatBubble(
                        text: message['text'],
                        isSent: message['sent'],
                        time: message['time'],
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: StaffelTheme.card,
              border: Border(
                top: BorderSide(color: StaffelTheme.border),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  color: Colors.white.withOpacity(0.3),
                  onPressed: () {
                    // TODO: Attach file
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.emoji_emotions_outlined),
                  color: Colors.white.withOpacity(0.3),
                  onPressed: () {
                    // TODO: Open emoji picker
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: StaffelTheme.text),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                      filled: true,
                      fillColor: StaffelTheme.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: StaffelTheme.accent,
                  radius: 24,
                  child: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
