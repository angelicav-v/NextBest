import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import 'randomizer_screen.dart';
import 'favorites_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String selectedCategory = 'All';
  Set<String> selectedFilters = {};
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();

  final Map<String, List<String>> categoryFilters = {
    'Food': ['All', 'Italian', 'Japanese', 'American', 'Mexican', 'Thai', 'Indian', 'Chinese'],
    'Activity': ['All', 'Outdoor', 'Indoor', 'Adventure', 'Relaxing', 'Sports', 'Cultural'],
    'Entertainment': ['All', 'Drama', 'Action', 'Comedy', 'Thriller', 'Horror', 'Romance', 'Sci-Fi'],
  };

  final Map<String, List<Map<String, dynamic>>> allLocations = {
    'Food': [
      {
        'name': 'Millhouse Restaurant',
        'category': 'American',
        'description': 'Southern comfort food in a historic setting',
        'rating': 4.8,
        'reviews': 324,
        'duration': '45 min',
        'distance': '0.6 mi',
        'price': '\$\$',
        'status': 'Open',
        'statusColor': const Color(0xFF00C950),
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
        'status': 'Open',
        'statusColor': const Color(0xFF00C950),
      },
    ],
    'Activity': [
      {
        'name': 'Mill Creek Park',
        'category': 'Outdoor',
        'description': 'Beautiful park with walking trails and playground',
        'rating': 4.9,
        'reviews': 198,
        'distance': '1.2 mi',
        'duration': '2 hours',
        'price': 'Free',
        'status': 'Open',
        'statusColor': const Color(0xFF00C950),
      },
    ],
    'Entertainment': [
      {
        'name': 'The Dark Knight',
        'category': 'Action',
        'description': 'Batman faces a mysterious villain known as the Joker',
        'rating': 9.0,
        'reviews': 2891,
        'duration': '152 min',
        'status': 'Streaming',
        'statusColor': const Color(0xFF2B7FFF),
      },
    ],
  };

  List<Map<String, dynamic>> getFilteredResults() {
    List<Map<String, dynamic>> results = [];

    if (selectedCategory == 'All') {
      allLocations.forEach((category, locations) {
        results.addAll(locations);
      });
    } else {
      results = allLocations[selectedCategory] ?? [];
    }

    if (selectedFilters.isNotEmpty && selectedFilters.first != 'All') {
      results = results.where((location) {
        return selectedFilters.contains(location['category']);
      }).toList();
    }

    if (searchQuery.isNotEmpty) {
      results = results.where((location) {
        return location['name'].toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    return results;
  }

  List<String> getAvailableFilters() {
    if (selectedCategory == 'All') {
      return ['All'];
    }
    return categoryFilters[selectedCategory] ?? ['All'];
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case 'Food':
        return const Color(0xFFFF9500);
      case 'Activity':
        return const Color(0xFF00C950);
      case 'Entertainment':
        return const Color(0xFF2B7FFF);
      default:
        return const Color(0xFFAD46FF);
    }
  }

  IconData _getCategoryIcon(String categoryType) {
    if (categoryType.contains('Outdoor') || categoryType.contains('Indoor') || categoryType.contains('Adventure') || categoryType.contains('Relaxing') || categoryType.contains('Sports') || categoryType.contains('Cultural')) {
      return Icons.landscape;
    } else if (categoryType.contains('Drama') || categoryType.contains('Action') || categoryType.contains('Comedy') || categoryType.contains('Thriller') || categoryType.contains('Horror') || categoryType.contains('Romance') || categoryType.contains('Sci-Fi')) {
      return Icons.movie;
    } else if (categoryType.contains('Italian') || categoryType.contains('Japanese') || categoryType.contains('American') || categoryType.contains('Mexican') || categoryType.contains('Thai') || categoryType.contains('Indian') || categoryType.contains('Chinese')) {
      return Icons.restaurant;
    }
    return Icons.location_on;
  }

  LinearGradient _getCategoryGradient(String categoryType) {
    if (categoryType.contains('Outdoor') || categoryType.contains('Indoor') || categoryType.contains('Adventure') || categoryType.contains('Relaxing') || categoryType.contains('Sports') || categoryType.contains('Cultural')) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF00C950), Color(0xFF00BC7D)],
      );
    } else if (categoryType.contains('Drama') || categoryType.contains('Action') || categoryType.contains('Comedy') || categoryType.contains('Thriller') || categoryType.contains('Horror') || categoryType.contains('Romance') || categoryType.contains('Sci-Fi')) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF2B7FFF), Color(0xFF00B8DB)],
      );
    } else {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFF6900), Color(0xFFFB2C36)],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredResults = getFilteredResults();
    final availableFilters = getAvailableFilters();

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
                        child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            stops: const [0.0, 0.5, 1.0],
                            colors: const [Color(0xFF00D3F2), Color(0xFFC27AFF), Color(0xFFED6AFF)],
                          ).createShader(bounds),
                          child: const Text(
                            'Search & Discover',
                            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 32),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black.withOpacity(0.3),
                            border: Border.all(color: const Color(0xFFAD46FF).withOpacity(0.3), width: 1.07),
                          ),
                          child: TextField(
                            controller: searchController,
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                            },
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            decoration: InputDecoration(
                              hintText: 'Search by name, keyword, or description',
                              hintStyle: TextStyle(color: const Color(0xFFDAB2FF).withOpacity(0.5), fontSize: 14),
                              border: InputBorder.none,
                              icon: const Icon(Icons.search, color: Color(0xFFAD46FF), size: 20),
                              contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: ['All', 'Food', 'Activity', 'Entertainment']
                              .map((category) {
                            bool isSelected = selectedCategory == category;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCategory = category;
                                  selectedFilters.clear();
                                  searchQuery = '';
                                  searchController.clear();
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: isSelected
                                      ? LinearGradient(colors: [getCategoryColor(category), getCategoryColor(category).withOpacity(0.8)])
                                      : null,
                                  color: isSelected ? null : Colors.transparent,
                                  border: Border.all(color: isSelected ? Colors.transparent : const Color(0xFFAD46FF).withOpacity(0.3), width: 1.07),
                                ),
                                child: Text(
                                  category == 'Food' ? '🍕 $category' : category == 'Activity' ? '⚡ $category' : category == 'Entertainment' ? '🎬 $category' : category,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : const Color(0xFFDAB2FF),
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 12),
                        if (selectedCategory != 'All')
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: availableFilters.map((filter) {
                              bool isSelected = selectedFilters.contains(filter);
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      selectedFilters.remove(filter);
                                    } else {
                                      if (filter == 'All') {
                                        selectedFilters.clear();
                                      } else {
                                        selectedFilters.add(filter);
                                      }
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: isSelected ? LinearGradient(colors: [getCategoryColor(selectedCategory), getCategoryColor(selectedCategory).withOpacity(0.7)]) : null,
                                    color: isSelected ? null : Colors.transparent,
                                    border: Border.all(color: isSelected ? Colors.transparent : const Color(0xFFAD46FF).withOpacity(0.3), width: 1.07),
                                  ),
                                  child: Text(filter, style: TextStyle(color: isSelected ? Colors.white : const Color(0xFFDAB2FF), fontSize: 12, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500)),
                                ),
                              );
                            }).toList(),
                          ),
                        const SizedBox(height: 16),
                        if (filteredResults.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Found ${filteredResults.length}', style: const TextStyle(color: Color(0xFFDAB2FF), fontSize: 12, fontWeight: FontWeight.w400)),
                              ...filteredResults.map((result) => _buildResultCard(result)),
                              const SizedBox(height: 32),
                            ],
                          ),
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

  Widget _buildResultCard(Map<String, dynamic> result) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF000000).withOpacity(0.4),
        border: Border.all(color: const Color(0xFFAD46FF).withOpacity(0.3), width: 1.07),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: _getCategoryGradient(result['category']),
                border: Border.all(color: const Color(0xFFC27AFF).withOpacity(0.3), width: 1.33),
              ),
              child: Center(
                child: Icon(_getCategoryIcon(result['category']), color: const Color(0xFFE12AFB).withOpacity(0.5), size: 48),
              ),
            ),
            const SizedBox(height: 12),
            Text(result['name'], style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(result['description'], style: TextStyle(color: const Color(0xFFDAB2FF).withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.w300)),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), gradient: const LinearGradient(colors: [Color(0xFF9810FA), Color(0xFFC800DE)])),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(12),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text('View Details', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          child: Divider(color: const Color(0xFFAD46FF), height: 1, thickness: 1),
        ),
        BottomNavigationBar(
          backgroundColor: Colors.black,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: 1,
          selectedItemColor: const Color(0xFF9D00FF),
          unselectedItemColor: const Color(0xFF616161),
          selectedLabelStyle: const TextStyle(fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), label: 'Favorites'),
            BottomNavigationBarItem(icon: Icon(Icons.grid_on), label: 'Randomize'),
          ],
          onTap: (index) {
            if (index == 0) {
              Navigator.pop(context);
            } else if (index == 2) {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => const FavoritesScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(CurvedAnimation(parent: animation, curve: Curves.ease)),
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 500),
                ),
              );
            } else if (index == 3) {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => const RandomizerScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(CurvedAnimation(parent: animation, curve: Curves.ease)),
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 500),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}