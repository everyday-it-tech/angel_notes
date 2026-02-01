import "package:flutter/material.dart";
import "ui/screens/home_screen.dart";
import "theme/app_theme.dart";

void main() {
  runApp(const AngelNotesApp());
}

class AngelNotesApp extends StatelessWidget {
  const AngelNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "AngelNotes",
      theme: ThemeData(
        scaffoldBackgroundColor: AppTheme.background,
        appBarTheme: AppBarTheme(
          backgroundColor: AppTheme.accent,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accent,
            foregroundColor: Colors.black,
          ),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
