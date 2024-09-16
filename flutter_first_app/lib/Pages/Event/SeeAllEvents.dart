import 'package:flutter/material.dart';
import 'package:flutter_first_app/Http/User/loginuser.dart';
import 'package:flutter_first_app/Pages/Event/MyEventsPage.dart';
import 'package:flutter_first_app/Pages/User/DeleteUserPage.dart';
import 'package:flutter_first_app/Pages/User/UpdateUserPage.dart';
import 'package:flutter_first_app/Pages/User/LoginPage.dart'; // Import the LoginPage
import 'package:flutter_first_app/Pages/Event/EventPage.dart'; // Correct the import for CreateEvent
import 'package:flutter_first_app/config/api_config.dart';
import 'package:flutter_first_app/models/event.dart'; // Import the updated EventDTO model
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_first_app/Pages/Event/EventDetailsScreen.dart'; // Import EventDetailsScreen


class SeeAllEvents extends StatefulWidget {
  const SeeAllEvents({super.key});

  @override
  State<SeeAllEvents> createState() => _SeeAllEventsState();
}

class _SeeAllEventsState extends State<SeeAllEvents> {
  late Future<List<EventDTO>> eventsFuture;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final AuthService _authService = AuthService(); // Create an instance of AuthService
  var selectedIndex = 4; // Keep default as SeeAllEvents

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

  // Logout function
  Future<void> logout() async {
    await _secureStorage.delete(key: 'token'); // Remove the stored token
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to the LoginPage
      (Route<dynamic> route) => false, // Remove all previous routes
    );
  }

  // Navigation logic based on selected index
  void _navigateToPage(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => DeleteUserPage()));
      case 1:
        _navigateToUpdateUserPage(context);
      case 2:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => CreateEvent())); // Fixed import
      case 3:
        _navigateToMyEventsPage(context);
      case 4:
        setState(() {}); // Do nothing, stay on SeeAllEvents
      default:
        throw UnimplementedError('No widget for $selectedIndex');
    }
  }

  // Navigate to UpdateUserPage with token validation
   void _navigateToUpdateUserPage(BuildContext context) async {
  final token = await _authService.getToken();
  print('Token retrieved: $token'); // Debugging statement

  if (token != null && !_authService.isTokenExpired(token)) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateUserPage()),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User not logged in or token expired')),
    );
  }
}

 void _navigateToMyEventsPage(BuildContext context) async {
  final token = await _authService.getToken();
  print('Token retrieved: $token'); // Debugging statement

  if (token != null && !_authService.isTokenExpired(token)) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyEventsPage()),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User not logged in or token expired')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("See All Events"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Navigate back to the previous page
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: logout, // Call the logout function
              tooltip: 'Logout',
            ),
          ],
        ),
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.delete),
                    label: Text("Delete Users"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.update),
                    label: Text("Update Users"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.event),
                    label: Text("Plan Event"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.my_library_books),
                    label: Text("My Events"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.event_available),
                    label: Text("See All Events"),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (int index) {
                  setState(() {
                    selectedIndex = index;
                  });
                  _navigateToPage(index); // Navigate based on selection
                },
              ),
            ),
            Expanded(
              child: _buildPage(),
            ),
          ],
        ),
      );
    });
  }

  // Build the SeeAllEvents page content
  Widget _buildPage() {
    return FutureBuilder<List<EventDTO>>(
      future: eventsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Failed to load events."));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return _buildEventsList(snapshot.data!);
        } else {
          return const Center(child: Text("No events available."));
        }
      },
    );
  }

  // Build the events list
  Widget _buildEventsList(List<EventDTO> events) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventDetailsScreen(
                  eventId: event.id,
                  title: event.title,
                ),
              ),
            );
          },
          child: Container(
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
                    event.EventPicture,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image, size: 100);
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
                        event.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text('Place ID: ${event.place_id}'),
                      Text('Date: ${event.date}'),
                      Text('Private: ${event.isprivate}'),
                      Text('Category: ${event.category}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}