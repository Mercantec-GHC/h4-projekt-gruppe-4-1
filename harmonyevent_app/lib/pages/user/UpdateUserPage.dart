import 'dart:io';
import 'package:flutter/material.dart';
import 'package:harmonyevent_app/config/api_config.dart';
import 'package:harmonyevent_app/config/auth_workaround.dart';
import 'package:harmonyevent_app/pages/user/UserProfilePage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';  // Import the secure storage package
import 'dart:async';
import 'dart:convert'; // To decode the JSON response
import 'package:harmonyevent_app/pages/event/EventPage.dart'; // Import SeeAllEvents page
import 'package:flutter_gradient_button/flutter_gradient_button.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// Create an instance of FlutterSecureStorage
final FlutterSecureStorage secureStorage = FlutterSecureStorage();

class UpdateUserPage extends StatefulWidget {
  @override
  _UpdateUserPageState createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  final _formKey = GlobalKey<FormState>();
      //File? profilePicture; // To store the selected image
  //final picker = ImagePicker(); // Image picker instance
  //final ImagePicker _picker = ImagePicker();
    final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmEmailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
    bool _isLoading = false;

// Function to pick an image
//  Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         profilePicture = File(pickedFile.path); // Save the selected image
//       });
//     }
//   }
  // User information variables
  String? userId;
  String email = '';
  String username = '';
  String password = '';
  //File? profileImage;

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
        password = userData['password'] ?? '';

      });
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<void> updateUser(
    String userId,
    String email,
    String username,
    String password,

    //File? image,
  ) async {
    final String baseUrl = ApiConfig.apiUrl; 
    final request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/api/User/Update/$userId'));

    // Add fields
    request.fields['email'] = email;
    request.fields['username'] = username;
    request.fields['password'] = password;

    // Attach the image if it exists
    // if (image != null) {
    //   request.files.add(
    //     http.MultipartFile.fromBytes(
    //       'profilePicture',
    //       await image.readAsBytes(),
    //       filename: image.path.split('/').last,
    //     ),
    //   );
    // }

    // Get the token from secure storage and attach it
    //final String? token = await secureStorage.read(key: 'token');
    final String? token = mytoken;
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
  // Future<void> pickImage() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       profileImage = File(pickedFile.path);
  //     });
  //   }
  // }

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
              // First Name
              Column(    
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [   
                                // _pickImage == null
                                // ? Text('No image selected.')
                                // : Image.file(_pickImage!),
                                // const SizedBox(height: 16),
                                //   ElevatedButton(
                                //     onPressed: _pickImage,
                                //     child: const Text("Select Profile Picture"),
                                //   ), 
                              TextFormField(
                                style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
                                controller: _userNameController,
                                decoration: InputDecoration(
                                  labelText: "New Username",
                                  labelStyle: TextStyle(color: const Color.fromARGB(255, 183, 211, 83), fontSize: 16.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please re-enter new username";
                                  }
                                return null;
                                },
                              ),
                               const SizedBox(height: 20),
                               TextFormField(
                            style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: "New Email",
                              labelStyle: TextStyle(color: const Color.fromARGB(255, 183, 211, 83), fontSize: 16.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your email";
                              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                return "Please enter a valid email";
                              }
                              return null;
                            },
                          ),
                          //const SizedBox(height: 15),
                          TextFormField(
                            style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
                            controller: _confirmEmailController,
                            decoration: InputDecoration(
                              labelText: "Confirm new Email",
                              labelStyle: TextStyle(color: const Color.fromARGB(255, 183, 211, 83), fontSize: 16.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please confirm your email";
                              } else if (value != _emailController.text) {
                                return "Emails does not match";
                              }
                              return null;
                            },
                          ),
                              const SizedBox(height: 15),
                              TextFormField(
                                style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  labelText: "Choose new Password",
                                  labelStyle: TextStyle(color: const Color.fromARGB(255, 183, 211, 83), fontSize: 16.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter your password";
                                  } else if (value.length < 6) {
                                    return "Password must be at least 6 characters long";
                                  }
                                  return null;
                                },
                              ),
                        
                              TextFormField(
                                style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
                                controller: _confirmPasswordController,
                                decoration: InputDecoration(
                                  labelText: "Confirm new Password",
                                  labelStyle: TextStyle(color: const Color.fromARGB(255, 183, 211, 83), fontSize: 16.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please confirm your password";
                                  } else if (value != _passwordController.text) {
                                    return "Passwords do not match";
                                  }
                                  return null;
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
                                    // Call the update user function
                                    if (userId != null) {
                                      updateUser(
                                        userId!,
                                        email,
                                        username,
                                        password,
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
          
              // Submit button
             
            ],
          ),
        ),
      ),
    );
  }
}