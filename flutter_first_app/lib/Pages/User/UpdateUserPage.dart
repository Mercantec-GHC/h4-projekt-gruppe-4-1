import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_first_app/config/api_config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';  // Import the secure storage package
import 'dart:async';
import 'dart:convert'; // To decode the JSON response
import 'package:flutter_first_app/Pages/Event/SeeAllEvents.dart'; // Import SeeAllEvents page

// Create an instance of FlutterSecureStorage
final FlutterSecureStorage secureStorage = FlutterSecureStorage();

class UpdateUserPage extends StatefulWidget {
  @override
  _UpdateUserPageState createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // User information variables
  String? userId;
  String firstName = '';
  String lastName = '';
  String email = '';
  String username = '';
  String address = '';
  String postal = '';
  String city = '';
  File? profileImage;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data when the page is initialized
  }

  Future<void> _loadUserData() async {
    // Retrieve userId and token from secure storage
    userId = await secureStorage.read(key: 'userId');  // Retrieve userId
    String? token = await secureStorage.read(key: 'token');  // Retrieve token

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
        firstName = userData['firstName'] ?? '';
        lastName = userData['lastName'] ?? '';
        email = userData['email'] ?? '';
        username = userData['username'] ?? '';
        address = userData['address'] ?? '';
        postal = userData['postal'] ?? '';
        city = userData['city'] ?? '';
      });
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<void> updateUser(
    String userId,
    String firstName,
    String lastName,
    String email,
    String username,
    String address,
    String postal,
    String city,
    File? image,
  ) async {
    final String baseUrl = ApiConfig.apiUrl; 
    final request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/api/User/Update/$userId'));

    // Add fields
    request.fields['firstname'] = firstName;
    request.fields['lastname'] = lastName;
    request.fields['email'] = email;
    request.fields['username'] = username;
    request.fields['address'] = address;
    request.fields['postal'] = postal;
    request.fields['city'] = city;

    // Attach the image if it exists
    if (image != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'profilePicture',
          await image.readAsBytes(),
          filename: image.path.split('/').last,
        ),
      );
    }

    // Get the token from secure storage and attach it
    final String? token = await secureStorage.read(key: 'token');
    if (token != null) {
      request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print("User updated successfully: $responseBody");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User updated successfully')));
      } else {
        final responseBody = await response.stream.bytesToString();
        throw Exception('Failed to update user. Status code: ${response.statusCode}, Response: $responseBody');
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // Image picker function
  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update User"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Back arrow icon
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SeeAllEvents()), // Navigate to SeeAllEvents
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // First Name
              TextFormField(
                decoration: InputDecoration(labelText: "First Name"),
                initialValue: firstName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
                onSaved: (value) {
                  firstName = value!;
                },
              ),

              // Last Name
              TextFormField(
                decoration: InputDecoration(labelText: "Last Name"),
                initialValue: lastName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
                onSaved: (value) {
                  lastName = value!;
                },
              ),

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

              // Address
              TextFormField(
                decoration: InputDecoration(labelText: "Address"),
                initialValue: address,
                onSaved: (value) {
                  address = value!;
                },
              ),

              // Postal
              TextFormField(
                decoration: InputDecoration(labelText: "Postal Code"),
                initialValue: postal,
                onSaved: (value) {
                  postal = value!;
                },
              ),

              // City
              TextFormField(
                decoration: InputDecoration(labelText: "City"),
                initialValue: city,
                onSaved: (value) {
                  city = value!;
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
                    // Call the update user function
                    if (userId != null) {
                      updateUser(
                        userId!,
                        firstName,
                        lastName,
                        email,
                        username,
                        address,
                        postal,
                        city,
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