import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/add_docs.dart'; 
import 'screens/documents.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PocketDocs',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(), // Use HomePage here instead of HomeScreen
    );
  }
}
