
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
 
import 'package:harmonyevent_app/config/api_config.dart';

/*VIRKER IKKE PÅ MACOS - UNDERSØGER LØSNINGSMULIGHEDER:
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';*/

import 'package:harmonyevent_app/models/event_model.dart';

class CreateEventService {
  
  // Initialize secure storage
  /*VIRKER IKKE PÅ MACOS - UNDERSØGER LØSNINGSMULIGHEDER:
  //final FlutterSecureStorage storage = FlutterSecureStorage();*/

  final String _baseUrl = ApiConfig.apiUrl;
  // Method to create event with image upload
  Future<CreateEventDTO> createEvent(
    File? EventPicture,
    String date,
    String location,
    String title,
    String category,
    String description,
    String isprivate,
  ) 
  async {
    var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/api/event/create'));

    /*VIRKER IKKE PÅ MACOS - UNDERSØGER LØSNINGSMULIGHEDER:
    // Retrieve the token securely
    // final String? token = await storage.read(key: 'jwt');
    // print(token);
    // if (token == null) {
    //   throw Exception('Authentication token not found. Please log in');
    // }
    // request.headers['Authorization'] = 'Bearer $token';*/

    if (EventPicture != null) {
      var imageStream = http.ByteStream(EventPicture.openRead());
      var imageLength = await EventPicture.length();
      request.files.add(
        http.MultipartFile(
          'EventPicture',
          imageStream,
          imageLength,
          filename: EventPicture.path.split('/').last,
        ),
      );
    }
    request.fields['date'] = date;
    request.fields['place_id'] = location;
    request.fields['title'] = title;
    request.fields['category'] = category;
    request.fields['description'] = description;
    request.fields['isprivate'] = isprivate;

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
}