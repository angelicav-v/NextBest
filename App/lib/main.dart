import 'package:flutter/material.dart';
import 'app_navigator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NextBestApp());
}

class NextBestApp extends StatelessWidget {
  const NextBestApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NextBest',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const AppNavigator(),
    );
  }
}