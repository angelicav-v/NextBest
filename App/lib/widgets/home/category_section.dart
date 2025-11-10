import 'package:flutter/material.dart';

/// Category selection widget with Food, Entertainment, and Activities buttons - CENTERED
class CategorySection extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategorySection({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  String _getDynamicDescription() {
    switch (selectedCategory) {
      case 'Food':
        return 'Tap to spin and discover your next best spot for Food!';
      case 'Activity':
        return 'Tap to spin and discover your next best spot for Activities!';
      case 'Entertainment':
        return 'Tap to spin and discover your next best spot for Entertainment!';
      default:
        return 'Choose what you\'re in the mood for';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Pick a Category',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _getDynamicDescription(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFFC27AFF),
            fontSize: 14,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.05,
          ),
        ),
        const SizedBox(height: 20),

        // Entertainment button - full width
        _CategoryButton(
          emoji: '🎬',
          label: 'Entertainment',
          selectedStrokeColor: const Color(0xFFFB64B6),
          isSelected: selectedCategory == 'Entertainment',
          onTap: () => onCategorySelected('Entertainment'),
        ),
        const SizedBox(height: 12),

        // Food and Activities buttons side by side
        Row(
          children: [
            Expanded(
              child: _CategoryButton(
                emoji: '🍕',
                label: 'Food',
                selectedStrokeColor: const Color(0xFFFF8904),
                isSelected: selectedCategory == 'Food',
                onTap: () => onCategorySelected('Food'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _CategoryButton(
                emoji: '⚡',
                label: 'Activity',
                selectedStrokeColor: const Color(0xFF00D5BE),
                isSelected: selectedCategory == 'Activity',
                onTap: () => onCategorySelected('Activity'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Individual category button widget
class _CategoryButton extends StatelessWidget {
  final String emoji;
  final String label;
  final Color selectedStrokeColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryButton({
    required this.emoji,
    required this.label,
    required this.selectedStrokeColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: isSelected
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: label == 'Entertainment'
                        ? const [Color(0xFFE60076), Color(0xFFEC003F)]
                        : label == 'Food'
                            ? const [Color(0xFFF54900), Color(0xFFE17100)]
                            : const [Color(0xFF009689), Color(0xFF0092B8)],
                  )
                : null,
            color: !isSelected
                ? const Color(0xFF000000).withOpacity(0.4)
                : null,
            border: Border.all(
              color: isSelected ? selectedStrokeColor : const Color(0xFFC27AFF).withOpacity(0.2),
              width: isSelected ? 2.0 : 1.33,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: selectedStrokeColor.withOpacity(0.4),
                      blurRadius: 15,
                      spreadRadius: 0,
                      offset: const Offset(0, 0),
                    ),
                  ]
                : [],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFFDAB2FF),
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      letterSpacing: 0.2,
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