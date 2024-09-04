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


class _SeeAllEventsState extends State<SeeAllEvents> {

  
  Future<List<EventDTO>> eventsFuture = getEvents();

  
  static Future<List<EventDTO>> getEvents() async {
    var url = Uri.parse("https://jsonplaceholder.typicode.com/albums/1/photos");
    final response = await http.get(url, headers: {"Content-Type": "application/json"});
    final List body = json.decode(response.body);
    
    
    return body.map((e) => EventDTO.fromJson({
      'date': DateTime.now().toIso8601String(),  
      'place_id': e['id'].toString(),
      'ImageURL': e['url'],
      'type': 'Unknown',  
      'category': 'Unknown',  
      'description': e['title']
    })).toList();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // FutureBuilder
        child: FutureBuilder<List<EventDTO>>(
          future: eventsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              
              final events = snapshot.data!;
              return buildEvents(events);
            } else {
              // if no data, show simple Text
              return const Text("No data available");
            }
          },
        ),
      ),
    );
  }

  
  Widget buildEvents(List<EventDTO> events) {
    
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Container(
          color: Colors.grey.shade300,
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          height: 100,
          width: double.maxFinite,
          child: Row(
            children: [
              Expanded(flex: 1, child: Image.network(event.ImageURL)),
              SizedBox(width: 10),
              Expanded(flex: 3, child: Text(event.description)),
            ],
          ),
        );
      },
    );
  }
}