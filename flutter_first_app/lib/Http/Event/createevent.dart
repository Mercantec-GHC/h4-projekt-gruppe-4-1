import 'dart:io';
import 'dart:convert';
import 'package:flutter_first_app/models/event.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_first_app/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventService {
  final String _baseUrl = ApiConfig.apiUrl;

  // Method to create event with image upload (Multipart request)
  Future<EventDTO> createEventWithImage(String placeId, String date, bool isprivate, String category, String description, File? image) async {
    var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/api/event/create'));

    // Get the JWT token from shared preferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // Add authorization header
    request.headers['Authorization'] = 'Bearer $token';

    // Add the form fields
    request.fields['place_id'] = placeId;
    request.fields['date'] = date;
    request.fields['isprivate'] = isprivate as String;
    request.fields['category'] = category;
    request.fields['description'] = description;

    // Attach the image file if it's available
    if (image != null) {
      var imageStream = http.ByteStream(image.openRead());
      var imageLength = await image.length();
      request.files.add(
        http.MultipartFile(
          'image',
          imageStream,
          imageLength,
          filename: image.path.split('/').last,
        ),
      );
    }

    var response = await request.send();

    if (response.statusCode == 201) {
      final responseBody = await response.stream.bytesToString();
      return EventDTO.fromJson(jsonDecode(responseBody));
    } else {
      throw Exception('Failed to create event with image: ${response.statusCode}');
    }
  }

  // Method to create event without image (Regular POST request with JSON)
  Future<void> createEvent(EventDTO eventDTO) async {
    final url = Uri.parse('$_baseUrl/api/event/create');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(eventDTO.toJson()),
      );

      if (response.statusCode == 200) {
        
        print('Event created successfully');
      } else {
        print('Failed to create event with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to create event: ${response.statusCode} - ${response.body}');
      }
    } catch (error) {
      
      print('Error occurred: $error');
    }
  }
}