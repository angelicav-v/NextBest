import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4A1A6B), // Deep purple top-left
            Color(0xFF1A0033), // Dark purple center
            Color(0xFF000000), // Black center-right
            Color(0xFF1A0033), // Dark purple bottom-left
            Color(0xFF4A1A6B), // Deep purple bottom-right
          ],
          stops: [0.0, 0.3, 0.5, 0.7, 1.0],
        ),
      ),
      child: child,
    );
  }
}