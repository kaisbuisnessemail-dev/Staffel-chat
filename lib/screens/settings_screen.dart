import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/theme.dart';
import '../services/api_service.dart';
import '../screens/profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _readReceiptsEnabled = true;
  bool _typingIndicatorsEnabled = true;
  String _selectedTheme = 'Dark';
  String _jid = '';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _jid = prefs.getString('jid') ?? '';
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      _readReceiptsEnabled = prefs.getBool('read_receipts') ?? true;
      _typingIndicatorsEnabled = prefs.getBool('typing_indicators') ?? true;
      _selectedTheme = prefs.getString('theme') ?? 'Dark';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', _notificationsEnabled);
    await prefs.setBool('read_receipts', _readReceiptsEnabled);
    await prefs.setBool('typing_indicators', _typingIndicatorsEnabled);
    await prefs.setString('theme', _selectedTheme);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings saved')),
      );
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StaffelTheme.background,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        foregroundColor: StaffelTheme.text,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          _buildSection('Account', [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: StaffelTheme.accent.withOpacity(0.2),
                child: const Icon(Icons.person, color: StaffelTheme.accent),
              ),
              title: const Text('Profile'),
              subtitle: Text(_jid),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfileScreen(jid: _jid),
                  ),
                );
              },
            ),
          ]),
          _buildSection('Preferences', [
            SwitchListTile(
              title: const Text('Notifications'),
              subtitle: const Text('Receive push notifications'),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() => _notificationsEnabled = value);
              },
              activeColor: StaffelTheme.accent,
            ),
            SwitchListTile(
              title: const Text('Read Receipts'),
              subtitle: const Text('Show when messages are read'),
              value: _readReceiptsEnabled,
              onChanged: (value) {
                setState(() => _readReceiptsEnabled = value);
              },
              activeColor: StaffelTheme.accent,
            ),
            SwitchListTile(
              title: const Text('Typing Indicators'),
              subtitle: const Text('Show when someone is typing'),
              value: _typingIndicatorsEnabled,
              onChanged: (value) {
                setState(() => _typingIndicatorsEnabled = value);
              },
              activeColor: StaffelTheme.accent,
            ),
          ]),
          _buildSection('Appearance', [
            ListTile(
              leading: const Icon(Icons.palette),
              title: const Text('Theme'),
              subtitle: Text(_selectedTheme),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showThemeDialog();
              },
            ),
          ]),
          _buildSection('Privacy', [
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Privacy Settings'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.devices),
              title: const Text('Active Devices'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ]),
          _buildSection('Support', [
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help & Support'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About Staffel'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Staffel Chat',
                  applicationVersion: 'v1.0.0',
                  applicationIcon: const Icon(Icons.chat, size: 48),
                  children: [
                    const Text('Private. Encrypted. Unlimited.'),
                  ],
                );
              },
            ),
          ]),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: StaffelTheme.error,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Logout'),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              'STAFFEL v1.0.0',
              style: TextStyle(
                color: Colors.white.withOpacity(0.1),
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              color: Colors.white.withOpacity(0.2),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: StaffelTheme.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: StaffelTheme.border),
          ),
          child: Column(
            children: children,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: StaffelTheme.card,
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Dark'),
              leading: Radio<String>(
                value: 'Dark',
                groupValue: _selectedTheme,
                onChanged: (value) {
                  setState(() => _selectedTheme = value!);
                  Navigator.pop(context);
                },
                activeColor: StaffelTheme.accent,
              ),
            ),
            ListTile(
              title: const Text('Light'),
              leading: Radio<String>(
                value: 'Light',
                groupValue: _selectedTheme,
                onChanged: (value) {
                  setState(() => _selectedTheme = value!);
                  Navigator.pop(context);
                },
                activeColor: StaffelTheme.accent,
              ),
            ),
            ListTile(
              title: const Text('Midnight'),
              leading: Radio<String>(
                value: 'Midnight',
                groupValue: _selectedTheme,
                onChanged: (value) {
                  setState(() => _selectedTheme = value!);
                  Navigator.pop(context);
                },
                activeColor: StaffelTheme.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
