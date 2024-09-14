import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:harmonyevent_app/config/api_config.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gradient_button/flutter_gradient_button.dart';

import 'package:harmonyevent_app/models/event_model.dart';
import 'package:harmonyevent_app/pages/CreateEventPage.dart';
import 'package:harmonyevent_app/pages/UserProfilePage.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late Future<List<EventDTO>> eventsFuture;

  @override
  void initState() {
    super.initState();
    eventsFuture = fetchEvents(); // Fetch events in initState
  }

  // Fetch events from API
  Future<List<EventDTO>> fetchEvents() async {
    const String baseUrl = ApiConfig.apiUrl;
    final url = Uri.parse('$baseUrl/api/Event');

    try {
    final response = await http.get(url, headers: {"Content-Type": "application/json"});
    print('Response Status Code: ${response.statusCode}');
    if (response.statusCode == 200) {
      //print('Response Body: ${response.body}');
      final List body = json.decode(response.body);
      // Print each event DTO before returning
      final events = body.map((e) => EventDTO.fromJson(e)).toList();
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
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CreateEventPage()), // Replace with the correct page
              );
            }
          ),
          IconButton(
            icon: const Icon(
              Icons.auto_awesome, 
              color: Color.fromARGB(255, 183, 211, 54)
              ),
            tooltip: "My Events",
            onPressed: () {
              print("Hmm");
            }
          ),
          IconButton(
            icon: const Icon(
              Icons.favorite, 
              color: Color.fromARGB(255, 183, 211, 54)
              ),
            tooltip: "Favorite Events",
            onPressed: () {
              print("Hmm");
            }
          ),
          IconButton(
            icon: const Icon(
              Icons.search, 
              color: Color.fromARGB(255, 183, 211, 54)
              ),
            tooltip: "Search Events",
            onPressed: () {
              print("Hmm");
            }
          ),
          IconButton(
            icon: const Icon(
              Icons.account_circle, 
              color: Color.fromARGB(255, 183, 211, 54)
            ),
            tooltip: "Your account",
            onPressed: () {
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => UserProfilePage()), // Replace with the correct page
              );
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
              Text(
                "Harmony Event",
                style: TextStyle(
                  color: const Color.fromARGB(255, 234, 208, 225),
                  fontWeight: FontWeight.bold,
                ),
              ),  
            ), 
          ],
        ),
      ),
      body: Center(
        child: FutureBuilder<List<EventDTO>>(
          future: eventsFuture,
          builder: (context, snapshot) {
            //print('snapshot: $snapshot');
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Loading indicator while fetching data
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // Display error message if the Future failed
              return const Text("Failed to load events.");
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              // If data is available, build the event list
              final events = snapshot.data!;
              //print('Test: $events');
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
    var screenSize = MediaQuery.of(context).size;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: events.length,
      physics: PageScrollPhysics(),
      itemBuilder: (context, index) {
        final event = events[index];

        events.sort((a, b) => a.date.compareTo(b.date));

        return Container(
          width: screenSize.width,
          height: screenSize.height,
          margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 0),
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    //EVENT ID
                    Text(
                      "Event ID: ${event.id}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 234, 208, 225),
                      ),
                    ),
                    
                    //EVENT IMAGE
                    Container(
                      width: 500,
                      height: 281,
                      padding: EdgeInsets.all(2), // Border width
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 89, 99, 44), 
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox.fromSize(
                          size: Size.fromRadius(48), // Image radius
                          child: Image.network(
                            event.eventPicture, 
                            fit: BoxFit.cover, 
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image, size: 300); // Handle broken images
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                   
                    //EVENT DATE AND TIME
                    Text(
                      "Occurs: ${event.date}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 234, 208, 225),
                      ),
                    ),

                    //EVENT LOCATION
                    Text(
                      "Location: ${event.place_id}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 234, 208, 225),
                      ),
                    ),

                    //EVENT TITLE
                    Text(
                      "Title: ${event.title}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 183, 211, 83),
                      ),
                    ),

                    //EVENT CATEGORY
                    Text(
                      "Category: ${event.category}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 234, 208, 225),
                      ),
                    ),

                    //EVENT DESCRIPTION
                    Text(
                      "Decription: ${event.description}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 234, 208, 225),
                      ),
                    ),

                    //EVENTTYPE (PRIVATE/PUBLIC)
                    Text(
                      "Type: ${event.isprivate}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 234, 208, 225),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    //ORGANIZED BY
                    Container(
                      //width: 150,
                      child: Column(
                        children: [
                          Text(
                            "Organized by: ${event.title}",
                            style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 183, 211, 83),
                            ),
                          ),
                          Container(
                            width: 50,
                            child: CircleAvatar(
                              backgroundColor: const Color.fromARGB(255, 183, 211, 83),
                              radius: 40,
                              child: Padding(
             
                                padding: const EdgeInsets.all(3),
                                child: ClipOval (
                                  child: Image.network(
                                    event.eventPicture,                             
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.broken_image, size: 300); // Handle broken images
                                    },
                                  ), 
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //CREATE EVENT BUTTOM
                    GradientButton(
                      colors: [const Color.fromARGB(255, 183, 211, 54), const Color.fromARGB(255, 109, 190, 66)],
                      height: 40,
                      width: 350,
                      radius: 20,
                      gradientDirection: GradientDirection.leftToRight,
                      textStyle: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
                      text: "Attend Event",
                      onPressed: () {
                        print("Hmm");
                      },
                    ),
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