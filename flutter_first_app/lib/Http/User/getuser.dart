import 'dart:convert';
import 'dart:io';
import 'package:flutter_first_app/models/user.dart';  
import 'package:http/http.dart' as http;
import 'package:flutter_first_app/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<UserDTO> fetchuserDTO() async {
  final String baseUrl = ApiConfig.apiUrl;

  
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');

  
  if (token == null) {
    throw Exception('Token is missing. Please login again.');
  }

  
  final response = await http.get(
    Uri.parse('$baseUrl/api/User'),
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',  
    },
  );

  
  if (response.statusCode == 200) {
    
    return UserDTO.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    
    throw Exception('Failed to load user data. Status code: ${response.statusCode}');
  }
}

