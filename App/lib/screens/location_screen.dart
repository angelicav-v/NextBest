import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  void _handleAllowLocation() {
    // Handle location permission logic here
    print('Location access allowed');
  }

  void _handleNotNow() {
    // Handle skip location logic here
    print('Location access declined');
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
                        fontSize: 15,
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
                            onTap: _handleAllowLocation,
                            borderRadius: BorderRadius.circular(8),
                            child: const Center(
                              child: Text(
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
              fontSize: 16,
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
