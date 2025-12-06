import 'package:http/http.dart' as http;
import 'dart:convert';

// Global variable untuk URL API (Gunakan localhost karena running di Chrome/Web)
const String apiUrl = "http://localhost/minumyuk";

// --- SERVICE OTENTIKASI (LOGIN/REGISTER) ---

class AuthService {
  static Future<Map<String, dynamic>> register(
    String username,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$apiUrl/register.php'),
      body: {'username': username, 'password': password},
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> login(
    String username,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$apiUrl/login.php'),
      body: {'username': username, 'password': password},
    );
    return jsonDecode(response.body);
  }
}

// --- SERVICE WATER TRACKER ---

class WaterService {
  static Future<Map<String, dynamic>> getData(int userId) async {
    final response = await http.post(
      Uri.parse('$apiUrl/api.php'),
      body: {'action': 'get_data', 'user_id': userId.toString()},
    );
    return jsonDecode(response.body);
  }

  static Future<void> addWater(int userId) async {
    await http.post(
      Uri.parse('$apiUrl/api.php'),
      body: {'action': 'add_water', 'user_id': userId.toString()},
    );
  }

  static Future<void> resetWater(int userId) async {
    await http.post(
      Uri.parse('$apiUrl/api.php'),
      body: {'action': 'reset', 'user_id': userId.toString()},
    );
  }
}
