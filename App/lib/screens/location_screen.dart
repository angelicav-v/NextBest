import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../widgets/gradient_background.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool _isLoadingLocation = false;

  Future<void> _handleAllowLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showErrorDialog(
          'Location Services Disabled',
          'Please enable location services in your device settings',
        );
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      // Request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      // Handle permission response
      if (permission == LocationPermission.denied) {
        _showErrorDialog(
          'Permission Denied',
          'Location permission is required to use this feature',
        );
      } else if (permission == LocationPermission.deniedForever) {
        _showErrorDialog(
          'Permission Denied',
          'Please enable location access in app settings',
        );
        await Geolocator.openLocationSettings();
      } else {
        // Permission granted, get the user's current position
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        print('Location obtained:');
        print('Latitude: ${position.latitude}');
        print('Longitude: ${position.longitude}');

        // Show success message
        _showSuccessDialog(
          'Location Access Granted',
          'Your location has been obtained and saved',
        );
      }
    } catch (e) {
      _showErrorDialog('Error', 'Failed to get location: $e');
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
        );
      },
    );
  }

  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                    // Logo
                    Container(
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
                    ),
                    const SizedBox(height: 40),
                    // Welcome text
                    const Text(
                      'Welcome to Statesboro!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFD4AFFF),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Subtitle
                    Text(
                      'Discover the best experiences\nStatesboro, Georgia has to offer',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey.shade500,
                        letterSpacing: 0.3,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Airplane Icon Circle
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF9D00FF),
                            Color(0xFFB300FF),
                          ],
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
                    ),
                    const SizedBox(height: 48),
                    // Feature list
                    Column(
                      children: [
                        _buildFeatureItem(
                          icon: Icons.location_on_outlined,
                          text: 'Find amazing places in Statesboro',
                        ),
                        const SizedBox(height: 20),
                        _buildFeatureItem(
                          icon: Icons.location_on_outlined,
                          text: 'Get personalized\nlocal\nrecommendations',
                        ),
                        const SizedBox(height: 20),
                        _buildFeatureItem(
                          icon: Icons.location_on_outlined,
                          text: 'Discover trending spots around town',
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    // Allow Location Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
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
                    ),
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

  Widget _buildFeatureItem({required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Color(0xFFB366FF),
          size: 20,
        ),
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
}
