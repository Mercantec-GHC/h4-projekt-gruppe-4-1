//import 'dart:math';
//import 'package:date_utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:harmonyevent_app/Pages/Event/EventPage.dart';
import 'package:harmonyevent_app/config/api_config.dart';
import 'package:harmonyevent_app/models/event.dart';
import 'package:harmonyevent_app/Pages/User/LoginPage.dart';
// import 'package:http_parser/http_parser.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';
import 'package:flutter_gradient_button/flutter_gradient_button.dart';

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

      events.sort((a, b) => a.date.compareTo(b.date));
     
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
// Logout function
  // Future<void> logout() async {
  //   await _secureStorage.delete(key: 'token'); // Remove the stored token

  //   // Navigate to the login page after logging out
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => LoginPage()), // Fixed missing closing
  //   );
  // }

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
              MaterialPageRoute(builder: (context) => CreateEvent()), // Replace with the correct page
              );
            }
          ),
          IconButton(
            icon: const Icon(
              Icons.auto_awesome, 
              color: const Color.fromARGB(255, 183, 211, 54)
              ),
            tooltip: "My Events",
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
      body: Container(
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
    
    var screenSize = MediaQuery.of(context).size;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: events.length,
      physics: PageScrollPhysics(),
      itemBuilder: (context, date) {
        final event = events[date];
        events.sort((a, b) => a.date.compareTo(b.date));

        return Container(
          //width: MediaQuery.of(context).size.width,
          width: screenSize.width,
          height: screenSize.height,
          //width: 500,

          margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 0),
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          // decoration: BoxDecoration(
          //   border: Border.all(
          //     color: const Color.fromARGB(255, 29, 41, 4), 
          //     width: 4,
          //   ),
          //   borderRadius: BorderRadius.circular(8.0),
          // ),
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
              //       Expanded(
              //   flex: 1,
              //   child: Image.network(
              //     event.ImageURL, // Display event image from the URL
              //     fit: BoxFit.cover, // Ensure the image fits properly
              //     errorBuilder: (context, error, stackTrace) {
              //       return const Icon(Icons.broken_image, size: 100); // Handle broken images
              //     },
              //   ),
              // ),
                    Text(
                      event.description,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 162, 235, 14),
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
                    const SizedBox(height: 10),
                    Text(
                      //"Date:" + " " + DateUtils.dateOnly(event.date).toString(),
                      "Occurs:" + " " + event.date.day.toString() + "/" + event.date.month.toString() + " " + event.date.year.toString() + " " + "at 11 am",
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

                    const SizedBox(height: 25),
                    Text(
                      "Decription:" + " " + event.description,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 234, 208, 225),
                      ),
                    ),
                      const SizedBox(height: 25),
                    Text(
                      "Organized by:",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 234, 208, 225),
                      ),
                    ),
                    const SizedBox(height: 45),

                    //Text('Place_id: ${event.place_id}'),
                    //Text('date: ${event.date}'),
                    //Text('type: ${event.type}'),
                    //Text('category: ${event.category}'),
                    //Text('description: ${event.description}'),
                    Column(
                      children: [
                                                Align(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                            //alignment: Alignment.bottomRight,
                            icon: const Icon(
                              Icons.favorite_border, 
                              color: const Color.fromARGB(255, 183, 211, 54),
                              
                              size: 30,
                            ),  
                            tooltip: "Add to favorite events",
                            onPressed: () {
                              setState((){
             
 
                              });                    
                            }
                          ),
                        ), 
                        const SizedBox(height: 25),
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
                        //const SizedBox(width: 100),
     
                      ],
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