import 'dart:convert';
import 'package:harmonyevent_app/config/auth_workaround.dart';
import 'package:http/http.dart' as http;
import 'package:harmonyevent_app/config/api_config.dart';
import 'package:harmonyevent_app/models/event_model.dart';
import 'package:harmonyevent_app/models/user_model.dart';

  // Fetch events from API
  Future<List<EventDTO>> fetchEvents() async {
    const String baseUrl = ApiConfig.apiUrl;
    final url = Uri.parse('$baseUrl/api/Event');
    try {
      // Get JWT token from secure storage
      //String? token = await _secureStorage.read(key: 'token');
      String? token = mytoken;
      if (token == null) {
        throw Exception("Authentication token not found");
      }
    final response = await http.get(url, headers: {"Content-Type": "application/json"});
    print('Response Status Code: ${response.statusCode}');
    if (response.statusCode == 200) {
      //print('Response Body: ${response.body}');
      final List body = json.decode(response.body);
      // Print each event DTO before returning
      final events = body.map((e) => EventDTO.fromJson(e)).toList();
      return events;
    } else {
      // Handle non-200 responses
      print('Failed to load events: ${response.statusCode}');
      throw Exception('Failed to load events: ${response.statusCode}');
    }
  } 
  catch (e) {
    // Handle any errors that occur during the request
    print('Error fetching events: $e');
    return []; // Return an empty list or handle the error as needed
    }
  }

  // Fetch users from API
  Future<List<UserDTO>> fetchUsers() async {
    const String baseUrl = ApiConfig.apiUrl;
    final url = Uri.parse('$baseUrl/api/user');
    try {
      // Get JWT token from secure storage
      //String? token = await _secureStorage.read(key: 'token');
      String? token = mytoken;
      if (token == null) {
        throw Exception("Authentication token not found");
      }
    final response = await http.get(url, headers: {"Content-Type": "application/json"});
    print('Response Status Code: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('Response Body: ${response.body}');
      final List body = json.decode(response.body);
      // Print each event DTO before returning
      final users = body.map((e) => UserDTO.fromJson(e)).toList();
      return users;
    } else {
      // Handle non-200 responses
      print('Failed to load users: ${response.statusCode}');
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  } catch (e) {
    // Handle any errors that occur during the request
    print('Error fetching users: $e');
    return []; // Return an empty list or handle the error as needed
  }
}