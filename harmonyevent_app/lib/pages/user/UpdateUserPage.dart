
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';  // Import the secure storage package
//import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gradient_button/flutter_gradient_button.dart';

import 'package:harmonyevent_app/config/auth_workaround.dart';
import 'package:harmonyevent_app/config/api_config.dart';
import 'package:harmonyevent_app/services/login_service.dart';
import 'package:harmonyevent_app/pages/user/UserProfilePage.dart';
import 'package:harmonyevent_app/pages/user/DeleteUserPage.dart';

// Create an instance of FlutterSecureStorage
final FlutterSecureStorage secureStorage = FlutterSecureStorage();

class UpdateUserPage extends StatefulWidget {
  @override
  _UpdateUserPageState createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final AuthService _authService = AuthService(); // Create an instance of AuthService
  bool _isLoading = false;

  // User information variables
  String? userId;
  String email = '';
  String username = '';
  File? profileImage;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data when the page is initialized
  }

  Future<void> _loadUserData() async {
    // Retrieve userId and token from secure storage
    // userId = await secureStorage.read(key: 'userId');  // Retrieve userId
    // String? token = await secureStorage.read(key: 'token');  // Retrieve token
    userId = myid;  // Retrieve userId
    String? token = mytoken;

    if (userId == null || token == null) {
      // Handle the case where no userId or token is stored
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User not logged in')));
      return;
    }

    final String baseUrl = ApiConfig.apiUrl; 
    final response = await http.get(
      Uri.parse('$baseUrl/api/user/update/$userId'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Parse the user data from the response
      final userData = jsonDecode(response.body);
      setState(() {

        email = userData['email'] ?? '';
        username = userData['username'] ?? '';
      });
    } 
    else {
      throw Exception('Failed to load user data');
    }
  }

   Future<void> updateUser(
    String userId,
    String email,
    String username,
    File? profileImage,
  ) async {
    const String baseUrl = ApiConfig.apiUrl;
    final url = Uri.parse('$baseUrl/api/User/update/$userId');

    final Map<String, dynamic> userData = {
      'id': userId,
      'email': email,
      'username': username,
      'ProfilePicture': profileImage != null ? base64Encode(await profileImage.readAsBytes()) : '', 
    };

    final String? token = await secureStorage.read(key: 'jwt');
    final response = await http.put(
      url,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User updated successfully')));
      Navigator.pop(context); // Navigate back after successful update
    } else {
      throw Exception('Failed to update user. Status code: ${response.statusCode}, Response: ${response.body}');
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        profileImage = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color.fromARGB(255, 234, 208, 225)),
            onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => UserProfilePage()),
            );
          },
        ),
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
      body: Padding(
      padding: const EdgeInsets.all(16.0),
        child: Form(
        key: _formKey,
          child: ListView(
            children: <Widget>[

              
                            // Image picker
              SizedBox(height: 20),
              profileImage != null
                  ? Image.file(profileImage!, height: 100, width: 100)
                  : Text('No image selected',
                  style: TextStyle(
                   color: const Color.fromARGB(255, 183, 211, 83)
                  ),
                  ),
              ElevatedButton(
                onPressed: pickImage,
                child: Text('Pick new profile Image'),
              ),
                     const SizedBox(height: 20),         // Username
              TextFormField(
                  style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
                decoration: InputDecoration(
                  labelText: "New Username",
                  labelStyle: TextStyle(color: const Color.fromARGB(255, 183, 211, 83), fontSize: 16.0),               
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),                                              
                              ),
                  ),
                initialValue: username,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter new username';
                  }
                  return null;
                },
                onSaved: (value) {
                  username = value!;
                },
              ),
                const SizedBox(height: 20),
              Column(    
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [   
                  TextFormField(
                      style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
                decoration: InputDecoration(
                  labelText: "New Email",
                  labelStyle: TextStyle(color: const Color.fromARGB(255, 183, 211, 83), fontSize: 16.0),               
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),                                              
                              ),
                  ),
                initialValue: email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter new email';
                  }
                  return null;
                },
                onSaved: (value) {
                  email = value!;
                },
              ),




                  const SizedBox(height: 20),
                  _isLoading ? Center(child: CircularProgressIndicator()) : GradientButton(
                    colors: [const Color.fromARGB(255, 183, 211, 54), const Color.fromARGB(255, 109, 190, 66)],
                    height: 40,
                    width: 300,
                    radius: 20,
                    gradientDirection: GradientDirection.leftToRight,
                    textStyle: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
                    text: "Update Profile",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        if (userId != null) {
                          updateUser(
                            userId!,
                            email,
                            username,
                            profileImage,
                          );
                        }
                      }
                    },
                  ),
                  Center(
                    child: Container(
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          Text(
                            "Delete Profile",
                            style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 234, 208, 225),
                          ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.do_disturb_alt_sharp, 
                              color: const Color.fromARGB(255, 198, 27, 27),
                              size: 25,
                            ),
                            tooltip: "Delete Profle",
                            onPressed: () {
                              Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => DeleteUserPage()), // Replace with the correct page
                              );
                            }
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ), 
            ],
          ),
        ),
      ),
    );
  }
}