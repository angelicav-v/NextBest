import 'package:flutter/material.dart';

/// Category selection widget with Food, Entertainment, and Activities buttons
class CategorySection extends StatelessWidget {
  final VoidCallback onEntertainmentTap;
  final VoidCallback onFoodTap;
  final VoidCallback onActivitiesTap;

  const CategorySection({
    super.key,
    required this.onEntertainmentTap,
    required this.onFoodTap,
    required this.onActivitiesTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Pick a Category',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Choose what you\'re in the mood for',
          style: TextStyle(
            color: Color(0xFFC27AFF),
            fontSize: 16,
            fontWeight: FontWeight.w100,
            letterSpacing: 0.05,
          ),
        ),
        const SizedBox(height: 20),

        // entertainment button - full width
        _CategoryButton(
          emoji: '🎬',
          label: 'Entertainment',
          borderColor: const Color(0xFFEC4899),
          onTap: onEntertainmentTap,
        ),
        const SizedBox(height: 12),

        // food and activities buttons side by side
        Row(
          children: [
            Expanded(
              child: _CategoryButton(
                emoji: '🍔',
                label: 'Food',
                borderColor: const Color(0xFFEA580C),
                onTap: onFoodTap,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _CategoryButton(
                label: 'Activities',
                borderColor: const Color(0xFF22C55E),
                onTap: onActivitiesTap,
                icon: Icons.bolt,
                iconColor: Colors.amber,
              ),
            ),
          ],
        ),
        const SizedBox(height: 17),
        const Text(
          'Pick a category above, then spin to\ndiscover your next best spot!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color.fromARGB(255, 201, 156, 240),
            fontSize: 15,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.1,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

/// Individual category button widget
class _CategoryButton extends StatelessWidget {
  final String? emoji;
  final String label;
  final Color borderColor;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? iconColor;

  const _CategoryButton({
    this.emoji,
    required this.label,
    required this.borderColor,
    required this.onTap,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null)
                  Icon(icon, color: iconColor, size: 22)
                else if (emoji != null)
                  Text(emoji!, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
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
