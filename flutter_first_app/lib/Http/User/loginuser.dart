import 'dart:convert';
import 'package:flutter_first_app/config/api_config.dart';
import 'package:flutter_first_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class AuthService {
  final String baseUrl = ApiConfig.apiUrl; 
  final FlutterSecureStorage storage = FlutterSecureStorage(); 

  Future<Map<String, String>> login(LoginDTO loginDTO) async {
    final url = Uri.parse('$baseUrl/api/User/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(loginDTO.toJson()),
    );

    // Log the response status code and body for debugging
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final token = responseData['token'];
      final userId = responseData['id'];

      // Log the response data for debugging
      print('Response data: $responseData');

      if (token == null) {
        throw Exception('Token is null');
      }
      if (userId == null) {
        throw Exception('UserId is null');
      }

      return {'token': token, 'userId': userId};
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'jwt');
  }

  bool isTokenExpired(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return true;

    final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    final payloadMap = json.decode(payload);

    final expiry = payloadMap['exp'] as int?;
    final now = DateTime.now().millisecondsSinceEpoch / 1000;

    return expiry == null || expiry < now;
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && !isTokenExpired(token);
  }
}
