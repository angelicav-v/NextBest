import 'package:flutter/material.dart';

/// Favorites section widget for home screen - shows favorites preview
class FavoritesSection extends StatelessWidget {
  final VoidCallback onViewAll;

  const FavoritesSection({
    super.key,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFE12AFB),
                    Color(0xFFE12AFB),
                  ],
                ),
              ),
              child: const Icon(Icons.favorite, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            const Text(
              'View Favorites',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: onViewAll,
          child: const Text(
            'View All >',
            style: TextStyle(
              color: Color(0xFFE12AFB),
              fontSize: 13,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ],
    );
  }
}