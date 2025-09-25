import 'package:flutter/material.dart';
import 'food_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NextBest Home")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to Food Screen when button is pressed
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FoodScreen()),
            );
          },
          child: const Text("Go to Food Screen"),
        ),
      ),
    );
  }
}
