import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/notes_list_screen.dart';

void main() {
  runApp(const ProviderScope(child: NotesApp()));
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xffF8F7FC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff6C5CE7),
          primary: const Color(0xff6C5CE7),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xffF8F7FC),
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Color(0xff1F2937),
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      home: const NotesListScreen(),
    );
  }
}