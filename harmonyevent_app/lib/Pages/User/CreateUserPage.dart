import 'dart:io';
import 'dart:convert'; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:harmonyevent_app/config/api_config.dart'; 
import 'package:harmonyevent_app/models/user.dart'; 
import 'package:status_alert/status_alert.dart';
import 'package:harmonyevent_app/main.dart';
import 'package:harmonyevent_app/Pages/User/LoginPage.dart';
import 'package:flutter_gradient_button/flutter_gradient_button.dart';

class CreateUserPage extends StatefulWidget {
  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

void showSuccessAlert(BuildContext context) {     
  StatusAlert.show( 
    context, 
    duration: Duration(seconds: 4), 
    title: 'Success',
    subtitle: 'User created successfully!', 
    configuration: IconConfiguration(
      icon: Icons.check,
      color: const Color.fromARGB(255, 162, 235, 14),
              size: 180.0,
      ), 
    backgroundColor: const Color.fromARGB(255, 36, 51, 6),
    // borderRadius: BorderRadius.circular(10),
  ); 
} 
void showErrorAlert(BuildContext context) { 
  StatusAlert.show( 
    context, 
    duration: Duration(seconds: 2), 
    title: 'Failed to create user!', 
    subtitle: 'Please try again.', 
    configuration: IconConfiguration(
      icon: Icons.block_rounded,
      color: const Color.fromARGB(255, 162, 235, 14),
      size: 180.0,
      ), 
    backgroundColor: const Color.fromARGB(0, 0, 0, 0),
  ); 
} 

class _CreateUserPageState extends State<CreateUserPage> {
  final _formKey = GlobalKey<FormState>(); 
  final _formKeyNext = GlobalKey<FormState>(); 
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmEmailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postalController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  File? _image;
 // bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<CreateUserDTO> createUser(
      String firstname,
      String lastname,
      String email,
      String username,
      String password,
      String address,
      String postal,
      String city,
      File? image
    ) async {
    final String baseUrl = ApiConfig.apiUrl;
    final uri = Uri.parse('$baseUrl/api/user/signup');
    final request = http.MultipartRequest('POST', uri);

    request.fields['firstname'] = firstname;
    request.fields['lastname'] = lastname;
    request.fields['email'] = email;
    request.fields['username'] = username;
    request.fields['password'] = password;
    request.fields['address'] = address;
    request.fields['postal'] = postal;
    request.fields['city'] = city;

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

      return CreateUserDTO.fromJson(jsonDecode(responseBody) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to create user: ${response.statusCode}'); 
    }
  }

  void _createUser() async {
    if (_formKey.currentState!.validate() || _formKeyNext.currentState!.validate()) {

      final String firstName = _firstNameController.text;
      final String lastName = _lastNameController.text;
      final String email = _emailController.text;
      final String username = _userNameController.text;
      final String password = _passwordController.text;
      final String address = _addressController.text;
      final String postal = _postalController.text;
      final String city = _cityController.text;

      final CreateUserDTO newUser = await createUser(
        firstName, lastName, email, username, password, address, postal, city, _image);

      try {
        showSuccessAlert(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()), // Replace with the correct page
        );  
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("User ${newUser.username} created successfully."),
          ),   
        );

      } catch (e) {
          showErrorAlert(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to create user: $e"),
            ),
        );
        
      } 
    }
  }

  // @override
  // void dispose() {
  //   _firstNameController.dispose();
  //   _lastNameController.dispose();
  //   _emailController.dispose();
  //   _confirmEmailController.dispose();
  //   _userNameController.dispose();
  //   _passwordController.dispose();
  //   _confirmPasswordController.dispose();
  //   _addressController.dispose();
  //   _postalController.dispose();
  //   _cityController.dispose();
  //   super.dispose();
  // }

  // Future<LoginDTO> createUser(
  //   String firstname,
  //   String lastname,
  //   String email,
  //   String username,
  //   String password,
  //   String address,
  //   String postal,
  //   String city) async {
  //     final String baseUrl = ApiConfig.apiUrl;
  //     final response = await http.post(
  //       Uri.parse('$baseUrl/api/user/signup'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //     body: jsonEncode(<String, String>{
  //       'firstname': firstname,
  //       'lastname': lastname,
  //       'email': email,
  //       'username': username,
  //       'password': password,
  //       'address': address,
  //       'postal': postal,
  //       'city': city
  //     }),
  //   );
  //   if (response.statusCode == 201) {
  //     return LoginDTO.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      
  //   } else {
  //     throw Exception('Failed to create user: ${response.statusCode} - ${response.body}');
  //   }
  // }

  // void _createUser() async {
  //   // if (_formKey.currentState!.validate() || _formKeyNext.currentState!.validate()) {
  //   if (_formKeyNext.currentState!.validate()) {
  //     final String firstName = _firstNameController.text;
  //     final String lastName = _lastNameController.text;
  //     final String email = _emailController.text;
  //     final String username = _userNameController.text;
  //     final String password = _passwordController.text;
  //     final String address = _addressController.text;
  //     final String postal = _postalController.text;
  //     final String city = _cityController.text;

  //     try {
  //       final LoginDTO newUser = await createUser(
  //           firstName, lastName, email, username, password, address, postal, city);

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text("User ${newUser.username} created successfully."),
  //         ),
  //       );
  //       showSuccessAlert(context);
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => LoginPage()), // Replace with the correct page
  //       );
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text("Failed to create user: ${e}"),
  //         ),
  //       );
  //       showErrorAlert(context);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        color: const Color.fromARGB(255, 234, 208, 225),
        
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()), // Replace with the correct page
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
      body: Stack(
        children: [
          Center(
            child: SafeArea(
              //padding: EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(left: 66.0, right: 66.0),
                    child: Form(
                      key: _formKey,
                      child: Column(    
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              labelText: "First Name",
                              labelStyle: TextStyle(color: const Color.fromARGB(255, 183, 211, 83), fontSize: 16.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your first name";
                              }
                            return null;
                            },
                          ),
                          //const SizedBox(height: 15),
                          TextFormField(
                            style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
                            controller: _lastNameController,
                            decoration: InputDecoration(
                              labelText: "Last Name",
                              labelStyle: TextStyle(color: const Color.fromARGB(255, 183, 211, 83), fontSize: 16.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your last name";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
                            controller: _addressController,
                            decoration: InputDecoration(
                              labelText: "Address",
                              labelStyle: TextStyle(color: const Color.fromARGB(255, 183, 211, 83), fontSize: 16.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your address";
                            }
                            return null;
                            },
                          ),
                          //const SizedBox(height: 15),
                          TextFormField(
                            style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
                            controller: _postalController,
                            decoration: InputDecoration(
                              labelText: "Postal",
                              labelStyle: TextStyle(color: const Color.fromARGB(255, 183, 211, 83), fontSize: 16.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your postal code";
                              }
                            return null;
                            },
                          ),
                          //const SizedBox(height: 15),
                          TextFormField(
                             style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
                            controller: _cityController,
                            decoration: InputDecoration(
                              labelText: "City",
                              labelStyle: TextStyle(color: const Color.fromARGB(255, 183, 211, 83), fontSize: 16.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your city";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
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
                              labelText: "Confirm Email",
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
                          //StandardPadding(),
                          const SizedBox(height: 20),
                          Builder(
                            builder: (context) {
                              return GradientButton(
                                colors: [const Color.fromARGB(255, 183, 211, 54), const Color.fromARGB(255, 109, 190, 66)],
                                height: 40,
                                width: 300,
                                radius: 20,
                                gradientDirection: GradientDirection.leftToRight,
                                textStyle: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
                                text: "Continue",
                                onPressed:  () {
                                  if (_formKey.currentState!.validate()) {
                                    Scaffold.of(context).openDrawer();
                                  }
                                },
                              );
                            },
                          ),   
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: Container(
        width: MediaQuery.of(context).size.width,
        child: Drawer( 
          backgroundColor: const Color.fromARGB(255, 36, 51, 6),
          child: Stack(
            children: [
              SafeArea(
                //padding: const EdgeInsets.all(18.0),
                child: Container(
                  // color: const Color.fromARGB(255, 89, 99, 44),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 89, 99, 44),
                     boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(85, 6, 6, 6),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2.5),
                        ).scale(1)
                     ],
                    ),
                  child: Row(
                  
                    children: [
                      Builder(
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              color: const Color.fromARGB(255, 234, 208, 225),
                              onPressed: () {
                                Scaffold.of(context).closeDrawer();
                              },
                            ),
                          );
                        }
                      ),
                      Container(
                         margin: EdgeInsets.only(left: 15),
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
                            fontSize: 20,
                          ),
                        ),  
                      ),  
                    ],
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 500),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(66.0),
                          child: Form(
                            key: _formKeyNext,
                            child: Column(    
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [   
                                _image == null
                                ? Text('No image selected.')
                                : Image.file(_image!),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                onPressed: _pickImage,
                                child: const Text("Select Profile Picture"),
                                ), 
                            StandardPadding(),
                            TextFormField(
                              style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
                              controller: _userNameController,
                              decoration: InputDecoration(
                                labelText: "Choose username",
                                labelStyle: TextStyle(color: const Color.fromARGB(255, 183, 211, 83), fontSize: 16.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter new username";
                                }
                              return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: "Choose Password",
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
                            const SizedBox(height: 15),
                            TextFormField(
                              style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
                              controller: _confirmPasswordController,
                              decoration: InputDecoration(
                                labelText: "Confirm Password",
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
                            GradientButton(
                              colors: [const Color.fromARGB(255, 183, 211, 54), const Color.fromARGB(255, 109, 190, 66)],
                              height: 40,
                              width: 300,
                              radius: 20,
                              gradientDirection: GradientDirection.leftToRight,
                              textStyle: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
                              text: "Create user",
                              onPressed: _createUser, 
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}