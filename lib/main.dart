import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/help_screen.dart';

void main() {
  runApp(const AngelNotesApp());
}

class AngelNotesApp extends StatelessWidget {
  const AngelNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AngelNotes',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/help': (context) => const HelpScreen(),
      },
    );
  }
}
