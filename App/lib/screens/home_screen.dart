import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import '../widgets/home/home_header.dart';
import '../widgets/home/category_section.dart';
import '../widgets/home/action_buttons.dart';
import '../widgets/home/friend_vote_card.dart';
import '../widgets/home/info_popup.dart';
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
      extendBody: true,
      body: GradientBackground(
        child: Stack(
          children: [
            // fixed header
            HomeHeader(
              username: _username,
              onInfoTap: _showInfoPopupAgain,
              onSettingsTap: () => print('Settings tapped'),
            ),

            // scrollable content
            _buildScrollableContent(),

            // info popup overlay
            if (_showInfoPopup) InfoPopup(onDismiss: _dismissInfoPopup),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildScrollableContent() {
    return Padding(
      padding: const EdgeInsets.only(top: 220),
      child: SafeArea(
        top: false,
        bottom: true,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              controller: _scrollController,
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      SearchButton(onTap: () => print('Search tapped')),
                      const SizedBox(height: 24),
                      CategorySection(
                        onEntertainmentTap: () => print('Entertainment tapped'),
                        onFoodTap: () => print('Food tapped'),
                        onActivitiesTap: () => print('Activities tapped'),
                      ),
                      const SizedBox(height: 24),
                      SpinButton(onTap: () => print('Spin tapped')),
                      const SizedBox(height: 28),
                      _buildFavoritesSection(),
                      const SizedBox(height: 28),
                      _buildFriendVotesSection(),
                      const SizedBox(height: 60),
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
              'View Friend Votes',
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
          onTap: () => print('View All Friend Votes'),
          child: const Text(
            'View All >',
            style: TextStyle(
              color: Color(0xFF2B7FFF),
              fontSize: 13,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF9D00FF),
      unselectedItemColor: Colors.grey.shade700,
      selectedLabelStyle: const TextStyle(fontSize: 13),
      unselectedLabelStyle: const TextStyle(fontSize: 13),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.grid_on), label: 'Randomize'),
      ],
    );
  }
}