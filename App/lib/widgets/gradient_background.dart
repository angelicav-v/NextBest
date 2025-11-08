import 'package:flutter/material.dart';

// reusable gradient background for all screens
class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF3C0366), // purple at top (0%)
            Color(0xFF000000), // black in middle (50%)
            Color(0xFF4B004F), // purple at bottom (100%)
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: child,
    );
  }
}