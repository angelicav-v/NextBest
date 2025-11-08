import 'package:flutter/material.dart';

/// Spin and Search button widgets
class SpinButton extends StatelessWidget {
  final VoidCallback onTap;

  const SpinButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 68,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFFB700FF), Color(0xFF9D00FF)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9D00FF).withOpacity(0.6),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🎲', style: TextStyle(fontSize: 32)),
                  SizedBox(width: 14),
                  Text(
                    'Spin for My Next Best!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SearchButton extends StatelessWidget {
  final VoidCallback onTap;

  const SearchButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF000000).withValues(alpha: 0.4),
          border: Border.all(
            color: const Color.fromARGB(255, 196, 80, 250).withValues(alpha: 0.3),
            width: 2.1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search, color: Color.fromARGB(255, 255, 255, 255), size: 20),
                SizedBox(width: 8),
                Text(
                  'Search Manually',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
