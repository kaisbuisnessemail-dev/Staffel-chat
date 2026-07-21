import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../utils/theme.dart';
import 'signup_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _jidController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token != null && token.isNotEmpty) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    }
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    final jid = _jidController.text.trim();
    final password = _passwordController.text;

    if (jid.isEmpty || password.isEmpty) {
      setState(() {
        _error = 'Please enter both JID and password.';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://79.72.67.156:8000/api/login.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'jid': jid,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', data['token'] ?? '');
          await prefs.setString('jid', jid);
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          }
        } else {
          setState(() {
            _error = data['error'] ?? 'Invalid credentials.';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _error = 'Server error. Please try again.';
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
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0.2, -0.3),
            radius: 0.8,
            colors: [
              const Color(0xFF1a1f2e),
              StaffelTheme.background,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: StaffelTheme.card,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: StaffelTheme.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 60,
                    offset: const Offset(0, -20),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'STAFFEL',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      foreground: Paint()
                        ..shader = LinearGradient(
                          colors: [Colors.white, Colors.grey.shade400],
                        ).createShader(const Rect.fromLTWH(0, 0, 200, 40)),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'private · encrypted · unlimited',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.35),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 32),
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
                  const SizedBox(height: 16),
                  TextField(
                    controller: _jidController,
                    style: const TextStyle(color: StaffelTheme.text),
                    decoration: const InputDecoration(
                      hintText: 'JID (e.g., user@chat.staffel.cyou)',
                      hintStyle: TextStyle(color: Colors.white24),
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: StaffelTheme.text),
                    decoration: const InputDecoration(
                      hintText: 'Password',
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
                      onPressed: _isLoading ? null : _login,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Sign in'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.25),
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SignupScreen()),
                          );
                        },
                        child: const Text(
                          'Sign up',
                          style: TextStyle(color: StaffelTheme.accent),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'STAFFEL v1.0',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.08),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
