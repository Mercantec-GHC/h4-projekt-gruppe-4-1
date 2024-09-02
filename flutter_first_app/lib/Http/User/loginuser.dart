import 'package:flutter/foundation.dart';
import 'package:flutter_first_app/models/user.dart';
import 'package:flutter_first_app/config/api_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class AuthService {
  final String baseUrl = ApiConfig.apiUrl;
  final storage = FlutterSecureStorage();

  Future<void> login(LoginDTO LoginDTO) async {
    final url = Uri.parse('$baseUrl/api/User/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode( LoginDTO.toJson()),
    );

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['token'];
      await storage.write(key: 'jwt', value: token);

      if (kDebugMode) {
        print('JWT Token: $token');
      }
    } else {
    // Print response body and status code for debugging
    print('Login failed with status: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Login failed: ${response.statusCode} - ${response.body}');
  }
}


  Future<LoginDTO> createUser(
      String firstname,
      String lastname,
      String email,
      String username,
      String password,
      String address,
      String postal,
      String city) async {
    final url = Uri.parse('$baseUrl/api/user/signup');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'username': username,
        'password': password,
        'address': address,
        'postal': postal,
        'city': city,
      }),
    );

    if (response.statusCode == 201) {
      return LoginDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user: ${response.statusCode} - ${response.body}');
    }
  }
}