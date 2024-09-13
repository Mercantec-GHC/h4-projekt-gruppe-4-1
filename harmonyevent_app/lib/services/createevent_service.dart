
import 'dart:io';
//import 'dart:convert';
import 'package:http/http.dart' as http;
//import 'package:http_parser/http_parser.dart'; 
import 'package:harmonyevent_app/config/api_config.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//import 'package:harmonyevent_app/models/event_model.dart';

class CreateEventService {
  // Initialize secure storage
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  // Method to create event with image upload
  Future<void> createEvent (
    String date,  
    String user_id, 
    String place_id, 
    String category, 
    String description, 
    String title, 
    bool isPrivate,
    File? image
  ) 
  async {
    final String _baseUrl = ApiConfig.apiUrl;
    var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/api/event/create'));;

    // Add the form fields
    request.fields['date'] = date;
    request.fields['place_id'] = user_id;
    request.fields['place_id'] = place_id;
    request.fields['category'] = category;
    request.fields['description'] = description;
    request.fields['title'] = title;
    request.fields['isPrivate'] = isPrivate as String;

    if (image != null) {
    request.files.add(
      http.MultipartFile.fromBytes(
        'profilePicture',
        await image.readAsBytes(),
        filename: image.path.split('/').last,
        ),
      );
    }
      //DET ER HER DET MANGLER - SE CREATEUSERSERVICE!!!!!
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