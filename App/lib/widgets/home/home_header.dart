import 'package:flutter/material.dart';

/// Fixed header section for home screen with logo, location, and controls
class HomeHeader extends StatelessWidget {
  final String username;
  final VoidCallback onProfileTap;
  final VoidCallback onInfoTap;
  final VoidCallback onSettingsTap;

  const HomeHeader({
    super.key,
    required this.username,
    required this.onProfileTap,
    required this.onInfoTap,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade900, width: 0.5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8, 16.0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTopBar(),
              const SizedBox(height: 29),
              _buildLocationRow(),
              const SizedBox(height: 22),
              _buildGreeting(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // profile icon
        GestureDetector(
          onTap: onProfileTap,
          child: Container(
            width: 40,
            height: 40,
            padding: EdgeInsets.zero,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 1.0],
                colors: [Color(0xFF9810FA), Color(0xFFC800DE)],
              ),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 20),
          ),
        ),

        // app logo and name
        Row(
          children: [
            Container(
              width: 53,
              height: 53,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFD946EF), width: 0.7),
                color: Colors.transparent,
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/nextbest_logo.png',
                  width: 55,
                  height: 50,
                ),
              ),
            ),
            const SizedBox(width: 8),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.5, 1.0],
                colors: [
                  Color(0xFFC27AFF),
                  Color(0xFFED6AFF),
                  Color(0xFFC27AFF),
                ],
              ).createShader(bounds),
              child: const Text(
                'NextBest',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  height: 24 / 16,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),

        // info and settings buttons
        Row(
          children: [
            GestureDetector(
              onTap: onInfoTap,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF000000).withValues(alpha: 0.4),
                  border: Border.all(
                    color: const Color(0xFFAD46FF).withValues(alpha: 0.3),
                    width: 1.07,
                  ),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Color(0xFFDAB2FF),
                  size: 16,
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: onSettingsTap,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF000000).withValues(alpha: 0.4),
                  border: Border.all(
                    color: const Color(0xFFAD46FF).withValues(alpha: 0.3),
                    width: 1.07,
                  ),
                ),
                child: const Icon(
                  Icons.settings_outlined,
                  color: Color(0xFFDAB2FF),
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationRow() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.location_on, color: Color(0xFFC27AFF), size: 14),
        SizedBox(width: 6),
        Text(
          'Statesboro, GA',
          style: TextStyle(
            color: Color(0xFFE9D4FF),
            fontSize: 16,
            fontWeight: FontWeight.w300,
            height: 20 / 14,
            letterSpacing: 0.05,
          ),
        ),
      ],
    );
  }

  Widget _buildGreeting() {
    return Text(
      'Hi $username, ready to find something fun?',
      style: const TextStyle(
        color: Color(0xFFDAB2FF),
        fontSize: 14,
        fontWeight: FontWeight.w300,
        height: 20 / 10,
      ),
    );
  }
}
