import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/location_screen.dart';
import 'screens/home_screen.dart';

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  late Future<Widget> _initialScreen;

  @override
  void initState() {
    super.initState();
    _initialScreen = _determineInitialScreen();
  }

  // figures out which screen to show when app starts
  Future<Widget> _determineInitialScreen() async {
    final prefs = await SharedPreferences.getInstance();
    
    // check if user is logged in
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    
    // check if location was already granted
    bool locationGranted = prefs.getBool('locationGranted') ?? false;
    
    // check if user has seen the info popup
    bool infoPopupSeen = prefs.getBool('infoPopupSeen') ?? false;
    
    // get stored location coordinates
    double? latitude = prefs.containsKey('userLatitude') 
        ? double.tryParse(prefs.getString('userLatitude') ?? '') 
        : null;
    double? longitude = prefs.containsKey('userLongitude') 
        ? double.tryParse(prefs.getString('userLongitude') ?? '') 
        : null;

    print('isLoggedIn: $isLoggedIn');
    print('locationGranted: $locationGranted');
    print('infoPopupSeen: $infoPopupSeen');

    // logic for determining which screen
    // 1. if NOT logged in → show login screen
    if (!isLoggedIn) {
      return const LoginScreen();
    }
    
    // 2. if logged in but NO location → show location screen
    if (!locationGranted) {
      return const LocationScreen(showPopupOnHomeScreen: true);
    }
    
    // 3. if logged in AND location granted → show home screen
    // (popup will show automatically on first visit)
    if (latitude != null && longitude != null) {
      return HomeScreen(
        latitude: latitude,
        longitude: longitude,
        showInfoPopup: !infoPopupSeen,
      );
    }
    
    // fallback to login if something went wrong
    return const LoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _initialScreen,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // loading screen while figuring out which screen to show
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF2D1B4E),
                    const Color(0xFF1A0A2E),
                    const Color(0xFF0F0020),
                  ],
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFF9D00FF),
                  ),
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        return MaterialApp(
          home: snapshot.data ?? const LoginScreen(),
          theme: ThemeData.dark(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}


// helper class for managing user data storage
class AuthManager {
  // saves login info when user signs up or logs in
  static Future<void> saveLoginData({
    required String username,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('username', username);
    await prefs.setString('email', email);
  }

  // saves location coordinates when user allows access
  static Future<void> saveLocationData({
    required double latitude,
    required double longitude,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('locationGranted', true);
    await prefs.setString('userLatitude', latitude.toString());
    await prefs.setString('userLongitude', longitude.toString());
  }

  // marks info popup as seen so it won't show again
  static Future<void> markInfoPopupSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('infoPopupSeen', true);
  }

  // clears all user data when logging out
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.setBool('locationGranted', false);
    await prefs.remove('username');
    await prefs.remove('email');
    await prefs.remove('userLatitude');
    await prefs.remove('userLongitude');
  }

  // gets the saved username
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }
}