import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_first_app/models/event.dart';
import 'package:flutter_first_app/config/api_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EventService {
  final String _baseUrl = ApiConfig.apiUrl;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Method to create an event with image upload
  Future<CreateEventDTO> createEvent(
     String placeId,
     String date,
     String isprivate,
     String category,
     String title,
     String description,
    File? eventPicture,
  ) async {
    var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/api/event/create'));

    final token = await _storage.read(key: 'jwt');
    if (token == null) {
      throw Exception('Authentication token not found. Please log in.');
    }
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['place_id'] = placeId;
    request.fields['date'] = date;
    request.fields['isprivate'] = isprivate;
    request.fields['category'] = category;
    request.fields['title'] = title;
    request.fields['description'] = description;

    if (eventPicture != null) {
      var imageStream = http.ByteStream(eventPicture.openRead());
      var imageLength = await eventPicture.length();
      request.files.add(
        http.MultipartFile(
          'EventPicture',
          imageStream,
          imageLength,
          filename: eventPicture.path.split('/').last,
        ),
      );
    }

    try {
      var response = await request.send();
      if (response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        return CreateEventDTO.fromJson(jsonDecode(responseBody));
      } else {
        final errorResponse = await response.stream.bytesToString();
        throw Exception('Failed to create event: ${response.statusCode} - $errorResponse');
      }
    } catch (e) {
      throw Exception('Error occurred while creating event: $e');
    }
  }         

  Future<void> attendEvent(String eventId) async {
    final String? token = await _storage.read(key: 'jwt');
    final url = Uri.parse('$_baseUrl/api/Event/$eventId/Attend');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to attend event: ${response.statusCode}');
    }
  }

  
}