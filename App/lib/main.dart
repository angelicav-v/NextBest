import 'package:flutter/material.dart';
import 'screens/loading_screen.dart';

void main() {
  runApp(const NextBestApp());
}

class NextBestApp extends StatelessWidget {
  const NextBestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NextBest',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'SF Pro',
      ),
      home: const LoadingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}