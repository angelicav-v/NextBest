import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import 'randomizer_screen.dart';
import 'search_screen.dart';

/// Full screen for viewing and managing favorite items
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String selectedCategory = 'All';
  Set<int> selectedFavorites = {};
  bool isSelectMode = false;
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();
  Map<int, int> ratings = {}; // Track ratings by favorite ID

  // Mock favorites data
  final List<Map<String, dynamic>> allFavorites = [
    {
      'id': 1,
      'name': 'Gnats Stadium',
      'category': 'Entertainment',
      'categoryType': 'Drama',
      'distance': '1.8 mi',
      'rating': 4.8,
      'userRating': 5,
    },
    {
      'id': 2,
      'name': 'Mill Creek Park',
      'category': 'Activity',
      'categoryType': 'Outdoor',
      'distance': '1.2 mi',
      'rating': 4.9,
      'userRating': 5,
    },
    {
      'id': 3,
      'name': 'The Clubhouse',
      'category': 'Food',
      'categoryType': 'American',
      'distance': '0.8 mi',
      'rating': 4.6,
      'userRating': 5,
    },
    {
      'id': 4,
      'name': 'El Sombrero',
      'category': 'Food',
      'categoryType': 'Mexican',
      'distance': '0.9 mi',
      'rating': 4.7,
      'userRating': 4,
    },
    {
      'id': 5,
      'name': 'Averitt Center for',
      'category': 'Entertainment',
      'categoryType': 'Action',
      'distance': '0.5 mi',
      'rating': 4.7,
      'userRating': 4,
    },
    {
      'id': 6,
      'name': 'Splash in the Boro',
      'category': 'Activity',
      'categoryType': 'Adventure',
      'distance': '1.5 mi',
      'rating': 4.5,
      'userRating': 5,
    },
    {
      'id': 7,
      'name': 'Millhouse',
      'category': 'Food',
      'categoryType': 'Italian',
      'distance': '0.6 mi',
      'rating': 4.8,
      'userRating': 5,
    },
    {
      'id': 8,
      'name': 'Georgia',
      'category': 'Activity',
      'categoryType': 'Cultural',
      'distance': '2.1 mi',
      'rating': 4.8,
      'userRating': 4,
    },
  ];

  List<Map<String, dynamic>> getFilteredFavorites() {
    List<Map<String, dynamic>> results = allFavorites;

    if (selectedCategory != 'All') {
      results = results.where((fav) => fav['category'] == selectedCategory).toList();
    }

    if (searchQuery.isNotEmpty) {
      results = results.where((fav) {
        return fav['name'].toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    return results;
  }

  String getSelectedCategory() {
    if (selectedFavorites.isEmpty) return '';
    int firstId = selectedFavorites.first;
    return allFavorites.firstWhere((fav) => fav['id'] == firstId)['category'];
  }

  bool canRandomize() {
    if (selectedFavorites.length < 2 || selectedFavorites.length > 3) return false;

    String category = getSelectedCategory();
    return selectedFavorites.every((id) {
      return allFavorites.firstWhere((fav) => fav['id'] == id)['category'] == category;
    });
  }

  void toggleFavoriteSelection(int id) {
    setState(() {
      if (selectedFavorites.contains(id)) {
        selectedFavorites.remove(id);
      } else {
        selectedFavorites.add(id);
      }
    });
  }

  void handleRandomize() {
    if (!canRandomize()) return;

    String category = getSelectedCategory();

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            RandomizerScreen(selectedCategory: category),
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

  LinearGradient getCategoryGradient(String category) {
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

  IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Activity':
        return Icons.landscape;
      case 'Entertainment':
        return Icons.movie;
      default:
        return Icons.location_on;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredFavorites = getFilteredFavorites();

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (isSelectMode) {
                          setState(() {
                            isSelectMode = false;
                            selectedFavorites.clear();
                          });
                        } else {
                          Navigator.pop(context);
                        }
                      },
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
                            'My Favorites',
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
                      onTap: () {
                        if (isSelectMode) {
                          setState(() {
                            isSelectMode = false;
                            selectedFavorites.clear();
                          });
                        } else {
                          setState(() {
                            isSelectMode = true;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF9D00FF), Color(0xFFB300FF)],
                          ),
                        ),
                        child: Text(
                          isSelectMode ? 'Done' : 'Select',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Saved places count
                        Row(
                          children: [
                            const Icon(
                              Icons.favorite,
                              color: Color(0xFFFF6B9D),
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${filteredFavorites.length} saved',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              filteredFavorites.length == 1 ? 'place' : 'places',
                              style: const TextStyle(
                                color: Color(0xFFDAB2FF),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Search Bar
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black.withOpacity(0.3),
                            border: Border.all(
                              color: const Color(0xFFAD46FF).withOpacity(0.3),
                              width: 1.07,
                            ),
                          ),
                          child: TextField(
                            controller: searchController,
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                            },
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search your favorites...',
                              hintStyle: TextStyle(
                                color: const Color(0xFFDAB2FF).withOpacity(0.5),
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              icon: const Icon(
                                Icons.search,
                                color: Color(0xFFAD46FF),
                                size: 20,
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Category Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: ['All', 'Food', 'Activity', 'Entertainment']
                              .map((category) {
                            bool isSelected = selectedCategory == category;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCategory = category;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: isSelected
                                      ? LinearGradient(
                                          colors: [
                                            getCategoryColor(category),
                                            getCategoryColor(category).withOpacity(0.8),
                                          ],
                                        )
                                      : null,
                                  color: isSelected ? null : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.transparent
                                        : const Color(0xFFAD46FF).withOpacity(0.3),
                                    width: 1.07,
                                  ),
                                ),
                                child: Text(
                                  category == 'Food'
                                      ? '🍕 $category'
                                      : category == 'Activity'
                                          ? '⚡ $category'
                                          : category == 'Entertainment'
                                              ? '🎬 $category'
                                              : category,
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
                        const SizedBox(height: 16),

                        // Recently Added dropdown and Randomize button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.black.withOpacity(0.3),
                                border: Border.all(
                                  color: const Color(0xFFAD46FF).withOpacity(0.3),
                                  width: 1.07,
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Text(
                                    'Recently Added',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.expand_more,
                                    color: Color(0xFFDAB2FF),
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: canRandomize() ? handleRandomize : null,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: canRandomize()
                                      ? const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [Color(0xFFE12AFB), Color(0xFFD946EF)],
                                        )
                                      : LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            const Color(0xFFE12AFB).withOpacity(0.5),
                                            const Color(0xFFD946EF).withOpacity(0.5),
                                          ],
                                        ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Randomize',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(canRandomize() ? 1.0 : 0.5),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Favorites Grid
                        if (filteredFavorites.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 48),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.favorite_outline,
                                    color: const Color(0xFFAD46FF).withOpacity(0.3),
                                    size: 64,
                                  ),
                                  const SizedBox(height: 24),
                                  const Text(
                                    'No favorites yet',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Add favorites from Search\nor Randomizer',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: const Color(0xFFDAB2FF).withOpacity(0.6),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.85,
                            ),
                            itemCount: filteredFavorites.length,
                            itemBuilder: (context, index) {
                              final fav = filteredFavorites[index];
                              final isSelected = selectedFavorites.contains(fav['id']);

                              return GestureDetector(
                                onTap: isSelectMode ? () => toggleFavoriteSelection(fav['id']) : null,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: const Color(0xFF000000).withOpacity(0.4),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFFE12AFB)
                                          : const Color(0xFFAD46FF).withOpacity(0.3),
                                      width: isSelected ? 2.5 : 1.07,
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
                                  child: Stack(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Image with category label
                                          Container(
                                            height: 140,
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(16),
                                                topRight: Radius.circular(16),
                                              ),
                                              gradient: getCategoryGradient(fav['category']),
                                            ),
                                            child: Stack(
                                              children: [
                                                Center(
                                                  child: Icon(
                                                    getCategoryIcon(fav['category']),
                                                    color: const Color(0xFFE12AFB).withOpacity(0.5),
                                                    size: 40,
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 8,
                                                  left: 8,
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(6),
                                                      color: Colors.black.withOpacity(0.5),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          getCategoryIcon(fav['category']),
                                                          color: const Color(0xFFE12AFB),
                                                          size: 12,
                                                        ),
                                                        const SizedBox(width: 4),
                                                        Text(
                                                          fav['category'],
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Details section
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    fav['name'],
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Icon(Icons.star, color: Colors.amber, size: 12),
                                                          const SizedBox(width: 4),
                                                          Text(
                                                            '${fav['rating']}',
                                                            style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 11,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Icon(Icons.location_on, color: Color(0xFFE12AFB), size: 12),
                                                          const SizedBox(width: 2),
                                                          Text(
                                                            fav['distance'],
                                                            style: const TextStyle(
                                                              color: Color(0xFFDAB2FF),
                                                              fontSize: 10,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'You: ',
                                                        style: TextStyle(
                                                          color: Color(0xFFDAB2FF),
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                      ...List.generate(
                                                        5,
                                                        (i) {
                                                          final currentRating = ratings[fav['id']] ?? fav['userRating'];
                                                          return GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                ratings[fav['id']] = i + 1;
                                                              });
                                                            },
                                                            child: Icon(
                                                              i < currentRating ? Icons.star : Icons.star_outline,
                                                              color: Colors.amber,
                                                              size: 10,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Selection checkmark
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isSelectMode
                                                ? (isSelected ? const Color(0xFFE12AFB) : Colors.white.withOpacity(0.2))
                                                : Colors.white.withOpacity(0.2),
                                          ),
                                          child: Center(
                                            child: isSelectMode
                                                ? (isSelected
                                                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                                                    : const SizedBox())
                                                : const Icon(Icons.favorite, color: Color(0xFFFF6B9D), size: 18),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
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
          currentIndex: 2,
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
            } else if (index == 1) {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => const SearchScreen(),
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
            } else if (index == 3) {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => const RandomizerScreen(),
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