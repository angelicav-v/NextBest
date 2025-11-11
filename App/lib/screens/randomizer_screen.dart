import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';

class RandomizerScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String selectedCategory;
  final bool autoSpin;

  const RandomizerScreen({
    super.key,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.selectedCategory = '',
    this.autoSpin = false,
  });

  @override
  State<RandomizerScreen> createState() => _RandomizerScreenState();
}

class _RandomizerScreenState extends State<RandomizerScreen>
    with TickerProviderStateMixin {
  String selectedCategory = '';
  bool isSpinning = false;
  Set<String> selectedFilters = {};
  bool favoritesOnly = false;
  Map<String, int> ratings = {}; // Store ratings by location name

  late AnimationController _spinController;

  // Filter options for each category
  final Map<String, List<String>> categoryFilters = {
    'Food': ['Italian', 'Japanese', 'American', 'Mexican', 'Thai', 'Indian'],
    'Activity': ['Outdoor', 'Indoor', 'Adventure', 'Relaxing', 'Sports', 'Cultural'],
    'Entertainment': ['Drama', 'Action', 'Comedy', 'Thriller', 'Horror', 'Romance', 'Sci-Fi', 'Mystery'],
  };

  final Map<String, List<Map<String, dynamic>>> mockLocations = {
    'Food': [
      {
        'name': 'El Sombrero',
        'category': 'Mexican',
        'description': 'Authentic Mexican cuisine with fresh ingredients',
        'rating': 4.7,
        'reviews': 262,
        'duration': '50 min',
        'distance': '0.9 mi',
        'price': '\$\$',
      },
      {
        'name': 'Sakura Sushi',
        'category': 'Japanese',
        'description': 'Fresh sushi and traditional Japanese dishes',
        'rating': 4.8,
        'reviews': 445,
        'duration': '35 min',
        'distance': '1.2 mi',
        'price': '\$\$\$',
      },
    ],
    'Activity': [
      {
        'name': 'Mountain Trail Park',
        'category': 'Outdoor',
        'description': 'Scenic hiking trails with beautiful views',
        'rating': 4.6,
        'reviews': 892,
        'distance': '2.3 mi',
      },
    ],
    'Entertainment': [
      {
        'name': 'Cinema Prime',
        'category': 'Movies',
        'genre': 'Drama',
        'description': 'Latest films in premium theater experience',
        'rating': 4.5,
        'reviews': 2314,
        'runtime': '148 min',
        'year': '2010',
        'director': 'Christopher Nolan',
        'platform': 'Streaming',
      },
      {
        'name': 'The Dark Knight',
        'category': 'Action',
        'genre': 'Crime',
        'description': 'Batman faces a mysterious villain known as the Joker',
        'rating': 9.0,
        'reviews': 2891,
        'runtime': '152 min',
        'year': '2008',
        'director': 'Christopher Nolan',
        'platform': 'HBO Max',
      },
      {
        'name': 'Parasite',
        'category': 'Drama',
        'genre': 'Thriller',
        'description':
            'A cunning family infiltrates a wealthy household with deceptive identities',
        'rating': 8.6,
        'reviews': 1456,
        'runtime': '132 min',
        'year': '2019',
        'director': 'Bong Joon-ho',
        'platform': 'Hulu',
      },
    ],
  };

  Map<String, dynamic> currentResult = {};

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    if (widget.selectedCategory.isNotEmpty) {
      selectedCategory = widget.selectedCategory;
    }

    if (widget.autoSpin && widget.selectedCategory.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startSpinning();
      });
    }
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  void _startSpinning() {
    if (isSpinning) return;

    setState(() {
      isSpinning = true;
    });

    _spinController.repeat();

    Future.delayed(const Duration(seconds: 2), () {
      _spinController.stop();
      _getRandomLocation();
    });
  }

  void _getRandomLocation() {
    final locations = mockLocations[selectedCategory] ?? [];
    if (locations.isNotEmpty) {
      List<Map<String, dynamic>> filtered = locations;

      // Apply filters
      if (selectedFilters.isNotEmpty) {
        filtered = filtered.where((location) {
          final category = location['category'] ?? location['genre'] ?? '';
          return selectedFilters.contains(category);
        }).toList();
      }

      if (filtered.isEmpty) filtered = locations;

      final random = (filtered..shuffle()).first;
      setState(() {
        currentResult = random;
        isSpinning = false;
      });

      _showResultBottomSheet();
    } else {
      setState(() {
        isSpinning = false;
      });
    }
  }

  void _showResultBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return _buildResultCard(setState);
        },
      ),
    );
  }

  LinearGradient _getCategoryGradient(String category) {
    switch (category) {
      case 'Food':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFF6900), Color(0xFFFB2C36)],
        );
      case 'Activity':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF00C950), Color(0xFF00BC7D)],
        );
      case 'Entertainment':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2B7FFF), Color(0xFF00B8DB)],
        );
      default:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF9810FA), Color(0xFFC800DE)],
        );
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.restaurant;
      case 'Activity':
        return Icons.landscape;
      case 'Entertainment':
        return Icons.movie;
      default:
        return Icons.location_on;
    }
  }

  Widget _buildResultCard(StateSetter bottomSheetSetState) {
    if (selectedCategory == 'Entertainment') {
      return _buildEntertainmentCard(bottomSheetSetState);
    } else {
      return _buildLocationCard(bottomSheetSetState);
    }
  }

  Widget _buildEntertainmentCard(StateSetter bottomSheetSetState) {
    final movieName = currentResult['name'] ?? 'Movie';
    final currentRating = ratings[movieName] ?? 0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF59168B), Color(0xFF721378)],
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
              const SizedBox(height: 20),

              // MOVIE POSTER SECTION - Gradient top + Shadow
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: _getCategoryGradient('Entertainment'),
                  border: Border.all(
                    color: const Color(0xFFC27AFF).withOpacity(0.3),
                    width: 1.33,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF000000).withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 0,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.movie,
                        color: Color(0xFFE12AFB),
                        size: 64,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        currentResult['name'] ?? 'Movie',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // BOTTOM SECTION - Dark background with stroke
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFF000000).withOpacity(0.4),
                  border: Border.all(
                    color: const Color(0xFFAD46FF).withOpacity(0.3),
                    width: 1.07,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF000000).withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 0,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentResult['name'] ?? 'Movie Title',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // GENRE TAGS - Gradient with stroke
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (currentResult['category'] != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF59168B),
                                    Color(0xFF721378),
                                  ],
                                ),
                                border: Border.all(
                                  color: const Color(
                                    0xFFC27AFF,
                                  ).withOpacity(0.2),
                                  width: 1.07,
                                ),
                              ),
                              child: Text(
                                currentResult['category'] ?? '',
                                style: const TextStyle(
                                  color: Color(0xFFE12AFB),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          if (currentResult['genre'] != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF59168B),
                                    Color(0xFF721378),
                                  ],
                                ),
                                border: Border.all(
                                  color: const Color(
                                    0xFFC27AFF,
                                  ).withOpacity(0.2),
                                  width: 1.07,
                                ),
                              ),
                              child: Text(
                                currentResult['genre'] ?? '',
                                style: const TextStyle(
                                  color: Color(0xFFE12AFB),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // DESCRIPTION - DAB2FF at 60%
                      Text(
                        currentResult['description'] ?? '',
                        style: TextStyle(
                          color: const Color(0xFFDAB2FF).withOpacity(0.6),
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // METADATA ROW
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [0.0, 1.0],
                            colors: [Color(0xFF59168B), Color(0xFF721378)],
                          ),
                          border: Border.all(
                            color: const Color(0xFFC27AFF).withOpacity(0.2),
                            width: 1.07,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${currentResult['rating']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 18,
                                ),
                              ],
                            ),
                            Container(
                              height: 20,
                              width: 1,
                              color: const Color(0xFF757575),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: const Color(
                                    0xFFBDBDBD,
                                  ).withOpacity(0.6),
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  currentResult['runtime'] ?? 'N/A',
                                  style: TextStyle(
                                    color: const Color(
                                      0xFFE0E0E0,
                                    ).withOpacity(0.6),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 20,
                              width: 1,
                              color: const Color(0xFF757575),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.tv,
                                  color: Color(0xFF00BCD4),
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'Movie',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // PLATFORM SECTION
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [0.0, 1.0],
                            colors: [Color(0xFF59168B), Color(0xFF721378)],
                          ),
                          border: Border.all(
                            color: const Color(0xFFC27AFF).withOpacity(0.2),
                            width: 1.07,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Platform:',
                              style: TextStyle(
                                color: const Color(0xFFBDBDBD).withOpacity(0.6),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF59168B),
                                    Color(0xFF721378),
                                  ],
                                ),
                                border: Border.all(
                                  color: const Color(
                                    0xFFC27AFF,
                                  ).withOpacity(0.3),
                                  width: 1.07,
                                ),
                              ),
                              child: Text(
                                currentResult['platform'] ?? 'Streaming',
                                style: const TextStyle(
                                  color: Color(0xFFDAB2FF),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // RATE THIS SHOW - Gradient with stroke - NOW INTERACTIVE
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [0.0, 1.0],
                            colors: [Color(0xFF59168B), Color(0xFF721378)],
                          ),
                          border: Border.all(
                            color: const Color(0xFFC27AFF).withOpacity(0.2),
                            width: 1.07,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'RATE THIS SHOW',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                5,
                                (index) => GestureDetector(
                                  onTap: () {
                                    bottomSheetSetState(() {
                                      ratings[movieName] = index + 1;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                    ),
                                    child: Icon(
                                      currentRating > index
                                          ? Icons.star
                                          : Icons.star_outline,
                                      color: currentRating > index
                                          ? Colors.amber
                                          : const Color(0xFFE12AFB),
                                      size: 26,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // View Details Button
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF9810FA), Color(0xFFC800DE)],
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.circular(12),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'View Details',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Save and Share Buttons - 8EC5FF at 100%
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF8EC5FF),
                                  width: 1.5,
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {},
                                  borderRadius: BorderRadius.circular(12),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.favorite_outline,
                                          color: Color(0xFF8EC5FF),
                                          size: 18,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Save',
                                          style: TextStyle(
                                            color: Color(0xFF8EC5FF),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF8EC5FF),
                                  width: 1.5,
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {},
                                  borderRadius: BorderRadius.circular(12),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.share,
                                          color: Color(0xFF8EC5FF),
                                          size: 18,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Share',
                                          style: TextStyle(
                                            color: Color(0xFF8EC5FF),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Spin Again Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF2B7FFF), Color(0xFF00B8DB)],
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: const Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.restart_alt,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Spin Again!',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
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
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationCard(StateSetter bottomSheetSetState) {
    final locationName = currentResult['name'] ?? 'Location';
    final currentRating = ratings[locationName] ?? 0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF59168B), Color(0xFF721378)],
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
              const SizedBox(height: 16),

              // MAP SECTION - Gradient top + Shadow
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: _getCategoryGradient(selectedCategory),
                  border: Border.all(
                    color: const Color(0xFFC27AFF).withOpacity(0.3),
                    width: 1.33,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF000000).withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 0,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    _getCategoryIcon(selectedCategory),
                    color: const Color(0xFFE12AFB),
                    size: 48,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // BOTTOM SECTION - Dark background with stroke
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFF000000).withOpacity(0.4),
                  border: Border.all(
                    color: const Color(0xFFAD46FF).withOpacity(0.3),
                    width: 1.07,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF000000).withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 0,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color(0xFF00C950),
                            ),
                            child: const Text(
                              'Open',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Text(
                        currentResult['name'] ?? 'Location',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Category tag - Gradient with stroke
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF59168B), Color(0xFF721378)],
                          ),
                          border: Border.all(
                            color: const Color(0xFFC27AFF).withOpacity(0.2),
                            width: 1.07,
                          ),
                        ),
                        child: Text(
                          currentResult['category'] ?? '',
                          style: const TextStyle(
                            color: Color(0xFFDAB2FF),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Description - DAB2FF at 60%
                      Text(
                        currentResult['description'] ?? '',
                        style: TextStyle(
                          color: const Color(0xFFDAB2FF).withOpacity(0.6),
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Rating, distance, duration, price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildResultInfo(
                            icon: Icons.star,
                            value:
                                '${currentResult['rating']} (${currentResult['reviews']})',
                            color: Colors.amber,
                          ),
                          if (currentResult['distance'] != null)
                            _buildResultInfo(
                              icon: Icons.directions_walk,
                              value: currentResult['distance'],
                              color: const Color(0xFFE12AFB),
                            ),
                          if (currentResult['duration'] != null)
                            _buildResultInfo(
                              icon: Icons.access_time,
                              value: currentResult['duration'],
                              color: const Color(0xFF00BCD4),
                            ),
                          if (currentResult['price'] != null)
                            _buildResultInfo(
                              icon: Icons.attach_money,
                              value: currentResult['price'],
                              color: const Color(0xFF00C950),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // RATE THIS GEM - Gradient with stroke - NOW INTERACTIVE
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [0.0, 1.0],
                            colors: [Color(0xFF59168B), Color(0xFF721378)],
                          ),
                          border: Border.all(
                            color: const Color(0xFFC27AFF).withOpacity(0.2),
                            width: 1.07,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'RATE THIS GEM',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                5,
                                (index) => GestureDetector(
                                  onTap: () {
                                    bottomSheetSetState(() {
                                      ratings[locationName] = index + 1;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    child: Icon(
                                      currentRating > index
                                          ? Icons.star
                                          : Icons.star_outline,
                                      color: currentRating > index
                                          ? Colors.amber
                                          : const Color(0xFFE12AFB),
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // View Details Button
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF9810FA),
                                    Color(0xFFC800DE),
                                  ],
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {},
                                  borderRadius: BorderRadius.circular(12),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.remove_red_eye,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'View Details',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Save and Share Buttons - 8EC5FF at 100%
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF8EC5FF),
                                  width: 1.5,
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {},
                                  borderRadius: BorderRadius.circular(12),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.favorite_outline,
                                          color: Color(0xFF8EC5FF),
                                          size: 18,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Save',
                                          style: TextStyle(
                                            color: Color(0xFF8EC5FF),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF8EC5FF),
                                  width: 1.5,
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {},
                                  borderRadius: BorderRadius.circular(12),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.share,
                                          color: Color(0xFF8EC5FF),
                                          size: 18,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Share',
                                          style: TextStyle(
                                            color: Color(0xFF8EC5FF),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Spin Again Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF2B7FFF), Color(0xFF00B8DB)],
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: const Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.restart_alt,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Spin Again!',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
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
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInfoPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF1A1A1A).withOpacity(0.95),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFF1A1A1A),
              border: Border.all(
                color: const Color(0xFFAD46FF).withOpacity(0.4),
                width: 1.5,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 40),
                      Center(
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFE12AFB), Color(0xFFD946EF)],
                            ),
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'How the Randomizer Works',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildInfoStep(
                    icon: Icons.tune,
                    iconColor: const Color(0xFFE12AFB),
                    title: 'Select Filters (Optional)',
                    description:
                        'Choose a category and subcategory to narrow down your options',
                  ),
                  const SizedBox(height: 16),
                  _buildInfoStep(
                    icon: Icons.auto_awesome,
                    iconColor: const Color(0xFFD946EF),
                    title: 'Spin the Randomizer',
                    description:
                        'Hit the spin button and watch as we find your next best recommendation!',
                  ),
                  const SizedBox(height: 16),
                  _buildInfoStep(
                    icon: Icons.favorite,
                    iconColor: const Color(0xFFE12AFB),
                    title: 'View Details & Rate',
                    description:
                        'Check out full details, rate your experience, and save your favorites',
                  ),
                  const SizedBox(height: 16),
                  _buildInfoStep(
                    icon: Icons.refresh,
                    iconColor: const Color(0xFF00BCD4),
                    title: 'Spin Again',
                    description:
                        'Not feeling it? Spin again for another random suggestion!',
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE12AFB), Color(0xFFD946EF)],
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(8),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Got It!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.auto_awesome,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoStep({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: iconColor.withOpacity(0.15),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: const Color(0xFF9E9E9E),
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 0.1,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF9D00FF), Color(0xFFB300FF)],
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            stops: const [0.0, 0.5, 1.0],
                            colors: const [
                              Color(0xFF00D3F2),
                              Color(0xFFC27AFF),
                              Color(0xFFED6AFF),
                            ],
                          ).createShader(bounds),
                          child: const Text(
                            'Randomizer',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _showInfoPopup,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF9D00FF), Color(0xFFB300FF)],
                          ),
                        ),
                        child: const Icon(
                          Icons.info_outline,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Finding your next ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFDAB2FF),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        TextSpan(
                          text: selectedCategory,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFDAB2FF),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const TextSpan(
                          text: ' pick...',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFDAB2FF),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [0.4, 1.0],
                              colors: [Color(0xFF59168B), Color(0xFF721378)],
                            ),
                            border: Border.all(
                              color: const Color(0xFFC27AFF).withOpacity(0.3),
                              width: 1.33,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFAD46FF).withOpacity(0.1),
                                blurRadius: 25,
                                spreadRadius: -5,
                                offset: const Offset(0, 20),
                              ),
                              BoxShadow(
                                color: const Color(0xFFAD46FF).withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: -6,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'CHOOSE YOUR EXPERIENCE',
                                style: TextStyle(
                                  color: Color(0xFF00BCD4),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: ['Food', 'Activity', 'Entertainment']
                                    .map((category) {
                                      bool isSelected =
                                          selectedCategory == category;
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedCategory = category;
                                            selectedFilters.clear();
                                          });
                                        },
                                        child: Container(
                                          width: 90,
                                          height: 90,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                            gradient: isSelected
                                                ? LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: category == 'Food'
                                                        ? const [
                                                            Color(0xFFFF6900),
                                                            Color(0xFFFB2C36),
                                                          ]
                                                        : category == 'Activity'
                                                        ? const [
                                                            Color(0xFF00C950),
                                                            Color(0xFF00BC7D),
                                                          ]
                                                        : const [
                                                            Color(0xFF2B7FFF),
                                                            Color(0xFF00B8DB),
                                                          ],
                                                  )
                                                : null,
                                            color: !isSelected
                                                ? const Color(
                                                    0xFF000000,
                                                  ).withOpacity(0.5)
                                                : null,
                                            border: Border.all(
                                              color: const Color(
                                                0xFFC27AFF,
                                              ).withOpacity(0.2),
                                              width: 1.33,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                category == 'Food'
                                                    ? '🍕'
                                                    : category ==
                                                          'Entertainment'
                                                    ? '🎬'
                                                    : '⚡',
                                                style: const TextStyle(
                                                  fontSize: 28,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                category,
                                                style: TextStyle(
                                                  color: isSelected
                                                      ? Colors.white
                                                      : const Color(0xFFDAB2FF),
                                                  fontSize: 12,
                                                  fontWeight: isSelected
                                                      ? FontWeight.w700
                                                      : FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    })
                                    .toList(),
                              ),
                              const SizedBox(height: 20),
                              
                              // FILTERS SECTION
                              if (selectedCategory.isNotEmpty) ...[
                                const Text(
                                  'REFINE SEARCH (MULTI-SELECT)',
                                  style: TextStyle(
                                    color: Color(0xFF00BCD4),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    ...categoryFilters[selectedCategory]
                                            ?.map((filter) {
                                          bool isSelected =
                                              selectedFilters.contains(filter);
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (isSelected) {
                                                  selectedFilters
                                                      .remove(filter);
                                                } else {
                                                  selectedFilters.add(filter);
                                                }
                                              });
                                            },
                                            child: Container(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                gradient: isSelected
                                                    ? const LinearGradient(
                                                        begin: Alignment
                                                            .topLeft,
                                                        end: Alignment
                                                            .bottomRight,
                                                        colors: [
                                                          Color(0xFF2B7FFF),
                                                          Color(0xFF00B8DB),
                                                        ],
                                                      )
                                                    : null,
                                                color: !isSelected
                                                    ? Colors.transparent
                                                    : null,
                                                border: Border.all(
                                                  color: isSelected
                                                      ? Colors.transparent
                                                      : const Color(0xFFC27AFF)
                                                          .withOpacity(0.3),
                                                  width: 1.07,
                                                ),
                                              ),
                                              child: Text(
                                                filter,
                                                style: TextStyle(
                                                  color: isSelected
                                                      ? Colors.white
                                                      : const Color(0xFFDAB2FF),
                                                  fontSize: 12,
                                                  fontWeight: isSelected
                                                      ? FontWeight.w600
                                                      : FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList() ??
                                        [],
                                    if (selectedFilters.isNotEmpty)
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedFilters.clear();
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.transparent,
                                            border: Border.all(
                                              color: const Color(0xFFC27AFF)
                                                  .withOpacity(0.3),
                                              width: 1.07,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text(
                                                '✕ ',
                                                style: TextStyle(
                                                  color: Color(0xFFFF6B9D),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const Text(
                                                'Clear All',
                                                style: TextStyle(
                                                  color: Color(0xFFFF6B9D),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                              ],

                              // FAVORITES TOGGLE
                              Row(
                                children: [
                                  const Icon(
                                    Icons.favorite,
                                    color: Color(0xFFFF6B9D),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  const Expanded(
                                    child: Text(
                                      'Favorites Only',
                                      style: TextStyle(
                                        color: Color(0xFFDAB2FF),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Switch(
                                      value: favoritesOnly,
                                      onChanged: (value) {
                                        setState(() {
                                          favoritesOnly = value;
                                        });
                                      },
                                      activeThumbColor:
                                          const Color(0xFF2B7FFF),
                                      inactiveTrackColor:
                                          Colors.grey.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Spin Button
                        if (!isSpinning)
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  stops: [0.0, 0.5, 1.0],
                                  colors: [
                                    Color(0xFFF0B100),
                                    Color(0xFFFF6900),
                                    Color(0xFFFB2C36),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFFB923C,
                                    ).withOpacity(0.6),
                                    blurRadius: 40,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: selectedCategory.isEmpty
                                      ? null
                                      : _startSpinning,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.auto_awesome,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Spin for My Next Best!',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
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
                          )
                        else
                          SizedBox(
                            width: double.infinity,
                            height: 90,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  stops: [0.0, 0.5, 1.0],
                                  colors: [
                                    Color(0xFFF0B100),
                                    Color(0xFFFF6900),
                                    Color(0xFFFB2C36),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFFB923C,
                                    ).withOpacity(0.6),
                                    blurRadius: 40,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RotationTransition(
                                      turns: _spinController,
                                      child: const Text(
                                        '⚡',
                                        style: TextStyle(fontSize: 32),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    const Text(
                                      'SPINNING...',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'finding your next best experience',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildResultInfo({
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
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
          currentIndex: 3,
          selectedItemColor: const Color(0xFF9D00FF),
          unselectedItemColor: const Color(0xFF616161),
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
            if (index == 0) {
              Navigator.pop(context);
            } else if (index == 1) {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const SearchScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(parent: animation, curve: Curves.ease)),
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 500),
                ),
              );
            } else if (index == 2) {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const FavoritesScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(parent: animation, curve: Curves.ease)),
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 500),
                ),
              );
            }
            // Index 3 is current screen (Randomize), no action needed
          },
        ),
      ],
    );
  }
}