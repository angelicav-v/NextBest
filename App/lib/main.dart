import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const NextBestApp());
}

class NextBestApp extends StatelessWidget {
  const NextBestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NextBest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const HomeScreen(),
    );
  }
}
