import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import 'login_screen.dart';
import 'location_screen.dart';
import '../app_navigator.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Text field controllers
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true; // toggles password visibility

  @override
  void dispose() {
    // dispose controllers when done to free up memory
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleCreateAccount() {
    // check if all fields are filled out correctly
    if (_usernameController.text.isEmpty) {
      _showError('Username Required', 'Please choose a username');
      return;
    }
    if (_emailController.text.isEmpty) {
      _showError('Email Required', 'Please enter your email');
      return;
    }
    if (!_isValidEmail(_emailController.text)) {
      _showError('Invalid Email', 'Please enter a valid email address');
      return;
    }
    if (_phoneController.text.isEmpty) {
      _showError('Phone Required', 'Please enter your phone number');
      return;
    }
    if (_passwordController.text.isEmpty) {
      _showError('Password Required', 'Please create a password');
      return;
    }
    if (_passwordController.text.length < 6) {
      _showError('Weak Password', 'Password must be at least 6 characters');
      return;
    }

    // everything looks good, save data and move to next screen
    _saveAndNavigate();
    
  }

  Future<void> _saveAndNavigate() async {
    // save username and email using AuthManager helper class
    await AuthManager.saveLoginData(
      username: _usernameController.text,
      email: _emailController.text,
    );

    await AuthManager.saveUsername(_usernameController.text);
    await AuthManager.saveEmail(_emailController.text);
    await AuthManager.savePhone(_phoneController.text);

    // go to location screen with slide animation from right
    if (mounted) {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LocationScreen(showPopupOnHomeScreen: true),
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
  }

  // takes user back to login screen
  void _handleSignIn() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  // shows popup error message
  void _showError(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        backgroundColor: const Color(0xFF1A1A1A),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: const TextStyle(color: Colors.white70, fontSize: 14),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'OK',
              style: TextStyle(
                color: Color(0xFFB366FF),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // checks if email format is valid using regex
  bool _isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 60),

                  _buildLogo(),
                  const SizedBox(height: 40),

                  _buildTitle(),
                  const SizedBox(height: 12),

                  _buildSubtitle(),
                  const SizedBox(height: 50),

                  // all the input fields
                  _buildInputField(
                    'Username',
                    _usernameController,
                    'Choose a username',
                  ),
                  const SizedBox(height: 24),
                  _buildInputField(
                    'Email',
                    _emailController,
                    'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 24),
                  _buildInputField(
                    'Phone Number',
                    _phoneController,
                    '+1 (912) 555-0123',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 24),
                  _buildPasswordField(),
                  const SizedBox(height: 32),

                  _buildCreateAccountButton(),
                  const SizedBox(height: 24),

                  _buildSignInLink(),
                  const SizedBox(height: 40),

                  _buildCopyright(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // builds the logo with purple glow effect
  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFA855F7).withValues(alpha: 0.75),
            blurRadius: 50,
            spreadRadius: 8,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFD946EF), width: 0.75),
          ),
          child: Center(
            child: Image.asset(
              'assets/images/nextbest_logo.png',
              width: 75,
              height: 75,
            ),
          ),
        ),
      ),
    );
  }

  // creates "Create Account" title with gradient color
  Widget _buildTitle() {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFFC27AFF), Color(0xFFED6AFF)],
      ).createShader(bounds),
      child: const Text(
        'Create Account',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // subtitle text below title
  Widget _buildSubtitle() {
    return Text(
      'Join NextBest today',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w300,
        color: const Color(0xFFDAB2FF).withValues(alpha: 0.6),
        letterSpacing: 0.3,
      ),
    );
  }

  // reusable widget for text input fields (username, email, phone)
  Widget _buildInputField(
    String label,
    TextEditingController controller,
    String hint, {
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: const Color(0xFFDAB2FF).withValues(alpha: 0.3),
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
            filled: true,
            fillColor: const Color(0xFF000000).withValues(alpha: 0.4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: const Color(0xFFAD46FF).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: const Color(0xFFAD46FF).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: const Color(0xFFAD46FF).withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  // password field with show/hide toggle button
  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
          decoration: InputDecoration(
            hintText: 'Create a password',
            hintStyle: TextStyle(
              color: const Color(0xFFDAB2FF).withValues(alpha: 0.3),
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
            filled: true,
            fillColor: const Color(0xFF000000).withValues(alpha: 0.4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: const Color(0xFFAD46FF).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: const Color(0xFFAD46FF).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: const Color(0xFFAD46FF).withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: GestureDetector(
                onTap: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                child: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey.shade700,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // purple gradient button for creating account
  Widget _buildCreateAccountButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(
            colors: [Color(0xFF9810FA), Color(0xFFC800DE)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9810FA).withValues(alpha: 0.5),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _handleCreateAccount,
            borderRadius: BorderRadius.circular(8),
            child: const Center(
              child: Text(
                'Create Account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // "already have an account? sign in" link at bottom
  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account?',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.2,
          ),
        ),
        TextButton(
          onPressed: _handleSignIn,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Sign in',
            style: TextStyle(
              color: Color(0xFFB366FF),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
  }

  // copyright text at the very bottom
  Widget _buildCopyright() {
    return Text(
      'Â© 2025 NextBest. All rights reserved.',
      style: TextStyle(
        color: Colors.grey.shade700,
        fontSize: 11,
        fontWeight: FontWeight.w300,
        letterSpacing: 0.1,
      ),
    );
  }
}