
import 'dart:io';
//import 'dart:convert';
import 'package:http/http.dart' as http;
//import 'package:http_parser/http_parser.dart'; 
import 'package:harmonyevent_app/config/api_config.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:harmonyevent_app/models/user_model.dart';

class CreateUserService {
// Initialize secure storage
final FlutterSecureStorage secureStorage = FlutterSecureStorage();

Future<void> createUser(
  String firstName,
  String lastName,
  String email,
  String username,
  String password,
  String address,
  String postal,
  String city,
  File? image
) async {
  final String baseUrl = ApiConfig.apiUrl;
  final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/api/User/SignUp'));

  // Add all fields to the request
  request.fields['firstname'] = firstName;
  request.fields['lastname'] = lastName;
  request.fields['email'] = email;
  request.fields['username'] = username;
  request.fields['password'] = password;
  request.fields['address'] = address;
  request.fields['postal'] = postal;
  request.fields['city'] = city;

  if (image != null) {
    request.files.add(
      http.MultipartFile.fromBytes(
        'profilePicture',
        await image.readAsBytes(),
        filename: image.path.split('/').last,
      ),
    );
  }

  // Retrieve the token securely
  final String? token = await secureStorage.read(key: 'token');
  if (token != null) {
    request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
  }

  try {
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      print("User created successfully: $responseBody");
    } else {
      final responseBody = await response.stream.bytesToString();
      throw Exception('Failed to create user. Status code: ${response.statusCode}, Response: $responseBody');
    }
  } catch (e) {
    print("Error: $e");
    throw Exception('Failed to create user: $e');
  }
}
}