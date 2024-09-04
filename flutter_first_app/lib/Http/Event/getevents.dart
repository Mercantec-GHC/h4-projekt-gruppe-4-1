import 'package:flutter_first_app/config/api_config.dart';
import 'package:flutter_first_app/models/event.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<EventDTO>> fetchEvents() async {
  final String baseUrl = ApiConfig.apiUrl;
  final url = Uri.parse('$baseUrl/api/Event/Create');

  try {
    final response = await http.get(url, headers: {"Content-Type": "application/json"});

    // Print the status code
    print('Response Status Code: ${response.statusCode}');

    if (response.statusCode == 200) {
      // Print the raw response body
      print('Response Body: ${response.body}');

      final List body = json.decode(response.body);

      // Print the parsed body
      print('Parsed Body: $body');

      // Print each event DTO before returning
      final events = body.map((e) => EventDTO.fromJson(e)).toList();
      print('Events: $events');

      return events;
    } else {
      // Handle non-200 responses
      print('Failed to load events: ${response.statusCode}');
      throw Exception('Failed to load events: ${response.statusCode}');
    }
  } catch (e) {
    // Handle any errors that occur during the request
    print('Error fetching events: $e');
    return []; // Return an empty list or handle the error as needed
  }
}

Future<List<EventDTO>> eventsFuture = fetchEvents();
