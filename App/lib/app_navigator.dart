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
    
    // get stored location coordinates - now using getDouble instead of parsing strings
    double? latitude = prefs.containsKey('userLatitude') 
        ? prefs.getDouble('userLatitude')
        : null;
    double? longitude = prefs.containsKey('userLongitude') 
        ? prefs.getDouble('userLongitude')
        : null;

    print('isLoggedIn: $isLoggedIn');
    print('locationGranted: $locationGranted');
    print('infoPopupSeen: $infoPopupSeen');
    print('latitude: $latitude, longitude: $longitude');

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
    
    // fallback to location screen if coordinates are missing
    return const LocationScreen(showPopupOnHomeScreen: true);
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
  
  static Future<void> saveEmail(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      print('Email saved: $email');
    } catch (e) {
      print('Error saving email: $e');
      rethrow;
    }
  }

  static Future<String?> getEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('email');
    } catch (e) {
      print('Error getting email: $e');
      return null;
    }
  }

  static Future<void> saveUsername(String username) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
      print('Username saved: $username');
    } catch (e) {
      print('Error saving username: $e');
      rethrow;
    }
  }

  static Future<void> savePhone(String phone) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('phone', phone);
      print('Phone saved: $phone');
    } catch (e) {
      print('Error saving phone: $e');
      rethrow;
    }
  }

  static Future<String?> getPhone() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('phone');
    } catch (e) {
      print('Error getting phone: $e');
      return null;
    }
  }

  // saves login info when user signs up or logs in
  static Future<void> saveLoginData({
    required String username,
    required String email,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('username', username);
      await prefs.setString('email', email);
      print('Login data saved - Username: $username, Email: $email');
    } catch (e) {
      print('Error saving login data: $e');
      rethrow;
    }
  }

  // saves location coordinates when user allows access
  // FIXED: Now uses setDouble instead of setString for type safety
  static Future<void> saveLocationData({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('locationGranted', true);
      // Use setDouble for better performance and type safety
      await prefs.setDouble('userLatitude', latitude);
      await prefs.setDouble('userLongitude', longitude);
      print('Location data saved successfully - Lat: $latitude, Long: $longitude');
    } catch (e) {
      print('Error saving location data: $e');
      rethrow;
    }
  }

  // marks info popup as seen so it won't show again
  static Future<void> markInfoPopupSeen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('infoPopupSeen', true);
      print('Info popup marked as seen');
    } catch (e) {
      print('Error marking info popup as seen: $e');
      rethrow;
    }
  }

  // clears all user data when logging out
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      await prefs.setBool('locationGranted', false);
      await prefs.remove('username');
      await prefs.remove('email');
      await prefs.remove('phone');
      await prefs.remove('userLatitude');
      await prefs.remove('userLongitude');
      print('User logged out and all data cleared');
    } catch (e) {
      print('Error during logout: $e');
      rethrow;
    }
  }

  // gets the saved username
  static Future<String?> getUsername() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('username');
    } catch (e) {
      print('Error getting username: $e');
      return null;
    }
  }
}