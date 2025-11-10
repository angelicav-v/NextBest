import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import '../widgets/home/home_header.dart';
import '../widgets/home/category_section.dart';
import '../widgets/home/action_buttons.dart';
import '../widgets/home/favorites_section.dart';
import '../widgets/home/friend_vote_card.dart';
import '../widgets/home/home_bottom_nav.dart';
import '../widgets/home/info_popup.dart';
import '../app_navigator.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'randomizer_screen.dart';

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
  String _selectedCategory = '';

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

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _navigateToProfile() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const ProfileScreen(),
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

  void _navigateToSettings() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SettingsScreen(),
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

  void _navigateToRandomizer() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            RandomizerScreen(
              selectedCategory: _selectedCategory,
              autoSpin: _selectedCategory.isNotEmpty,
              latitude: widget.latitude,
              longitude: widget.longitude,
            ),
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
              onProfileTap: _navigateToProfile,
              onInfoTap: _showInfoPopupAgain,
              onSettingsTap: _navigateToSettings,
            ),

            // scrollable content
            _buildScrollableContent(),

            // info popup overlay
            if (_showInfoPopup) InfoPopup(onDismiss: _dismissInfoPopup),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNav(
        onRandomizeTap: _navigateToRandomizer,
      ),
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
                      SizedBox(
                        width: double.infinity,
                        child: Divider(
                          color: const Color(0xFFAD46FF),
                          height: 1,
                          thickness: 1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CategorySection(
                        selectedCategory: _selectedCategory,
                        onCategorySelected: _onCategorySelected,
                      ),
                      const SizedBox(height: 24),
                      SpinButton(
                        onTap: _selectedCategory.isNotEmpty
                            ? _navigateToRandomizer
                            : () {},
                      ),
                      const SizedBox(height: 14),
                      SearchButton(onTap: () => print('Search tapped')),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: Divider(
                          color: const Color(0xFFAD46FF),
                          height: 1,
                          thickness: 1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FavoritesSection(
                        onViewAll: () => print('View All Favorites'),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: Divider(
                          color: const Color(0xFFAD46FF),
                          height: 1,
                          thickness: 1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FriendVotesSection(
                        onViewAll: () => print('View All Friend Votes'),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: Divider(
                          color: const Color(0xFFAD46FF),
                          height: 1,
                          thickness: 1,
                        ),
                      ),
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
}