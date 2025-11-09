import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import '../app_navigator.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _email = '';
  String _phone = '';
  String _editedEmail = '';
  String _editedPhone = '';
  bool _pushNotifications = true;
  bool _isLoading = true;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final email = await AuthManager.getEmail();
      final phone = await AuthManager.getPhone();
      setState(() {
        _email = email ?? 'user@example.com';
        _phone = phone ?? '+1 (912) 555-0123';
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
      _editedEmail = _email;
      _editedPhone = _phone;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
    });
  }

  void _saveChanges() {
    setState(() {
      _email = _editedEmail;
      _phone = _editedPhone;
      _isEditing = false;
    });
    // Save email and phone to AuthManager
    AuthManager.saveEmail(_editedEmail);
    AuthManager.savePhone(_editedPhone);
    print('Changes saved: Email: $_email, Phone: $_phone');
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text(
            'Change Password',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Password change functionality coming soon.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'OK',
                style: TextStyle(color: Color(0xFFB366FF)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLogOutConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text(
            'Log Out',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(color: Colors.white70),
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
              onPressed: () async {
                // Clear all user data
                await AuthManager.logout();
                
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                }
              },
              child: const Text(
                'Log Out',
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

  void _showDeleteAccountConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFF1A1A1A),
              border: Border.all(
                color: const Color(0xFFFF6B6B).withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF000000).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Delete Account',
                  style: TextStyle(
                    color: Color(0xFFFF6B6B),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'This action cannot be undone. This will permanently delete your account and remove all your data from our servers.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () async {
                        // Clear all user data
                        await AuthManager.logout();
                        
                        if (mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xFFFF3B30),
                        ),
                        child: const Text(
                          'Delete Account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        _buildAccountInformationSection(),
                        const SizedBox(height: 20),
                        _buildSecuritySection(),
                        const SizedBox(height: 20),
                        _buildNotificationsSection(),
                        const SizedBox(height: 20),
                        _buildDangerZoneSection(),
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        children: [
          Row(
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
                        Color(0xFFFB64B6),
                        Color(0xFFC27AFF),
                        Color(0xFFED6AFF),
                      ],
                    ).createShader(bounds),
                    child: const Text(
                      'Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 1.5,
            color: const Color(0xFFE12AFB),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInformationSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFAD46FF).withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Account Information',
                style: TextStyle(
                  color: Color(0xFFE9D4FF),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (!_isEditing)
                GestureDetector(
                  onTap: _startEditing,
                  child: const Icon(
                    Icons.edit_outlined,
                    color: Color(0xFFE12AFB),
                    size: 28,
                  ),
                )
              else
                Row(
                  children: [
                    GestureDetector(
                      onTap: _cancelEditing,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade800,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _saveChanges,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFFE12AFB), Color(0xFFD946EF)],
                          ),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isEditing)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildEditableField(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: _editedEmail,
                  onChanged: (value) {
                    setState(() {
                      _editedEmail = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildEditableField(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: _editedPhone,
                  onChanged: (value) {
                    setState(() {
                      _editedPhone = value;
                    });
                  },
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoItem(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: _email,
                ),
                const SizedBox(height: 16),
                _buildInfoItem(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: _phone,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFDAB2FF),
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(icon, color: Color(0xFFB366FF), size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEditableField({
    required IconData icon,
    required String label,
    required String value,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFDAB2FF),
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: value),
          onChanged: onChanged,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintStyle: TextStyle(
              color: const Color(0xFFDAB2FF).withOpacity(0.3),
              fontSize: 14,
            ),
            filled: true,
            fillColor: Colors.black.withOpacity(0.3),
            prefixIcon: Icon(icon, color: Color(0xFFB366FF), size: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: const Color(0xFFAD46FF).withOpacity(0.3),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: const Color(0xFFAD46FF).withOpacity(0.3),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: const Color(0xFFE12AFB).withOpacity(0.5),
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecuritySection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFAD46FF).withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Security',
            style: TextStyle(
              color: Color(0xFFE9D4FF),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _showChangePasswordDialog,
            child: Row(
              children: [
                const Icon(
                  Icons.lock_outlined,
                  color: Color(0xFFB366FF),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Change Password',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Update your password',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFFAD46FF),
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFAD46FF).withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notifications',
            style: TextStyle(
              color: Color(0xFFE9D4FF),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.notifications_outlined,
                color: Color(0xFFB366FF),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Push Notifications',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Get notified about updates',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: _pushNotifications,
                  onChanged: (value) {
                    setState(() {
                      _pushNotifications = value;
                    });
                  },
                  activeColor: const Color(0xFFE12AFB),
                  inactiveThumbColor: Colors.grey.shade700,
                  inactiveTrackColor: Colors.grey.shade800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDangerZoneSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFF6B6B).withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Danger Zone',
            style: TextStyle(
              color: Color(0xFFFF6B6B),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _showLogOutConfirmation,
            child: Row(
              children: [
                const Icon(
                  Icons.logout_outlined,
                  color: Color(0xFFFF6B6B),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Log Out',
                        style: TextStyle(
                          color: Color(0xFFFF6B6B),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Sign out of your account',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFFFF6B6B),
                  size: 16,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _showDeleteAccountConfirmation,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Color(0xFFFF6B6B).withOpacity(0.5),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.delete_outline,
                    color: Color(0xFFFF6B6B),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Delete Account',
                    style: TextStyle(
                      color: Color(0xFFFF6B6B),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}