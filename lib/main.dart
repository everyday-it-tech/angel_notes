import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/categories_screen.dart';

void main() {
  runApp(AngelNotesApp());
}

class AngelNotesApp extends StatelessWidget {
  const AngelNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Angel Notes',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/categories': (context) => CategoriesScreen(),
      },
    );
  }
}
