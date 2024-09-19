
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_gradient_button/flutter_gradient_button.dart';

import 'package:harmonyevent_app/config/auth_workaround.dart';
import 'package:harmonyevent_app/components/custom_mainappbar.dart';
import 'package:harmonyevent_app/models/event_model.dart';
import 'package:harmonyevent_app/services/fetch_service.dart';
import 'package:harmonyevent_app/services/login_service.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}
class _EventPageState extends State<EventPage> {
  late Future<List<EventDTO>> eventsFuture;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage(); // Secure storage instance
  final AuthService authService = AuthService();
  //Inits fetchEvents from fetchevents_service.dart
  @override
  void initState() {
    super.initState();
    eventsFuture = fetchEvents(); // Fetch events in initState
  }
  
  @override
  Widget build(BuildContext context) {   
    return Scaffold(

      //GETs CUSTOM MAIN APPBAR FROM /components/custom_mainappbar.dart
      appBar: CustomMainAppBar(),
  
      body: Center(
        child: FutureBuilder<List<EventDTO>>(
          future: eventsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Loading indicator while fetching data
              return const CircularProgressIndicator();
            } 
            else if (snapshot.hasError) {
              // Display error message if the Future failed
              return const Text("Failed to load events.");
            } 
            else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              // If data is available, build the event list
              final events = snapshot.data!;
              print(events);
              return buildEvents(events);
            } 
            else {
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
        print(event);
        print(event.eventPicture);
        final eventPictureUrl = event.eventPicture;
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
                          child: eventPictureUrl.isNotEmpty 
                           ? Image.network(
                            eventPictureUrl, 
                            fit: BoxFit.cover, 
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image, size: 300); // Handle broken images
                            },
                          )
                          : const Icon(Icons.broken_image, size: 100),
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
                                        //EVENT CATEGORY
                    Text(
                      "Category: ${event.category}",
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
                    //EVENT TITLE
                    Text(
                      "${event.title}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 183, 211, 83),
                      ),
                    ),
                    const SizedBox(height: 10),

                    //EVENT DESCRIPTION
                    Padding(
                      padding: const EdgeInsets.only(left: 48.0, right: 48.0),
                      child: Text(
                        "Decription: ${event.description}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 234, 208, 225),
                        ),
                      ),
                    ),
   

                    
                    const SizedBox(height: 70),
                    //ORGANIZED BY
                    Container(
                      child: Column(
                        children: [
                          Text(
                            "Organized by: ${event.eventCreator_id}",
                            style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 183, 211, 83),
                            ),
                          ),
                          
                          Container(
                            width: 40,
                            child: CircleAvatar(
                              backgroundColor: const Color.fromARGB(255, 183, 211, 83),
                              radius: 40,
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: ClipOval (
                                  child: Image.network(
                                    "https://eventharmoni.mercantec.tech/eventharmoni/PPc0c029f2f1fc462eadaf7178f6c6dd74.png",                             
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
                    
                    //ATTEND EVENT BUTTON
                    GradientButton(
                      colors: [const Color.fromARGB(255, 183, 211, 54), const Color.fromARGB(255, 109, 190, 66)],
                      height: 40,
                      width: 350,
                      radius: 20,
                      gradientDirection: GradientDirection.leftToRight,
                      textStyle: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
                      text: "Attend Event",
                      onPressed: () {
                        print("In development - comming later");
                      },
                    ),
                    const SizedBox(height: 20),
                     Padding(
                      padding: EdgeInsets.only(left: 50, right: 50),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text("Add to Favorites",
                                  style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 234, 208, 225),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.favorite_outline_sharp, 
                                    color: const Color.fromARGB(255, 183, 211, 54),
                                    size: 25,
                                  ),
                                  tooltip: "View Participants",
                                  onPressed: (){
                                  }
                                ),
                              ],
                            ),         
                            //const SizedBox(width: 30), 
                            Column(
                              children: [
                                Text("View Participants",
                                  style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 234, 208, 225),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.groups_3_sharp, 
                                    color: const Color.fromARGB(255, 183, 211, 54),
                                    size: 30,
                                  ),
                                  tooltip: "View Participants",
                                  onPressed: (){
                                  }
                                ),
                              ],
                            ),
                            //const SizedBox(width: 30),
                            Column(
                              children: [
                                Text("Notify friend",
                                  style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 234, 208, 225),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.mail_outline_sharp, 
                                    color: const Color.fromARGB(255, 183, 211, 54),
                                    size: 25,
                                  ),
                                  tooltip: "Notify friend",
                                  onPressed: (){
                                  }
                                ),
                              ],
                            ),                                                  
                          ],
                        ),
                      ),
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

