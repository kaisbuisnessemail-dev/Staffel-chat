import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/theme.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _membersController = TextEditingController();
  bool _isLoading = false;
  String _error = '';
  String _success = '';

  Future<void> _createGroup() async {
    setState(() {
      _isLoading = true;
      _error = '';
      _success = '';
    });

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final membersRaw = _membersController.text.trim();
    final members = membersRaw.isEmpty
        ? ['testuser@chat.staffel.cyou']
        : membersRaw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    if (name.isEmpty) {
      setState(() {
        _error = 'Group name is required.';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://79.72.67.156:8000/api/create-group.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'description': description,
          'owner_email': 'testuser@chat.staffel.cyou', // TODO: Get from auth
          'members': members,
        }),
      );

      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        setState(() {
          _success = 'Group created!';
          _isLoading = false;
        });
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context, true);
        });
      } else {
        setState(() {
          _error = data['error'] ?? 'Failed to create group.';
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
        title: const Text('Create Group'),
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
                  labelText: 'Group Name *',
                  hintText: 'e.g., The Crew',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                style: const TextStyle(color: StaffelTheme.text),
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'What is this group about?',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _membersController,
                style: const TextStyle(color: StaffelTheme.text),
                decoration: const InputDecoration(
                  labelText: 'Members (optional)',
                  hintText: 'Enter JIDs separated by commas',
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createGroup,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Create Group'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
