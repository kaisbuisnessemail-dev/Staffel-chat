import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'utils/theme.dart';

void main() => runApp(const StaffelApp());

class StaffelApp extends StatelessWidget {
  const StaffelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'STAFFEL',
      theme: StaffelTheme.dark,
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkAuth(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: StaffelTheme.background,
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.data == true) {
          return const HomeScreen();
        }
        return const LoginScreen();
      },
    );
  }

  Future<bool> _checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null && token.isNotEmpty;
  }
}
