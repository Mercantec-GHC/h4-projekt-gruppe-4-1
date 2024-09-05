//import 'dart:math';
//import 'package:date_utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:harmonyevent_app/config/api_config.dart';
import 'package:harmonyevent_app/models/event.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';

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
       for (var events in events) {
        print(events);
      }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_circle_outline, 
              color: const Color.fromARGB(255, 183, 211, 54)
            ),
            tooltip: "Create Event",
            onPressed: () {
              print("Hmm");
            }
          ),
          IconButton(
            icon: const Icon(
              Icons.favorite, 
              color: const Color.fromARGB(255, 183, 211, 54)
              ),
            tooltip: "Favorite Events",
            onPressed: () {
              print("Hmm");
            }
          ),
          IconButton(
            icon: const Icon(
              Icons.search, 
              color: const Color.fromARGB(255, 183, 211, 54)
              ),
            tooltip: "Search Events",
            onPressed: () {
              print("Hmm");
            }
          ),
          IconButton(
            icon: const Icon(
              Icons.account_circle, 
              color: const Color.fromARGB(255, 183, 211, 54)
            ),
            tooltip: "Your account",
            onPressed: () {
              print("Hmm");
            }
          ),
        ],
        title: Row(
          children: [
            Container(
              child: Image(image: AssetImage('assets/images/HE_Logo.png'),
                width: 50,
                fit: BoxFit.cover     
              ),  
            ),        
            Container(          
              child: 
                Text("Harmony Event"),
            ), 
          ],
        ),
      ),
      body: Center(
        child: FutureBuilder<List<EventDTO>>(
          future: eventsFuture,
          builder: (context, snapshot) {
            print('snapshot: $snapshot');
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Loading indicator while fetching data
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // Display error message if the Future failed
              return const Text("Failed to load events.");
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              // If data is available, build the event list
              final events = snapshot.data!;
              print('Test: $events');
              return buildEvents(events);
            } else {
              // Display message if no data is available
              return const Text("No events available.");
            }
          },
        ),
      ),
    );
  }

  // Build the event list UI
  Widget buildEvents(List<EventDTO> events) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Container(
          //color: const Color.fromARGB(255, 36, 51, 6),
          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
          //height: 200,
          width: double.maxFinite,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(255, 29, 41, 4), 
              width: 4,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              // Expanded(
              //   flex: 1,
              //   child: Image.network(
              //     event.ImageURL,
              //     fit: BoxFit.cover, // Ensure the image fits properly
              //   ),
              // ),
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
                        color: const Color.fromARGB(255, 162, 235, 14),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      //"Date:" + " " + DateUtils.dateOnly(event.date).toString(),
                      "Date:" + " " + DateUtils.dateOnly(event.date).toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 234, 208, 225),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Category:" + " " + event.category,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 234, 208, 225),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Type:" + " " + event.type,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 234, 208, 225),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      "Decription:" + " " + event.description,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 234, 208, 225),
                      ),
                    ),
                    const SizedBox(height: 5),

                    //Text('Place_id: ${event.place_id}'),
                    //Text('date: ${event.date}'),
                    //Text('type: ${event.type}'),
                    //Text('category: ${event.category}'),
                    //Text('description: ${event.description}'), 
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