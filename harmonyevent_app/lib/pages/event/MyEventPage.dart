import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:harmonyevent_app/config/auth_workaround.dart';
import 'package:harmonyevent_app/services/login_service.dart';
import 'package:harmonyevent_app/pages/event/UpdateEventPage.dart';
import 'package:harmonyevent_app/pages/event/DeleteEventPage.dart';
import 'package:harmonyevent_app/config/api_config.dart';
import 'package:harmonyevent_app/components/custom_mainappbar.dart';

class MyEventsPage extends StatefulWidget {
  @override
  _MyEventsPageState createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final AuthService _authService = AuthService();
  List<dynamic> _userEvents = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserEvents(); // Fetch user events on page load
  }

  // Method to fetch the user's events from the API
  Future<void> _fetchUserEvents() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      //final String? userId = await _secureStorage.read(key: 'userId');
      final String? userId = myid;
      // Get JWT token from secure storage
      //String? token = await _secureStorage.read(key: 'token');
      String? token = mytoken;

      print('User ID retrieved: $userId');
      print('Token retrieved: $token');

      if (userId == null || token == null) {
        print('User ID or token is null');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User not logged in or token expired')));
      Navigator.pop(context); // Navigate back if user is not logged in or token is expired
      return;
      }

      if (_authService.isTokenExpired(token)) {
      print('Token is expired');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User not logged in or token expired')));
      Navigator.pop(context); // Navigate back if user is not logged in or token is expired
      return;
    }

      // Make the GET request to fetch the user's events
      final url = Uri.parse('${ApiConfig.apiUrl}/api/Event');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _userEvents = data; // Store the fetched events
        });
      } else {
        throw Exception('Failed to load events');
      }
    } 
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } 
    finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  // Method to navigate to the UpdateEventPage
  void _navigateToUpdateEvent(String eventId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateEventPage(eventId: eventId),
      ),
    ).then((_) {
      _fetchUserEvents(); // Refresh events after updating
    });
  }

  // Method to navigate to the DeleteEventPage
  void _navigateToDeleteEvent(String eventId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeleteEventPage(eventId: eventId),
      ),
    ).then((_) {
      _fetchUserEvents(); // Refresh events after deletion
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //GETs CUSTOM MAIN APPBAR FROM /components/custom_mainappbar.dart
      appBar: CustomMainAppBar(),
      body: _isLoading
      ? Center(child: CircularProgressIndicator()) // Show loading indicator
      : _userEvents.isEmpty
      ? Center(child: Text('You have no current events'))
      : ListView.builder(
        itemCount: _userEvents.length,
        itemBuilder: (context, index) {
          final event = _userEvents[index];           
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(    
              color: const Color.fromARGB(255, 36, 51, 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(
                  color: const Color.fromARGB(255, 89, 99, 44),
                  width: 2.0,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child:  Container(
                      width: 100,
                      height: 56,
                      padding: EdgeInsets.all(2), // Border width
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox.fromSize(
                          size: Size.fromRadius(48), // Image radius
                          child: Image.network(
                            "https://eventharmoni.mercantec.tech/eventharmoni/PPc0c029f2f1fc462eadaf7178f6c6dd74.png", 
                            //ser.eventPicture,
                            fit: BoxFit.cover, 
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image, size: 300); // Handle broken images
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          "Date: ${event['date']}",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 234, 208, 225),
                          ),
                        ),
                        Text(
                          "Title: ${event['description']}",
                          style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 234, 208, 225),
                          ),
                        ),
                        Text(
                          "Category: ${event['category']}",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 234, 208, 225),
                          ),  
                        ),
                      ],
                    ),
                  ),

                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: const Color.fromARGB(255, 183, 211, 83)),
                        onPressed: () => _navigateToUpdateEvent(event['id']),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Color.fromARGB(255, 104, 9, 9)),
                        onPressed: () => _navigateToDeleteEvent(event['id']),
                      ),
                    ],
                  ),      
                ],
              ),
            ),
          );          
        },
      ),
    );
  }
}