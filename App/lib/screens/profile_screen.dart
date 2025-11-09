import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import 'package:nextbest/models/friend_model.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/profile_avatar_section.dart';
import '../widgets/profile/profile_info_section.dart';
import '../widgets/profile/profile_friends_section.dart';
import '../widgets/profile/profile_add_contacts_button.dart';
import '../app_navigator.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _username = '';
  late final String _fullUsername;
  bool _isLoading = true;
  final List<Friend> _friends = [
    Friend(id: '1', name: 'Sarah', addedDate: DateTime.now()),
    Friend(id: '2', name: 'Mike', addedDate: DateTime.now()),
    Friend(id: '3', name: 'Jessica', addedDate: DateTime.now()),
  ];

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    try {
      final fullUsername = await AuthManager.getUsername();
      _fullUsername = fullUsername ?? 'User';
      setState(() {
        _username = fullUsername?.isNotEmpty == true
            ? fullUsername![0].toUpperCase()
            : 'U';
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading username: $e');
      _fullUsername = 'User';
      setState(() {
        _username = 'U';
        _isLoading = false;
      });
    }
  }

  void _showAddFriendDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text(
            'Add Friend',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Your friend link has been copied to clipboard.',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade900,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'nextbest.app/friend/$_username',
                        style: const TextStyle(
                          color: Color(0xFFE12AFB),
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.copy,
                        color: Color(0xFFE12AFB),
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Close',
                style: TextStyle(color: Color(0xFFE12AFB)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddFromContactsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text(
            'Add from Contacts',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Would you like to access your contacts?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'No',
                style: TextStyle(color: Color(0xFFE12AFB)),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Yes',
                style: TextStyle(color: Color(0xFFE12AFB)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPhotoUploadOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Upload Profile Photo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPhotoOption(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onTap: () {
                      Navigator.pop(context);
                      print('Gallery selected');
                    },
                  ),
                  _buildPhotoOption(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onTap: () {
                      Navigator.pop(context);
                      print('Camera selected');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPhotoOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [Color(0xFF9D00FF), Color(0xFFB300FF)],
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _showRemoveFriendDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text(
            'Remove Friend',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to remove ${_friends[index].name}?',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFFB366FF)),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _friends.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: const Text(
                'Remove',
                style: TextStyle(
                  color: Color(0xFFE12AFB),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: GradientBackground(
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white.withOpacity(0.5),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              ProfileHeader(onBackTap: () => Navigator.pop(context)),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        ProfileAvatarSection(
                          username: _username,
                          onUploadTap: _showPhotoUploadOptions,
                        ),
                        const SizedBox(height: 24),
                        ProfileInfoSection(username: _fullUsername),
                        const SizedBox(height: 24),
                        ProfileFriendsSection(
                          friends: _friends,
                          onAddFriendTap: _showAddFriendDialog,
                          onRemoveFriendTap: _showRemoveFriendDialog,
                        ),
                        const SizedBox(height: 24),
                        ProfileAddContactsButton(
                          onTap: _showAddFromContactsDialog,
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
    );
  }
}