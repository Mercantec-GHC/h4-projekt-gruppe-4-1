import 'dart:io';
import 'dart:convert'; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter_first_app/config/api_config.dart'; 
import 'package:flutter_first_app/models/user.dart'; 

class CreateUserPage extends StatefulWidget {
  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final _formKey = GlobalKey<FormState>(); 
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postalController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  File? _image;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<LoginDTO> createUser(
      String firstname,
      String lastname,
      String email,
      String username,
      String password,
      String address,
      String postal,
      String city,
      File? image) async {
    final String baseUrl = ApiConfig.apiUrl;
    final uri = Uri.parse('$baseUrl/api/user/signup');
    final request = http.MultipartRequest('POST', uri);

    // Add form fields
    request.fields['firstname'] = firstname;
    request.fields['lastname'] = lastname;
    request.fields['email'] = email;
    request.fields['username'] = username;
    request.fields['password'] = password;
    request.fields['address'] = address;
    request.fields['postal'] = postal;
    request.fields['city'] = city;

    // Add image file if selected
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'ProfilePicture', 
        image.path,
        contentType: MediaType('image', 'png'),
      ));
    }

    request.headers.addAll({
      'accept': '*/*',
      'Content-Type': 'multipart/form-data',
    });

    final response = await request.send();

    if (response.statusCode == 201) {
      final responseBody = await response.stream.bytesToString();
      return LoginDTO.fromJson(jsonDecode(responseBody) as Map<String, dynamic>);
    } else {
      final responseBody = await response.stream.bytesToString();
      throw Exception('Failed to create user: ${response.statusCode} - $responseBody');
    }
  }

  void _createUser() async {
    if (_formKey.currentState!.validate()) {
      final String firstName = _firstNameController.text;
      final String lastName = _lastNameController.text;
      final String email = _emailController.text;
      final String username = _emailController.text;
      final String password = _passwordController.text;
      final String address = _addressController.text;
      final String postal = _postalController.text;
      final String city = _cityController.text;

      try {
        final LoginDTO newUser = await createUser(
            firstName, lastName, email, username, password, address, postal, city, _image);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("User ${newUser.username} created successfully."),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to create user: $e"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create User"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: "First Name"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your first name";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: "Last Name"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your last name";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: "Email"),
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
                  TextFormField(
                    controller: _confirmEmailController,
                    decoration: const InputDecoration(labelText: "Confirm Email"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please confirm your email";
                      } else if (value != _emailController.text) {
                        return "Emails do not match";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: "Password"),
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
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(labelText: "Confirm Password"),
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
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: "Address"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your address";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _postalController,
                    decoration: const InputDecoration(labelText: "Postal"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your postal code";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(labelText: "City"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your city";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _image == null
                      ? Text('No image selected.')
                      : Image.file(_image!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text("Select Profile Picture"),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _createUser, 
                    child: const Text("Create User"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
