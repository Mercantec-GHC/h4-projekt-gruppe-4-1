import 'package:flutter/material.dart';
import 'package:flutter_first_app/Http/User/loginuser.dart';
import 'package:flutter_first_app/models/event.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_first_app/Pages/Event/UpdateEvent.dart';
import 'package:flutter_first_app/Pages/Event/DeleteEventPage.dart';
import 'package:flutter_first_app/Pages/Event/SeeAllEvents.dart'; 
import 'package:flutter_first_app/config/api_config.dart';


class MyEventsPage extends StatefulWidget {
  @override
  _MyEventsPageState createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final AuthService _authService = AuthService();
  List<EventDTO> _userEvents = [];
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
    // Get JWT token and user ID from secure storage
    final String? userId = await _secureStorage.read(key: 'userId');
    final String? token = await _secureStorage.read(key: 'jwt'); // Ensure the key is correct

    // Debugging statements
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
    final url = Uri.parse('${ApiConfig.apiUrl}/api/Event/creator/$userId');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      setState(() {
        _userEvents = data.map((json) => EventDTO.fromJson(json)).toList(); // Parse JSON into EventDTO objects
      });
    } else {
      throw Exception('Failed to load events');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  } finally {
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

  // Method to return to the SeeAllEventsPage
  void _returnToSeeAllEventsPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SeeAllEvents(), // Return to SeeAllEventsPage
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Events'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _returnToSeeAllEventsPage, // Call method to return to SeeAllEventsPage
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : _userEvents.isEmpty
              ? Center(child: Text('You have no events'))
              : ListView.builder(
                  itemCount: _userEvents.length,
                  itemBuilder: (context, index) {
                    final event = _userEvents[index];
                    return Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: ListTile(
                        title: Text(event.title),
                        subtitle: Text(event.description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _navigateToUpdateEvent(event.id),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _navigateToDeleteEvent(event.id),
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