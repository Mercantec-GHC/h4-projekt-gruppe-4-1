
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_gradient_button/flutter_gradient_button.dart';

import 'package:harmonyevent_app/components/custom_mainappbar.dart';
import 'package:harmonyevent_app/config/auth_workaround.dart';
import 'package:harmonyevent_app/models/user_model.dart';
import 'package:harmonyevent_app/services/fetch_service.dart';
import 'package:harmonyevent_app/services/login_service.dart';

import 'package:harmonyevent_app/pages/user/LoginPage.dart';
import 'package:harmonyevent_app/pages/user/UpdateUserPage.dart';
import 'package:harmonyevent_app/pages/user/DeleteUserPage.dart';


class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}
class _UserProfilePageState extends State<UserProfilePage> {
  //late Future<List<UserDTO>> usersFuture;
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    //usersFuture = fetchUsers(); // Fetch users in initState
  }

  bool EventIsDueChecked = false;
  bool NewEventAddedChecked = false;

  // Logout function
  Future<void> logout() async {
    await _secureStorage.delete(key: 'token'); // Remove the stored token
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to the LoginPage
      (Route<dynamic> route) => false, // Remove all previous routes
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomMainAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 70),
        child: Center(
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    Container(
                      width: 250,
                      child: CircleAvatar(
                        backgroundColor: const Color.fromARGB(255, 183, 211, 83),
                        radius: 40,
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: ClipOval (
                            child: Image.network(
                              "https://eventharmoni.mercantec.tech/eventharmoni/PPc0c029f2f1fc462eadaf7178f6c6dd74.png",                             
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image, size: 200); // Handle broken images
                              },
                            ), 
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "RayTheMan",
                      style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 183, 211, 83),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "ray@bradbury.com",
                      style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 183, 211, 83),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 86.0, right: 86.0),
                child: SwitchListTile(
                  hoverColor: const Color.fromARGB(255, 36, 51, 6),
                  activeColor: Color.fromARGB(255, 234, 208, 225),
                  inactiveThumbColor: Color.fromARGB(255, 234, 208, 225),
                  activeTrackColor: const Color.fromARGB(255, 183, 211, 83),
                  inactiveTrackColor: const Color.fromARGB(255, 234, 208, 225),
                  title: const Text(
                    "New event added",
                    style: TextStyle(
                      color: Color.fromARGB(255, 234, 208, 225),
                      fontSize: 14,
                    ),
                    selectionColor: const Color.fromARGB(255, 183, 211, 83),
                  ),
                  secondary: const SizedBox(
                    child: Icon(
                      Icons.notifications_none,
                      color: const Color.fromARGB(255, 183, 211, 83),
                      size: 32,
                    ),
                  ),
                  value: NewEventAddedChecked,         
                  onChanged: (value) {
                    setState(() {
                      NewEventAddedChecked = value;
                      //_isPrivateController.text = value.toString();
                      print(value);
                    },);
                  }
                ),
              ), 
              Padding(
                padding: const EdgeInsets.only(left: 86.0, right: 86.0),
                child: SwitchListTile(
                  hoverColor: const Color.fromARGB(255, 36, 51, 6),
                  activeColor: Color.fromARGB(255, 234, 208, 225),
                  inactiveThumbColor: Color.fromARGB(255, 234, 208, 225),
                  activeTrackColor: const Color.fromARGB(255, 183, 211, 83),
                  inactiveTrackColor: const Color.fromARGB(255, 234, 208, 225),
                  title: const Text(
                    "Event is due",
                    style: TextStyle(
                      color: Color.fromARGB(255, 234, 208, 225),
                      fontSize: 14,
                    ),
                    selectionColor: const Color.fromARGB(255, 183, 211, 83),
                  ),
                  secondary: const SizedBox(
                    child: Icon(
                      Icons.notifications_none,
                      color: const Color.fromARGB(255, 183, 211, 83),
                      size: 32,
                    ),
                  ),
                  value: EventIsDueChecked,         
                  onChanged: (value) {
                    setState(() {
                      EventIsDueChecked = value;
                      //_isPrivateController.text = value.toString();
                      print(value);
                    },);
                  }
                ),
              ), 
              
              const SizedBox(height: 30),
              GradientButton(
                colors: [const Color.fromARGB(255, 183, 211, 54), const Color.fromARGB(255, 109, 190, 66)],
                height: 40,
                width: 350,
                radius: 20,
                gradientDirection: GradientDirection.leftToRight,
                textStyle:  TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
                text: "Edit Profile",
                onPressed: () async {
                  //final token = await _authService.getToken();
                  final token = mytoken;
                  print('Token retrieved: $token'); // Debugging statement
                  if (token != null && !_authService.isTokenExpired(token)) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => UpdateUserPage()),
                  );
                  } 
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('User not logged in or token expired')),
                    );
                  }
                }
              ),

              SizedBox(height: 20),
              GradientButton(
                colors: [const Color.fromARGB(255, 183, 211, 54), const Color.fromARGB(255, 109, 190, 66)],
                height: 40,
                width: 350,
                radius: 20,
                gradientDirection: GradientDirection.leftToRight,
                textStyle:  TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
                text: "Delete Profile",
                onPressed: () async {
                  //final token = await _authService.getToken();
                  final token = mytoken;
                  print('Token retrieved: $token'); // Debugging statement
                  if (token != null && !_authService.isTokenExpired(token)) {
                  Navigator.push(
                    context,                      
                    MaterialPageRoute(
                      builder: (context) => DeleteUserPage()),
                    );
                  } 
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('User not logged in or token expired')),
                    );
                  }
                }            
              ),
            ],
          ),
        ),
      ),
    );
  }
}
  // Navigate to UpdateUserPage with token validation
  // void _navigateToUpdateUserPage(BuildContext context) async {
  //   final token = await _authService.getToken();
  //   print('Token retrieved: $token'); // Debugging statement

  //   if (token != null && !_authService.isTokenExpired(token)) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => UpdateUserPage()),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('User not logged in or token expired')),
  //     );
  //   }
  // }