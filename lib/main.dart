import 'package:flutter/material.dart';

void main() {
  runApp(const BeachResortApp());
}

class BeachResortApp extends StatelessWidget {
  const BeachResortApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Beach Resort Management',
      home: Scaffold(
        body: Center(
          child: Text(
            'Beach Resort Management',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}