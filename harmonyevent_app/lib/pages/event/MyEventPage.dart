import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:harmonyevent_app/config/token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
      // Get JWT token from secure storage
      //String? token = await _secureStorage.read(key: 'token');
      String? token = mytoken;
      if (token == null) {
        throw Exception("Authentication token not found");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //GETs CUSTOM MAIN APPBAR FROM /components/custom_mainappbar.dart
      appBar: CustomMainAppBar(),
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
                        title: Text(event['title']),
                        subtitle: Text(event['description']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _navigateToUpdateEvent(event['id']),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _navigateToDeleteEvent(event['id']),
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