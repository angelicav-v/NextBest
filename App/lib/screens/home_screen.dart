import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import '../app_navigator.dart';

class HomeScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final bool showInfoPopup;

  const HomeScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    this.showInfoPopup = false,
  });

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

  // get username from storage and display it
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

  // hides the info popup and marks it as seen
  void _dismissInfoPopup() {
    setState(() {
      _showInfoPopup = false;
    });
    AuthManager.markInfoPopupSeen();
  }

  // shows the info popup again when info button is tapped
  void _showInfoPopupAgain() {
    setState(() {
      _showInfoPopup = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: GradientBackground(
        child: Stack(
          children: [
            // fixed header at the top
            _buildHeader(),

            // scrollable content below header
            _buildScrollableContent(),

            // popup overlay (only shows if _showInfoPopup is true)
            if (_showInfoPopup) _buildInfoPopup(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
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
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // builds the fixed header section
  Widget _buildHeader() {
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
              // top row with profile, logo, and settings icons
              _buildTopBar(),
              const SizedBox(height: 29),

              // location text
              _buildLocationRow(),
              const SizedBox(height: 22),

              // greeting message
              Text(
                'Hi $_username, ready to find something fun?',
                style: const TextStyle(
                  color: Color(0xFFDAB2FF),
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  height: 20 / 14,
                ),
              ),
              const SizedBox(height: 14),
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
        Container(
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

        // app logo and name
        Row(
          children: [
            Container(
              width: 53,
              height: 53,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(
                    0xFFD946EF,
                  ), // or whatever gradient color you want
                  width: 0.7,
                ),
                color: Colors.transparent, // No fill!
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
                  fontSize: 18,
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
              onTap: _showInfoPopupAgain,
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
              onTap: () => print('Settings tapped'),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.location_on, color: Color(0xFFC27AFF), size: 14),
        const SizedBox(width: 6),
        const Text(
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

  // builds the scrollable content section
Widget _buildScrollableContent() {
  return Padding(
    padding: const EdgeInsets.only(top: 220),
    child: SafeArea(
      top: false,
      bottom: true, // include bottom safe area
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildCategorySection(),
                    const SizedBox(height: 24),
                    _buildSpinButton(),
                    const SizedBox(height: 14),
                    _buildSearchButton(),
                    const SizedBox(height: 28),
                    _buildFavoritesSection(),
                    const SizedBox(height: 28),
                    _buildFriendVotesSection(),
                    const SizedBox(height: 28),
                    _buildSharedSection(),
                    const SizedBox(height: 60), // extra breathing room
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}


  // category selection section
  Widget _buildCategorySection() {
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
        Text(
          'Choose what you\'re in the mood for',
          style: TextStyle(
            color: const Color(0xFFC27AFF),
            fontSize: 16,
            fontWeight: FontWeight.w100,
            letterSpacing: 0.05,
          ),
        ),
        const SizedBox(height: 20),

        // entertainment button - full width
        _buildCategoryButton(
          '🎬',
          'Entertainment',
          const Color(0xFFEC4899),
          () => print('Entertainment tapped'),
        ),
        const SizedBox(height: 12),

        // food and activities buttons side by side
        Row(
          children: [
            Expanded(
              child: _buildCategoryButton(
                '🍔',
                'Food',
                const Color(0xFFEA580C),
                () => print('Food tapped'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCategoryButton(
                '⚡',
                'Activities',
                const Color(0xFF22C55E),
                () => print('Activities tapped'),
                icon: Icons.bolt,
                iconColor: Colors.amber,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Pick a category above, then spin to\ndiscover your next best spot!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color.fromARGB(255, 201, 156, 240),
            fontSize: 14,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.1,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryButton(
    String emoji,
    String label,
    Color borderColor,
    VoidCallback onTap, {
    IconData? icon,
    Color? iconColor,
  }) {
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
                else
                  Text(emoji, style: const TextStyle(fontSize: 24)),
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

  Widget _buildSpinButton() {
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
            onTap: () => print('Spin tapped'),
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

 Widget _buildSearchButton() {
  return SizedBox(
    width: double.infinity,
    height: 52,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF000000).withValues(alpha: 0.4),
        border: Border.all(
          color: const Color(0xFFAD46FF).withValues(alpha: 0.3),
          width: 1.07,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => print('Search tapped'),
          borderRadius: BorderRadius.circular(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search, 
                color: const Color(0xFFDAB2FF),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Search Manually',
                style: TextStyle(
                  color: const Color(0xFFDAB2FF),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
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

  Widget _buildFavoritesSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFE12AFB),
                    const Color(0xFFE12AFB).withOpacity(0.7),
                  ],
                ),
              ),
              child: const Icon(Icons.favorite, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            const Text(
              'View Favorites',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => print('View All Favorites'),
          child: const Text(
            'View All >',
            style: TextStyle(
              color: Color(0xFFE12AFB),
              fontSize: 13,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFriendVotesSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF2B7FFF),
                        const Color(0xFF2B7FFF).withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.people_outline,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Friend Votes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => print('Share Your Pick'),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2B7FFF), Color(0xFF1E5FCC)],
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.share, color: Colors.white, size: 14),
                    SizedBox(width: 5),
                    Text(
                      'Share',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
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
        _buildFriendVoteCard(
          friendName: 'Sarah voted',
          placeName: 'Main Street Farmers Market',
          votes: '12',
        ),
        const SizedBox(height: 10),
        _buildFriendVoteCard(
          friendName: 'Mike voted for',
          placeName: 'Luetta Moore Park',
          votes: '8',
        ),
      ],
    );
  }

  Widget _buildSharedSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF2B7FFF),
                        const Color(0xFF2B7FFF).withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.share_outlined,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Shared with You',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
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
                'The Varsity',
              ];
              final categories = ['Activities', 'Food', 'Entertainment'];

              return Padding(
                padding: EdgeInsets.only(right: index == 2 ? 0 : 12),
                child: _buildSharedCard(
                  name: names[index],
                  place: places[index],
                  category: categories[index],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // card showing friend's vote for a place
  Widget _buildFriendVoteCard({
    required String friendName,
    required String placeName,
    required String votes,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade900, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF9D00FF), Color(0xFFB300FF)],
              ),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friendName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.05,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  placeName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
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
              const Icon(Icons.favorite, color: Color(0xFFE12AFB), size: 16),
              const SizedBox(width: 4),
              Text(
                votes,
                style: const TextStyle(
                  color: Color(0xFFE12AFB),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.05,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // card showing place shared by a friend
  Widget _buildSharedCard({
    required String name,
    required String place,
    required String category,
  }) {
    return Container(
      width: 130,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade900, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF9D00FF), Color(0xFFB300FF)],
                  ),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 12),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
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
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: const Color(0xFF2B7FFF).withOpacity(0.15),
            ),
            child: Text(
              category,
              style: const TextStyle(
                color: Color(0xFF2B7FFF),
                fontSize: 8,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.05,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // info popup explaining how the app works
  Widget _buildInfoPopup() {
    return Container(
      color: Colors.black.withValues(alpha: 0.8),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF3C0366), Color(0xFF000000), Color(0xFF4B004F)],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF9810FA), Color(0xFFC800DE)],
                  ),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'How NextBest Works',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '1. Pick a category (Food, Activities, or Entertainment)\n\n'
                '2. Spin to get a random recommendation\n\n'
                '3. Check friend votes and shared picks\n\n'
                '4. Save to your favorites\n\n'
                '5. Share your picks with friends',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 0.15,
                  height: 1.8,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
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
                      onTap: _dismissInfoPopup,
                      borderRadius: BorderRadius.circular(12),
                      child: const Center(
                        child: Text(
                          'Got It, Let\'s Go!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
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