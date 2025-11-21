import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import '../widgets/home/home_header.dart';
import '../widgets/home/category_section.dart';
import '../widgets/home/action_buttons.dart';
import '../widgets/home/favorites_section.dart';
import '../widgets/home/friend_vote_card.dart';
import '../widgets/home/home_bottom_nav.dart';
import '../widgets/home/info_popup.dart';
import '../widgets/share_dialog.dart';
import '../app_navigator.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'randomizer_screen.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';

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
      // Toggle: if clicking same category, deselect it
      if (_selectedCategory == category) {
        _selectedCategory = '';
      } else {
        _selectedCategory = category;
      }
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

  void _navigateToSearch() {
    Navigator.of(context).push(
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

  void _navigateToFavorites() {
    Navigator.of(context).push(
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

  void _showShareDialog() {
    showDialog(
      context: context,
      builder: (context) => ShareDialog(
        placeName: 'My Recommendations',
        category: _selectedCategory.isEmpty ? 'All' : _selectedCategory,
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
        onSearchTap: _navigateToSearch,
        onFavoritesTap: _navigateToFavorites,
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
                      SearchButton(onTap: _navigateToSearch),
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
                        onViewAll: _navigateToFavorites,
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
                      const FriendVotesSection(),
                      const SizedBox(height: 16),
                      // Share Button
                      GestureDetector(
                        onTap: _showShareDialog,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xFF155DFC), Color(0xFF0092B8)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2B7FFF).withOpacity(0.6),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                                spreadRadius: 2,
                              ),
                              BoxShadow(
                                color: const Color(0xFF2B7FFF).withOpacity(0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.share_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Share with Friends',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
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