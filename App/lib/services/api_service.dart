import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Android emulator uses 10.0.2.2 to reach localhost
  static const String baseUrl = "http://10.0.2.2:5000";

  // Example function to call backend
  static Future<Map<String, dynamic>> spin(String category) async {
    final response = await http.get(Uri.parse('$baseUrl/spin?category=$category'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);  // <-- now this works
    } else {
      throw Exception('Failed to get spin result');
    }
  }
}

