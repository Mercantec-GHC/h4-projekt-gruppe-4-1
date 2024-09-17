import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_first_app/config/api_config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_first_app/Http/User/loginuser.dart';

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
    userId = await secureStorage.read(key: 'userId');
    String? token = await secureStorage.read(key: 'jwt'); // Use 'jwt' key
    print('User ID retrieved: $userId'); // Debugging statement
    print('Token retrieved in UpdateUserPage: $token'); // Debugging statement

    if (userId == null) {
      print('User ID or token is null');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User not logged in or token expired')));
      Navigator.pop(context); // Navigate back if user is not logged in or token is expired
      return;
    }

    if (_authService.isTokenExpired(token!)) {
      print('Token is expired');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User not logged in or token expired')));
      Navigator.pop(context); // Navigate back if user is not logged in or token is expired
      return;
    }

    const String baseUrl = ApiConfig.apiUrl;
    final response = await http.get(
      Uri.parse('$baseUrl/api/User/$userId'), // Correct endpoint to fetch user data
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
    } else {
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
        title: Text('Update User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // Email
              TextFormField(
                decoration: InputDecoration(labelText: "Email"),
                initialValue: email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) {
                  email = value!;
                },
              ),

              // Username
              TextFormField(
                decoration: InputDecoration(labelText: "Username"),
                initialValue: username,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                onSaved: (value) {
                  username = value!;
                },
              ),

              // Image picker
              SizedBox(height: 20),
              profileImage != null
                  ? Image.file(profileImage!, height: 100, width: 100)
                  : Text('No image selected'),
              ElevatedButton(
                onPressed: pickImage,
                child: Text('Pick Profile Image'),
              ),

              // Submit button
              SizedBox(height: 20),
              ElevatedButton(
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
                child: Text('Update User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}