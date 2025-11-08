import 'package:flutter/material.dart';

/// Card showing friend's avatar for friend votes display
class FriendVoteCard extends StatelessWidget {
  final String friendName;
  final String? friendImage;

  const FriendVoteCard({
    super.key,
    required this.friendName,
    this.friendImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF9D00FF), Color(0xFFB300FF)],
            ),
          ),
          child: const Icon(Icons.person, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 6),
        Text(
          friendName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.05,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
