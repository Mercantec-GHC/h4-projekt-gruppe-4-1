import 'dart:io';
import 'dart:convert';
import 'package:flutter_first_app/models/event.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_first_app/config/api_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EventService {
  final String _baseUrl = ApiConfig.apiUrl;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

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
    request.headers['Authorization']; 'Bearer $token';

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

Future<bool> attendEvent(String eventId) async {
    String? token = await _storage.read(key: 'jwt');
    final response = await http.post(
      Uri.parse('${ApiConfig.apiUrl}/api/event/$eventId/attend'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return true; // Successfully attended the event
    } else if (response.statusCode == 409) {
      return false; // Already attending the event
    } else {
      final errorResponse = response.body;
      throw Exception('Failed to attend event: ${response.statusCode} - $errorResponse');
    }
  }
}