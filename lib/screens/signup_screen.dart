import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/theme.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;
  String _error = '';
  String _success = '';

  Future<void> _signup() async {
    setState(() {
      _isLoading = true;
      _error = '';
      _success = '';
    });

    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() {
        _error = 'All fields are required.';
        _isLoading = false;
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        _error = 'Password must be at least 6 characters.';
        _isLoading = false;
      });
      return;
    }

    if (password != confirm) {
      setState(() {
        _error = 'Passwords do not match.';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://79.72.67.156:8000/api/create-account.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          setState(() {
            _success = 'Account created! You can now log in.';
            _isLoading = false;
          });
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pop(context);
          });
        } else {
          setState(() {
            _error = data['error'] ?? 'Failed to create account.';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _error = 'Server error.';
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
        title: const Text('Create Account'),
        backgroundColor: Colors.transparent,
        foregroundColor: StaffelTheme.text,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: StaffelTheme.card,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: StaffelTheme.border),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_error.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
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
                const SizedBox(height: 16),
                TextField(
                  controller: _usernameController,
                  style: const TextStyle(color: StaffelTheme.text),
                  decoration: const InputDecoration(
                    hintText: 'Username',
                    hintStyle: TextStyle(color: Colors.white24),
                    filled: true,
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: StaffelTheme.text),
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.white24),
                    filled: true,
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: StaffelTheme.text),
                  decoration: const InputDecoration(
                    hintText: 'Password (min 6 chars)',
                    hintStyle: TextStyle(color: Colors.white24),
                    filled: true,
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _confirmController,
                  obscureText: true,
                  style: const TextStyle(color: StaffelTheme.text),
                  decoration: const InputDecoration(
                    hintText: 'Confirm Password',
                    hintStyle: TextStyle(color: Colors.white24),
                    filled: true,
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signup,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Create Account'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
