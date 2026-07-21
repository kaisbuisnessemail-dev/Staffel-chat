import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/theme.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _passwordController = TextEditingController();
  final _vanityController = TextEditingController();
  bool _isPrivate = false;
  bool _isLoading = false;
  String _error = '';
  String _success = '';

  Future<void> _createRoom() async {
    setState(() {
      _isLoading = true;
      _error = '';
      _success = '';
    });

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final password = _passwordController.text.trim();
    final vanity = _vanityController.text.trim();

    if (name.isEmpty) {
      setState(() {
        _error = 'Room name is required.';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://79.72.67.156:8000/api/create-chatroom.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'description': description,
          'owner_email': 'testuser@chat.staffel.cyou', // TODO: Get from auth
          'password': password,
          'is_private': _isPrivate,
          'vanity': vanity,
        }),
      );

      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        setState(() {
          _success = 'Room created!';
          _isLoading = false;
        });
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context, true);
        });
      } else {
        setState(() {
          _error = data['error'] ?? 'Failed to create room.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Connection failed.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StaffelTheme.background,
      appBar: AppBar(
        title: const Text('Create Room'),
        backgroundColor: Colors.transparent,
        foregroundColor: StaffelTheme.text,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_error.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: StaffelTheme.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: StaffelTheme.error.withOpacity(0.2)),
                  ),
                  child: Text(
                    _error,
                    style: const TextStyle(color: StaffelTheme.error),
                    textAlign: TextAlign.center,
                  ),
                ),
              if (_success.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: StaffelTheme.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: StaffelTheme.success.withOpacity(0.2)),
                  ),
                  child: Text(
                    _success,
                    style: const TextStyle(color: StaffelTheme.success),
                    textAlign: TextAlign.center,
                  ),
                ),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: StaffelTheme.text),
                decoration: const InputDecoration(
                  labelText: 'Room Name *',
                  hintText: 'e.g., Gaming Lounge',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                style: const TextStyle(color: StaffelTheme.text),
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'What is this room about?',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _vanityController,
                style: const TextStyle(color: StaffelTheme.text),
                decoration: const InputDecoration(
                  labelText: 'Vanity Link (optional)',
                  hintText: 'e.g., gaming-lounge',
                  prefixText: 'staffel.chat/',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                style: const TextStyle(color: StaffelTheme.text),
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password (optional)',
                  hintText: 'Leave empty for no password',
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Private Room'),
                subtitle: const Text('Only invited members can join'),
                value: _isPrivate,
                onChanged: (value) {
                  setState(() => _isPrivate = value);
                },
                activeColor: StaffelTheme.accent,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createRoom,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Create Room'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
