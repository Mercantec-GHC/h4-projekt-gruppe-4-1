import 'package:flutter/material.dart';
import 'package:flutter_first_app/config/api_config.dart';
import 'package:flutter_first_app/models/event.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SeeAllEvents extends StatefulWidget {
  const SeeAllEvents({super.key});

  @override
  State<SeeAllEvents> createState() => _SeeAllEventsState();
}

class _SeeAllEventsState extends State<SeeAllEvents> {
  late Future<List<EventDTO>> eventsFuture;

  @override
  void initState() {
    super.initState();
    eventsFuture = fetchEvents(); // Fetch events in initState
  }

  // Fetch events from API
  Future<List<EventDTO>> fetchEvents() async {
    final String baseUrl = ApiConfig.apiUrl;
    final url = Uri.parse('$baseUrl/api/Event');

    try {
      final response = await http.get(url, headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        final List body = json.decode(response.body);
        final events = body.map((e) => EventDTO.fromJson(e)).toList();
        return events;
      } else {
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("See All Events"),
      ),
      body: Center(
        child: FutureBuilder<List<EventDTO>>(
          future: eventsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text("Failed to load events.");
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final events = snapshot.data!;
              return buildEvents(events);
            } else {
              return const Text("No events available.");
            }
          },
        ),
      ),
    );
  }

  // Build the event list UI with image display
  Widget buildEvents(List<EventDTO> events) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Container(
          color: Colors.grey.shade300,
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          height: 200,
          width: double.maxFinite,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Image.network(
                  event.ImageURL, // Display event image from the URL
                  fit: BoxFit.cover, // Ensure the image fits properly
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, size: 100); // Handle broken images
                  },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.description,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text('Place_id: ${event.place_id}'),
                    Text('Date: ${event.date}'),
                    Text('Type: ${event.type}'),
                    Text('Category: ${event.category}'),
                    Text('Description: ${event.description}'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
