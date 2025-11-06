import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import '../app_navigator.dart';

class HomeScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final bool showInfoPopup;

  const HomeScreen({
    Key? key,
    required this.latitude,
    required this.longitude,
    this.showInfoPopup = false,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showInfoPopup = true;
  final ScrollController _scrollController = ScrollController();
  String _username = '';

  @override
  void initState() {
    super.initState();
    _showInfoPopup = widget.showInfoPopup;
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final username = await AuthManager.getUsername();
    setState(() {
      _username = username ?? 'Friend';
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _dismissInfoPopup() {
    setState(() {
      _showInfoPopup = false;
    });
    AuthManager.markInfoPopupSeen();
  }

  void _showInfoPopupAgain() {
    setState(() {
      _showInfoPopup = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      // Top bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF9D00FF),
                                  Color(0xFFB300FF),
                                ],
                              ),
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/nextbest_logo.png',
                                width: 32,
                                height: 32,
                              ),
                              const SizedBox(width: 8),
                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [
                                    Color(0xFF9D00FF),
                                    Color(0xFFB300FF),
                                  ],
                                ).createShader(bounds),
                                child: const Text(
                                  'NextBest',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: _showInfoPopupAgain,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF9D00FF),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.info_outline,
                                    color: Color(0xFF9D00FF),
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  print('Settings tapped');
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF9D00FF),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.settings_outlined,
                                    color: Color(0xFF9D00FF),
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Location
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color(0xFF8B5CF6),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Statesboro, GA',
                            style: TextStyle(
                              color: Color(0xFFD4AFFF),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Greeting
                      Text(
                        'Hi $_username, ready to find something fun?',
                        style: const TextStyle(
                          color: Color(0xFFD4AFFF),
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.1,
                        ),
                      ),
                      const SizedBox(height: 26),
                      // Pick a Category Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Pick a Category',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Choose what you\'re in the mood for',
                            style: TextStyle(
                              color: Color(0xFFD4AFFF),
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Entertainment button - full width - PINK BORDER
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFEC4899),
                                  width: 1.5,
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    print('Entertainment tapped');
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.movie_outlined,
                                        color: Color(0xFFEC4899),
                                        size: 22,
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        'Entertainment',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Food and Activities - side by side
                          Row(
                            children: [
                              // FOOD - RED/ORANGE BORDER
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFFEA580C),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          print('Food tapped');
                                        },
                                        borderRadius: BorderRadius.circular(12),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              '🍔',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            const SizedBox(width: 8),
                                            const Text(
                                              'Food',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 0.2,
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
                              // ACTIVITIES - GREEN BORDER
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFF22C55E),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          print('Activities tapped');
                                        },
                                        borderRadius: BorderRadius.circular(12),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.bolt,
                                              color: Color(0xFF22C55E),
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            const Text(
                                              'Activities',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 0.2,
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
                          const Text(
                            'Pick a category above, then spin to\ndiscover your next best spot!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFD4AFFF),
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.1,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Spin Button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFF9D00FF),
                                Color(0xFFB300FF),
                                Color(0xFFD946EF),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF9D00FF).withOpacity(0.5),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                print('Spin tapped');
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: const Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.dashboard_customize,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 10),
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
                      ),
                      const SizedBox(height: 12),
                      // Search Button
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey.shade800,
                              width: 1,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                print('Search tapped');
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search,
                                    color: Colors.grey.shade700,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Search Manually',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      // View Favorites
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.favorite,
                                color: const Color(0xFFB366FF),
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'View Favorites',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              print('View All Favorites');
                            },
                            child: Text(
                              'View All',
                              style: TextStyle(
                                color: const Color(0xFFB366FF),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 26),
                      // Top Rated Near You
                      Row(
                        children: [
                          Icon(
                            Icons.trending_up,
                            color: const Color(0xFFB366FF),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Top Rated Near You',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Horizontal scrollable Top Rated
                      SizedBox(
                        height: 160,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                right: index == 4 ? 0 : 12,
                              ),
                              child: _buildTopRatedCard(
                                name: index % 2 == 0 ? 'Vandy\'s' : 'Millhouse',
                                rating: 4.9,
                                distance: index % 2 == 0 ? '0.5 mi' : '1.2 mi',
                                status: 'Open',
                                category: index % 2 == 0 ? 'Food' : 'Activities',
                                icon: index % 2 == 0
                                    ? Icons.restaurant_outlined
                                    : Icons.sports_baseball,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 28),
                      // Trending Entertainment
                      Row(
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            color: const Color(0xFFB366FF),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Trending Entertainment',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Horizontal scrollable Entertainment
                      SizedBox(
                        height: 160,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                right: index == 4 ? 0 : 12,
                              ),
                              child: _buildEntertainmentCard(
                                title: index % 2 == 0
                                    ? 'The Midnight\nChronicles'
                                    : 'Shadow\nDetectiv',
                                rating: index % 2 == 0 ? 4.5 : 4.6,
                                source: index % 2 == 0 ? 'Netflix' : 'Hulu',
                                type: 'Movie',
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 28),
                      // Friend Votes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.people,
                                color: const Color(0xFFB366FF),
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Friend Votes',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              print('View All Friend Votes');
                            },
                            child: Text(
                              'View All',
                              style: TextStyle(
                                color: const Color(0xFFB366FF),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildFriendVoteCard(
                        friendName: 'Sarah voted',
                        placeName: 'Main Street Farmers Market',
                        votes: '12',
                      ),
                      const SizedBox(height: 8),
                      _buildFriendVoteCard(
                        friendName: 'Mike voted for',
                        placeName: 'Luetta Moore Park',
                        votes: '8',
                      ),
                      const SizedBox(height: 28),
                      // Shared with You
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.share,
                                color: const Color(0xFFB366FF),
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Shared with You',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              print('Share Your Pick');
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: const Color(0xFF4A90E2).withOpacity(0.2),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.share,
                                    color: Color(0xFF4A90E2),
                                    size: 12,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    'Share Your Pick',
                                    style: TextStyle(
                                      color: Color(0xFF4A90E2),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.05,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            final names = ['Jessica', 'David', 'Sarah'];
                            final places = [
                              'RAC Sports Complex',
                              'El Sombrero',
                              'The Varsity'
                            ];
                            final categories = [
                              'Activities',
                              'Food',
                              'Entertainment'
                            ];

                            return Padding(
                              padding: EdgeInsets.only(
                                right: index == 2 ? 0 : 12,
                              ),
                              child: _buildSharedCard(
                                name: names[index],
                                place: places[index],
                                category: categories[index],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
              // Info Popup
              if (_showInfoPopup) _buildInfoPopup(),
            ],
          ),
        ),
      ),
      // Bottom Navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade900,
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF9D00FF),
          unselectedItemColor: Colors.grey.shade700,
          selectedLabelStyle: const TextStyle(fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_on),
              label: 'Randomize',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRatedCard({
    required String name,
    required double rating,
    required String distance,
    required String status,
    required String category,
    required IconData icon,
  }) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade900,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: const Color(0xFFD4714F),
                size: 20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: const Color(0xFF27AE60).withOpacity(0.2),
                ),
                child: const Text(
                  'Open',
                  style: TextStyle(
                    color: Color(0xFF27AE60),
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.05,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 12,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    rating.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.05,
                    ),
                  ),
                ],
              ),
              Text(
                distance,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 0.05,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: const Color(0xFFB366FF).withOpacity(0.2),
            ),
            child: Text(
              category,
              style: const TextStyle(
                color: Color(0xFFB366FF),
                fontSize: 9,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.05,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntertainmentCard({
    required String title,
    required double rating,
    required String source,
    required String type,
  }) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade900,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.tv,
            color: const Color(0xFFD4714F),
            size: 20,
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.1,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 12,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    rating.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.05,
                    ),
                  ),
                ],
              ),
              Text(
                type,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 9,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 0.05,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: const Color(0xFFB366FF).withOpacity(0.2),
            ),
            child: Text(
              source,
              style: const TextStyle(
                color: Color(0xFFB366FF),
                fontSize: 9,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.05,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendVoteCard({
    required String friendName,
    required String placeName,
    required String votes,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade900,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xFF9D00FF),
                  Color(0xFFB300FF),
                ],
              ),
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 14,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friendName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.05,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  placeName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.favorite,
                color: Color(0xFF9D00FF),
                size: 14,
              ),
              const SizedBox(width: 3),
              Text(
                votes,
                style: const TextStyle(
                  color: Color(0xFF9D00FF),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.05,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSharedCard({
    required String name,
    required String place,
    required String category,
  }) {
    return Container(
      width: 130,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade900,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF9D00FF),
                      Color(0xFFB300FF),
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 12,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            place,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.1,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: const Color(0xFFB366FF).withOpacity(0.2),
            ),
            child: Text(
              category,
              style: const TextStyle(
                color: Color(0xFFB366FF),
                fontSize: 8,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.05,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPopup() {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFF1A1A1A),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF9D00FF),
                      Color(0xFFB300FF),
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'How NextBest Works',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                '1. Pick a category (Food, Activities, or Entertainment)\n\n'
                '2. Spin the wheel to get random recommendations\n\n'
                '3. Browse top-rated places near you\n\n'
                '4. Share your picks with friends\n\n'
                '5. Build your favorites list',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 0.15,
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFF9D00FF),
                        Color(0xFFB300FF),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF9D00FF).withOpacity(0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _dismissInfoPopup,
                      borderRadius: BorderRadius.circular(8),
                      child: const Center(
                        child: Text(
                          'Got It, Let\'s Go!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
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
  }
}