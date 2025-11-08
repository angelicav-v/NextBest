import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/loading_screen.dart';

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
      theme: ThemeData.dark().copyWith(
        // applies Arimo font to all text in the app
        textTheme: GoogleFonts.arimoTextTheme(ThemeData.dark().textTheme),
      ),
      debugShowCheckedModeBanner: false,
      home: const LoadingScreen(),
    );
  }
}