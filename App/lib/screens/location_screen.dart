import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../widgets/gradient_background.dart';
import 'home_screen.dart';
import '../app_navigator.dart';
import 'dart:async';

class LocationScreen extends StatefulWidget {
  final bool showPopupOnHomeScreen;

  const LocationScreen({
    super.key,
    this.showPopupOnHomeScreen = false,
  });

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool _isLoadingLocation = false;

  Future<void> _handleAllowLocation() async {
    // Prevent multiple taps
    if (_isLoadingLocation) return;

    setState(() {
      _isLoadingLocation = true;
    });

    try {
      print('Starting location permission process...');

      // Step 1: Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      print('Location services enabled: $serviceEnabled');

      if (!serviceEnabled) {
        if (mounted) {
          _showErrorDialog(
            'Location Services Disabled',
            'Please enable location services in your device settings',
          );
        }
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      // Step 2: Check current permission
      LocationPermission permission = await Geolocator.checkPermission();
      print('Current permission: $permission');

      // Step 3: Request permission if needed
      if (permission == LocationPermission.denied) {
        print('Requesting location permission...');
        permission = await Geolocator.requestPermission();
        print('Permission after request: $permission');
      }

      // Step 4: Handle permission result
      if (permission == LocationPermission.denied) {
        if (mounted) {
          _showErrorDialog(
            'Permission Denied',
            'Location permission is required to use this feature',
          );
        }
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          _showErrorDialog(
            'Permission Denied',
            'Location permission has been permanently denied. Please enable it in app settings.',
          );
        }
        // Open app settings
        await Geolocator.openAppSettings();
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      // Step 5: Permission granted - get location with timeout
      print('Permission granted, fetching location...');
      
      try {
        // Add a timeout to prevent infinite waiting
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 15),
        ).timeout(
          const Duration(seconds: 20),
          onTimeout: () {
            throw Exception('Location fetch timed out. Please try again.');
          },
        );

        print('Location obtained successfully:');
        print('Latitude: ${position.latitude}');
        print('Longitude: ${position.longitude}');

        // Save location data
        await AuthManager.saveLocationData(
          latitude: position.latitude,
          longitude: position.longitude,
        );

        if (mounted) {
          _showSuccessDialog(
            'Location Access Granted',
            'Your location has been obtained and saved',
            position,
          );
        }
      } on TimeoutException catch (_) {
        if (mounted) {
          _showErrorDialog(
            'Location Timeout',
            'Could not retrieve location. Please check your GPS and try again.',
          );
        }
        setState(() {
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      print('Error during location process: $e');
      if (mounted) {
        _showErrorDialog(
          'Error',
          'Failed to get location: $e',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          backgroundColor: const Color(0xFF1A1A1A),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFFB366FF),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(String title, String message, Position position) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          backgroundColor: const Color(0xFF1A1A1A),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                
                // Navigate to home screen after dialog closes
                if (mounted) {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          HomeScreen(
                        latitude: position.latitude,
                        longitude: position.longitude,
                        showInfoPopup: widget.showPopupOnHomeScreen,
                      ),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.ease,
                            ),
                          ),
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 500),
                    ),
                  );
                }
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFFB366FF),
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
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    
                    // logo
                    _buildLogo(),
                    const SizedBox(height: 40),
                    
                    // welcome text
                    const Text(
                      'Welcome to NextBest!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFD4AFFF),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // description
                    Text(
                      'Discover the best experiences\nyour area has to offer',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey.shade500,
                        letterSpacing: 0.3,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 48),
                    
                    // paper plane icon
                    _buildIconCircle(),
                    const SizedBox(height: 48),
                    
                    // features list
                    _buildFeaturesList(),
                    const SizedBox(height: 48),
                    
                    // location button
                    _buildLocationButton(),
                    const SizedBox(height: 16),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B3DFF).withOpacity(0.4),
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
            border: Border.all(
              color: const Color(0xFFD946EF),
              width: 0.75,
            ),
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

  Widget _buildIconCircle() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF9D00FF), Color(0xFFB300FF)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9D00FF).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.send_rounded,
          color: Colors.white,
          size: 50,
        ),
      ),
    );
  }

  Widget _buildFeaturesList() {
    return Column(
      children: [
        _buildFeatureItem(
          icon: Icons.location_on_outlined,
          text: 'Find amazing places near you',
        ),
        const SizedBox(height: 20),
        _buildFeatureItem(
          icon: Icons.location_on_outlined,
          text: 'Get personalized local recommendations',
        ),
        const SizedBox(height: 20),
        _buildFeatureItem(
          icon: Icons.location_on_outlined,
          text: 'Discover trending spots around town',
        ),
      ],
    );
  }

  Widget _buildFeatureItem({required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: const Color(0xFFB366FF), size: 20),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: Colors.white,
              letterSpacing: 0.2,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(
            colors: [Color(0xFF9D00FF), Color(0xFFB300FF)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9D00FF).withOpacity(0.5),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _isLoadingLocation ? null : _handleAllowLocation,
            borderRadius: BorderRadius.circular(8),
            child: Center(
              child: _isLoadingLocation
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Allow Location Access',
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
}