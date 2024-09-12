import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_first_app/config/api_config.dart';
import 'package:flutter_first_app/models/user.dart';
import 'package:flutter_first_app/Http/User/loginuser.dart'; 

Future<UserDTO> fetchUserDTO() async {
  final storage = FlutterSecureStorage(); 
  final String? token = await storage.read(key: 'jwt'); 

  
  if (token == null) {
    throw Exception('Token is missing. Please login again.');
  }

  
  final authService = AuthService();
  if (authService.isTokenExpired(token)) {
    throw Exception('Token expired. Please login again.');
  }

 
  final url = Uri.parse('${ApiConfig.apiUrl}/api/User');
  
  
  final response = await http.get(
    url,
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    },
  );

  
  if (response.statusCode == 200) {
    final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

    
    print("Response Body: $responseBody");

    
    if (!responseBody.containsKey('id') || !responseBody.containsKey('username')) {
      throw Exception('Missing required fields in the response');
    }

    // Return the user data as a UserDTO object
    return UserDTO.fromJson(responseBody);
  } else {
    // Throw an exception if the request failed with any other status code
    throw Exception('Failed to load user data. Status code: ${response.statusCode}');
  }
}

