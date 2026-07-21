import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../models/user.dart';

class ProfileScreen extends StatefulWidget {
  final String jid;

  const ProfileScreen({super.key, required this.jid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    // TODO: Load user from API
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _user = User(
        jid: widget.jid,
        username: 'testuser',
        displayName: 'Test User',
        statusMessage: 'Building Staffel Chat',
        rank: 'Shadow',
        messageCount: 1234,
      );
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StaffelTheme.background,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        foregroundColor: StaffelTheme.text,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: StaffelTheme.accent.withOpacity(0.2),
                      child: Text(
                        _user!.displayNameToUse[0].toUpperCase(),
                        style: const TextStyle(
                          color: StaffelTheme.accent,
                          fontSize: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _user!.displayNameToUse,
                      style: const TextStyle(
                        color: StaffelTheme.text,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _user!.jid,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.3),
                        fontSize: 14,
                      ),
                    ),
                    if (_user!.statusMessage != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: StaffelTheme.card,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: StaffelTheme.border),
                        ),
                        child: Text(
                          _user!.statusMessage!,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    _buildStatCard(
                      'Rank',
                      _user!.rank,
                      Icons.star,
                    ),
                    _buildStatCard(
                      'Messages Sent',
                      '${_user!.messageCount}',
                      Icons.message,
                    ),
                    _buildStatCard(
                      'Status',
                      _user!.statusType,
                      _user!.statusType == 'online'
                          ? Icons.circle
                          : Icons.circle_outlined,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Follow/unfollow
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: StaffelTheme.accent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Follow'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: StaffelTheme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: StaffelTheme.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.3), size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: StaffelTheme.text,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
