import 'package:flutter/material.dart';

class StaffelTheme {
  static const Color background = Color(0xFF0b0d10);
  static const Color card = Color(0x9F141820);
  static const Color accent = Color(0xFF58a6ff);
  static const Color text = Color(0xFFf0f4fa);
  static const Color border = Color(0x0FFFFFFF);
  static const Color success = Color(0xFF238636);
  static const Color error = Color(0xFFf85149);

  static ThemeData get dark {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: background,
      primaryColor: accent,
      colorScheme: const ColorScheme.dark(
        primary: accent,
        secondary: accent,
        surface: card,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.04),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accent, width: 2),
        ),
        labelStyle: const TextStyle(color: text),
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      cardTheme: CardTheme(
        color: card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        border: Border.all(color: border),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: text,
      ),
    );
  }
}
