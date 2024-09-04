
import 'package:flutter_first_app/config/api_config.dart';
import 'package:flutter_first_app/models/event.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<EventDTO>> getEvents() async {
  final String baseUrl = ApiConfig.apiUrl;
  final url = Uri.parse('$baseUrl/api/Event/Create');

  try {
    final response = await http.get(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      final List body = json.decode(response.body);
      return body.map((e) => EventDTO.fromJson(e)).toList();
    } else {
      // Handle non-200 responses
      throw Exception('Failed to load events: ${response.statusCode}');
    }
  } catch (e) {
    // Handle any errors that occur during the request
    print('Error fetching events: $e');
    return []; // Return an empty list or handle the error as needed
  }
}

Future<List<EventDTO>> eventsFuture = getEvents();

