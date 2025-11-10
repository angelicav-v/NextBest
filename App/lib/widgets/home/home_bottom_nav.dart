import 'package:flutter/material.dart';

/// Bottom navigation bar widget for home screen
class HomeBottomNav extends StatelessWidget {
  final VoidCallback onRandomizeTap;

  const HomeBottomNav({
    super.key,
    required this.onRandomizeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          child: Divider(
            color: const Color(0xFFAD46FF),
            height: 1,
            thickness: 1,
          ),
        ),
        BottomNavigationBar(
          backgroundColor: Colors.black,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: 0,
          selectedItemColor: const Color(0xFF9D00FF),
          unselectedItemColor: Colors.grey.shade700,
          selectedLabelStyle: const TextStyle(fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_on),
              label: 'Randomize',
            ),
          ],
          onTap: (index) {
            if (index == 3) {
              onRandomizeTap();
            }
          },
        ),
      ],
    );
  }
}