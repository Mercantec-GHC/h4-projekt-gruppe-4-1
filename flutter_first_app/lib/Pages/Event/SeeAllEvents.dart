import 'package:flutter/material.dart';
import 'package:flutter_first_app/models/event.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_first_app/config/api_config.dart';
import 'dart:core';

class SeeAllEvents extends StatefulWidget {
  const SeeAllEvents({super.key});

  @override
  State<SeeAllEvents> createState() => _SeeAllEventsState();
}

// homepage state
class _SeeAllEventsState extends State<SeeAllEvents> {
  // variable to call and store future list of EventDTOs
  Future<List<EventDTO>> EventDTOsFuture = getEventDTOs();

  // function to fetch data from API and return future list of EventDTOs
  static Future<List<EventDTO>> getEventDTOs() async {
    final String baseUrl = ApiConfig.apiUrl;
    final url = Uri.parse('$baseUrl/api/Event');

    try {
      final response = await http.get(url, headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        final List body = json.decode(response.body);
        return body.map((e) => EventDTO.fromJson(e)).toList();
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
      body: Center(
        // FutureBuilder
        child: FutureBuilder<List<EventDTO>>(
          future: EventDTOsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final EventDTOs = snapshot.data!;
              return buildEventDTOs(EventDTOs);
            } else {
              return const Text("No data available");
            }
          },
        ),
      ),
    );
  }

  Widget buildEventDTOs(List<EventDTO> EventDTOs) {
    // ListView Builder to show data in a list
    return ListView.builder(
      itemCount: EventDTOs.length,
      itemBuilder: (context, index) {
        final EventDTO = EventDTOs[index];

        // Provide default values if the fields are null
        final imageUrl = EventDTO.ImageURL ?? 'https://via.placeholder.com/150';
        final description = EventDTO.description ?? 'No description available';
        final category = EventDTO.category ?? 'No category';
        final date = EventDTO.date?.toLocal().toString() ?? 'Date not available';

        return Container(
          color: Colors.grey.shade300,
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          height: 100,
          width: double.maxFinite,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Image.network(imageUrl),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: Text(description),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Text(category),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Text(date),
              ),
            ],
          ),
        );
      },
    );
  }
}