import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:harmonyevent_app/models/login_model.dart';
import 'package:harmonyevent_app/config/api_config.dart';

class AuthService {
  final String baseUrl = ApiConfig.apiUrl; 
  final storage = FlutterSecureStorage(); 

  Future<String> login(LoginDTO loginDTO) async {
    final url = Uri.parse('$baseUrl/api/User/login'); 
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(loginDTO.toJson()),
    );

    // print('Status Code: ${response.statusCode}');
    // print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      print('Response JSON: $responseBody');
      final token = responseBody['token'];
    if (token == null) {
      throw Exception('Token missing in the response');
    }
    if (isTokenExpired(token)) {
      throw Exception('Token expired');
    }
    await storage.write(key: 'jwt', value: token);

    if (kDebugMode) {
      print('JWT Token: $token');
    }
    return token;
    }
    else if (response.statusCode == 400) {
      throw Exception('Invalid credentials');
    } 
    else if (response.statusCode == 500) {
      throw Exception('Server error, please try again later');
    } 
    else {
      throw Exception('Login failed');
    }
  }
  // Fetch the stored JWT token from secure storage
  Future<String?> getToken() async {
    return await storage.read(key: 'jwt'); // Read the token from secure storage
  }
  // Check if the user is logged in by verifying if the token exists and is valid
  Future<bool> isLoggedIn() async {
    final token = await storage.read(key: 'jwt');
    return token != null && !isTokenExpired(token); // Check if token exists and is not expired
  }
  // Logout method to clear the stored JWT token
  Future<void> logout() async {
    await storage.delete(key: 'jwt'); // Delete the stored token from secure storage
  }
  // Method to check if a JWT token is expired
  bool isTokenExpired(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return true; // If token structure is invalid
    
    // Decode the JWT payload (the second part of the token)
    final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    final payloadMap = json.decode(payload);

    // Extract the expiry time from the payload
    final expiry = payloadMap['exp'];
    final now = DateTime.now().millisecondsSinceEpoch / 1000;

    return expiry < now; // Return true if the token has expired
  }
}


 