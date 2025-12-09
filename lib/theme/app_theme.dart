import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF0E2218);     // deep green/black
  static const Color accent = Colors.greenAccent;         // signature AngelNotes green
  static const Color textSoft = Color(0xFFC8FFD5);        // soft mint text
  static const Color tile = Color(0xFF122D22);

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: accent,
      brightness: Brightness.dark,
      primary: accent,
    ),
    useMaterial3: true,

    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: textSoft,
        fontSize: 20,
        height: 1.4,
      ),
      headlineMedium: TextStyle(
        color: textSoft,
        fontSize: 26,
        fontWeight: FontWeight.w600,
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.greenAccent,
      centerTitle: true,
      foregroundColor: Colors.black,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 22,
        color: Colors.black,
      ),
    ),
  );
}
