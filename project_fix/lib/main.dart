import 'package:flutter/material.dart';
import 'package:project_fix/src/features/welcome%20screen/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const WelcomeScreen(),
    );
  }
}
