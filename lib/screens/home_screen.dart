import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _chats = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadChats();
  }

  Future<void> _loadChats() async {
    // TODO: Load chats from API
    setState(() {
      _chats = [
        {'name': 'Test User', 'jid': 'testuser@chat.staffel.cyou', 'last_message': 'Hello!', 'time': '12:30', 'unread': 2},
        {'name': 'Admin', 'jid': 'admin@chat.staffel.cyou', 'last_message': 'Welcome to Staffel', 'time': '11:15', 'unread': 0},
      ];
      _isLoading = false;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StaffelTheme.background,
      appBar: AppBar(
        title: const Text('STAFFEL'),
        backgroundColor: Colors.transparent,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Chats'),
            Tab(text: 'Groups'),
            Tab(text: 'Rooms'),
            Tab(text: 'Spotlight'),
          ],
          indicatorColor: StaffelTheme.accent,
          labelColor: StaffelTheme.text,
          unselectedLabelColor: Colors.white.withOpacity(0.3),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildChatList('Chats'),
          _buildChatList('Groups'),
          _buildChatList('Rooms'),
          _buildSpotlightFeed(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: StaffelTheme.accent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildChatList(String type) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_chats.isEmpty) {
      return Center(
        child: Text(
          'No $type yet',
          style: TextStyle(
            color: Colors.white.withOpacity(0.2),
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _chats.length,
      itemBuilder: (context, index) {
        final chat = _chats[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: StaffelTheme.accent.withOpacity(0.2),
            child: Text(
              chat['name'][0].toUpperCase(),
              style: const TextStyle(color: StaffelTheme.accent),
            ),
          ),
          title: Text(
            chat['name'],
            style: const TextStyle(color: StaffelTheme.text),
          ),
          subtitle: Text(
            chat['last_message'],
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                chat['time'],
                style: TextStyle(
                  color: Colors.white.withOpacity(0.2),
                  fontSize: 12,
                ),
              ),
              if (chat['unread'] > 0)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: StaffelTheme.accent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    chat['unread'].toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          onTap: () {
            // TODO: Navigate to chat screen
          },
        );
      },
    );
  }

  Widget _buildSpotlightFeed() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.play_circle_outline,
            size: 80,
            color: Colors.white.withOpacity(0.1),
          ),
          const SizedBox(height: 16),
          Text(
            'No spotlight videos yet',
            style: TextStyle(
              color: Colors.white.withOpacity(0.2),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
