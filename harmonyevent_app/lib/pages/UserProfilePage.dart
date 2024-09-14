import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:harmonyevent_app/config/api_config.dart';

import 'package:flutter/material.dart';
//import 'package:flutter_gradient_button/flutter_gradient_button.dart';

import 'package:harmonyevent_app/pages/CreateEventPage.dart';
import 'package:harmonyevent_app/models/user_model.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}
class _UserProfilePageState extends State<UserProfilePage> {
  late Future<List<UserDTO>> usersFuture;

  @override
  void initState() {
    super.initState();
    usersFuture = fetchUsers(); // Fetch users in initState
  }
  // Fetch users from API
  Future<List<UserDTO>> fetchUsers() async {
    const String baseUrl = ApiConfig.apiUrl;
    final url = Uri.parse('$baseUrl/api/user');
    try {
    final response = await http.get(url, headers: {"Content-Type": "application/json"});
    print('Response Status Code: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('Response Body: ${response.body}');
      final List body = json.decode(response.body);
      // Print each event DTO before returning
      final users = body.map((e) => UserDTO.fromJson(e)).toList();
      return users;
    } else {
      // Handle non-200 responses
      print('Failed to load users: ${response.statusCode}');
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  } catch (e) {
    // Handle any errors that occur during the request
    print('Error fetching users: $e');
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
        child: FutureBuilder<List<UserDTO>>(
          future: usersFuture,
          builder: (context, snapshot) {
            print('snapshot: $snapshot');
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Loading indicator while fetching data
              return const CircularProgressIndicator();
            } 
            else if (snapshot.hasError) {
              // Display error message if the Future failed
              return const Text("Failed to load users.");
            } 
            else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              // If data is available, build the event list
              final users = snapshot.data!;
              print('Test: $users');
              return buildEvents(users);
            } 
            else {
              // Display message if no data is available
              return const Text("No users available.");
            }
          },
        ),
      ),
    );
  }
  // Build the event list UI
  Widget buildEvents(List<UserDTO> users) {
    var screenSize = MediaQuery.of(context).size;
    return ListView.builder(
      //scrollDirection: Axis.horizontal,
      itemCount: users.length,
      //physics: PageScrollPhysics(),
      itemBuilder: (context, index) {
        final user = users[index];

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

                    //USER ID
                    Text(
                      "User ID: ${user.Id}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 234, 208, 225),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    //USER PROFILE
                    Container(
                      //width: 150,
                      child: Column(
                        children: [
                          Text(
                            "User: ${user.Username}",
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
                                    user.ProfilePicture,                             
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