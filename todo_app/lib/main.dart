import 'package:flutter/material.dart';
import 'Screens/todos.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.deepPurple[400]
        ),
        colorScheme: const ColorScheme.dark(),
        useMaterial3: true,
      ),
      home: const todos(),
    );
  }
}

