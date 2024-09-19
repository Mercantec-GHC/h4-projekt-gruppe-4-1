
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:harmonyevent_app/config/api_config.dart';
import 'package:harmonyevent_app/config/auth_workaround.dart';
import 'package:harmonyevent_app/models/event_model.dart';

class CreateEventService {
  
  // Initialize secure storage
  final FlutterSecureStorage storage = FlutterSecureStorage();

  final String _baseUrl = ApiConfig.apiUrl;
  // Method to create event with image upload
  Future<CreateEventDTO> createEvent(
    File? eventPicture,
    String date,
    String placeId,
    String category,
    String title,
    String description,
    String isPrivate,
  ) 
  async {
    var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/api/event/event/create'));

    //Retrieve the token securely
    //final String? token = await storage.read(key: 'jwt');
    final String? token = mytoken;
    print(token);
    if (token == null) {
      throw Exception('Authentication token not found. Please log in');
    }
    //request.headers['Authorization'] = 'Bearer: $token';
    request.headers['Authorization'] = 'Bearer $token';
    print(request.headers);
    print(request);

    // Add event picture if provided
    if (eventPicture != null) {
      var imageStream = http.ByteStream(eventPicture.openRead());
      var imageLength = await eventPicture.length();
      request.files.add(
        http.MultipartFile(
          'eventPicture',  // Updated key based on your DTO
          imageStream,
          imageLength,
          filename: eventPicture.path.split('/').last,
        ),
      );
    }
    request.fields['date'] = date;
    request.fields['place_id'] = placeId;
    request.fields['title'] = title;
    request.fields['category'] = category;
    request.fields['description'] = description;
    request.fields['isprivate'] = isPrivate;

    try {
      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.statusCode);
        final responseBody = await response.stream.bytesToString();
        return CreateEventDTO.fromJson(jsonDecode(responseBody));
      } else {
        final errorResponse = await response.stream.bytesToString();
        throw Exception('Failed to create event: ${response.statusCode} - $errorResponse');
      }
    } 
    catch (e) {
      throw Exception('Error occurred while creating event: $e');
    }
  }
}